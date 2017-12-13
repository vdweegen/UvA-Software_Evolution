from tkinter import *

import json
from filemonitor import Monitor
from threading import Thread
from pychart.draw import PyChart
from treemap.draw import TreeMap
from cloneproject import CloneProject, CloneObject
import multiprocessing
import argparse

class Monitoring(Thread):
    def __init__(self, q, path):
        Thread.__init__(self)
        self.monitor = Monitor(q, path)

    def run(self):
        self.monitor.watch()

    def kill(self):
        self.monitor.kill()


class Handler(Thread):
    project = None
    stats = {}

    def __init__(self, q, i):
        Thread.__init__(self)
        self.i = i
        self.i.add_handler(self)
        self.q = q
        self.project = CloneProject()
        self.clean_stats()

    # def addText(self, t):
    #     T = Text(self.i.frame, height=2, width=30)
    #     T.pack()
    #     T.insert(END, "Got: {}".format(t))

    def draw(self):
        for widget in self.i.frame.winfo_children():
            widget.destroy()

        if self.i.type == "treemap":
            t = TreeMap()
        elif self.i.type == "treemap2":
            t = TreeMap(True)
        elif self.i.type == "hdg":
            pass
        elif self.i.type == "scatter":
            pass
        elif self.i.type == "piechart":
            t = PyChart()
        else:
            t = TreeMap()

        # We pass ALL the values to the draw classes, maybe need to optimize a bit
        t.vals(self.project)
        t.draw(self.i.frame)
        self.update_stats()

    PROJECT_STATS = """
    Live Project Statistics
    
    Project: {}
    Location: {}
    Time: {}
    Source Lines: {}
    Lines: {}
    
    Number of Duplicated Lines: {}
    % Of Duplicated Lines: {}
    Number of Clones: {}
    Number of Clone Classes: {}
    Biggest Clone: {}
    Biggest Clone Class: {}
    """

    def clean_stats(self):
        self.stats = {
            'duplines': 0,
            'duplinesp': 0.0,
            'numclones': 0,
            'numclonec': 0,
            'biggestc': 0,
            'biggestcc': 0
        }

    def update_stats(self):
        try:
            for widget in self.i.stats_frame.winfo_children():
                widget.destroy()
            c = Canvas(self.i.stats_frame, width=300, height=700, bg="white")
            c.create_line(2, 0, 2, 700, fill="black")

            title = Label(c,
                          text=self.PROJECT_STATS.format(
                              self.project.get_name(),
                              self.project.get_location(),
                              self.project.get_time(),
                              self.project.get_sloc(),
                              self.project.get_loc(),
                              self.stats['duplines'],
                              self.stats['duplinesp'],
                              self.stats['numclones'],
                              self.stats['numclonec'],
                              self.stats['biggestc'],
                              self.stats['biggestcc']
                          ),
                          width=300,
                          height=700,
                          anchor=N,
                          justify=LEFT
                          )
            # c.itemconfig(canvas_title, text="Live Project Statistics")
            title.pack(side=LEFT)
            c.pack(side="top", fill="both")
        except Exception:
            pass

    def run(self):
        while True:
            obj = self.q.get()
            try:
                with open(obj.src_path, 'r') as _cf:
                    _content = json.loads(_cf.read())
                if str(obj.src_path.split('/')[-1]).lower() == "metadata.json":
                    print("==== RELOADING PROJECT ====")
                    self.project.reload(_content)
                    self.clean_stats()
                else:
                    _class = []
                    self.stats['numclonec'] += 1
                    totalclonelines = 0
                    for _cos in _content:
                        self.stats['numclones'] += 1
                        _co = CloneObject()
                        _co.load(_cos)
                        totalclonelines += _co.get_sloc()
                        if _co.get_sloc() > self.stats['biggestc']:
                            self.stats['biggestc'] = _co.get_sloc()
                        _class.append(_co)
                    # print("\tAdding Class with {} Clones".format(len(_content)))
                    self.stats['duplines'] += totalclonelines
                    if totalclonelines > self.stats['biggestcc']:
                        self.stats['biggestcc'] = totalclonelines
                    self.project.add_class(_class)
                self.stats['duplinesp'] = (self.stats['duplines'] / self.project.get_sloc()) * 100.0
                # print("Number of Clone Classes: {}".format(len(self.project.CLASSES)))
                # self.addText(obj.src_path)
                self.draw()
            except IsADirectoryError:
                pass
            except Exception as e:
                print(e)


class Interface(Thread):
    __handler = None
    type = "treemap"  # Default is treemap
    # type = "piechart"

    def setType(self, type):
        self.type = type
        if self.__handler:
            self.__handler.draw()

    ABOUT_TEXT = """About

    Put some fancy text here."""

    def add_handler(self, h):
        self.__handler = h

    def About(self):
        toplevel = Toplevel()
        label1 = Label(toplevel, text=self.ABOUT_TEXT, height=0, width=100)
        label1.pack()

    def __init__(self):
        Thread.__init__(self)
        self.root = Tk()
        self.menu = Menu(self.root)
        self.root.minsize(width=200, height=100)
        # self.root.maxsize(width=1000, height=700)
        self.root.config(menu=self.menu)

        # Filemenu
        self.filemenu = Menu(self.menu)
        self.filemenu.add_command(label="Exit", command=self.root.quit)

        # Visualizationmenu
        self.visualizationmenu = Menu(self.menu)
        self.visualizationmenu.add_command(label="Treemap",
                                           command=lambda: self.setType("treemap"))
        self.visualizationmenu.add_command(label="Treemap (clones only)",
                                           command=lambda: self.setType("treemap2"))
        self.visualizationmenu.add_command(label="Piechart",
                                           command=lambda: self.setType("piechart"))
        # self.visualizationmenu.add_command(label="Scatterplot",
        #                                    command=lambda: self.setType("scatter"))
        # self.visualizationmenu.add_command(label="Hierarchical Dependecy Graphy",
        #                                    command=lambda: self.setType("hdg"))

        # Helpmenu
        self.helpmenu = Menu(self.menu)
        self.helpmenu.add_command(label="About...", command=self.About)

        # Root
        self.menu.add_cascade(label="File", menu=self.filemenu)
        self.menu.add_cascade(label="View", menu=self.visualizationmenu)
        self.menu.add_cascade(label="Help", menu=self.helpmenu)

        self.frame = Frame(self.root)
        self.frame.pack(side=LEFT)
        self.stats_frame = Frame(self.root)
        self.stats_frame.pack(side=RIGHT)

    def run(self):
        self.root.mainloop()


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--debug', action='store_true', help='print debug messages to stderr')
    parser.add_argument('--path', nargs='?', const=1, type=str)
    args = parser.parse_args()
    try:
        if args.debug:
            # TestRCF
            import time
            from testrcf import TestRCF
            testrcf = TestRCF()
            testrcf.start()
            time.sleep(5)

        queue = multiprocessing.Queue()
        if args.path:
            fm = Monitoring(queue, "./{}".format(args.path))
        else:
            fm = Monitoring(queue, "./watchdir")
        fm.start()

        i = Interface()

        h = Handler(queue, i)
        h.start()

        i.run()

        fm.join()
        h.join()
    except KeyboardInterrupt:
        fm.kill()
    finally:
        fm.join()
        h.join()
        if args.debug:
            testrcf.join()

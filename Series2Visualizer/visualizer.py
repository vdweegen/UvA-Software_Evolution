from tkinter import *

import time
import json
from filemonitor import Monitor
from threading import Thread
from pychart.draw import PyChart
from treemap.draw import TreeMap
from testrcf import TestRCF
from cloneproject import CloneProject, CloneObject
import multiprocessing

class Monitoring(Thread):
    def __init__(self, q):
        Thread.__init__(self)
        self.monitor = Monitor(q)

    def run(self):
        self.monitor.watch()

    def kill(self):
        self.monitor.kill()


class Handler(Thread):
    project = None

    def __init__(self, q, i):
        Thread.__init__(self)
        self.i = i
        self.q = q
        self.project = CloneProject()

    # def addText(self, t):
    #     T = Text(self.i.frame, height=2, width=30)
    #     T.pack()
    #     T.insert(END, "Got: {}".format(t))

    def draw(self):
        for widget in self.i.frame.winfo_children():
            widget.destroy()

        if self.i.type == "treemap":
            t = TreeMap()
        elif self.i.type == "hdg":
            pass
        elif self.i.type == "scatter":
            pass
        elif self.i.type == "piechart":
            t = PyChart()
        else:
            t = TreeMap()

        t.vals(None)  # TODO: Add Percentages
        t.draw(self.i.frame)

    def run(self):
        while True:
            obj = self.q.get()
            with open(obj.src_path, 'r') as _cf:
                _content = json.loads(_cf.read())
            if str(obj.src_path.split('/')[-1]).lower() == "metadata.json":
                print("==== RELOADING PROJECT ====")
                self.project.reload(_content)
            else:
                _class = []
                for _cos in _content:
                    _co = CloneObject()
                    _co.load(_cos)
                    _class.append(_co)
                print("\tAdding Class with {} Clones".format(len(_content)))
                self.project.add_class(_class)
            print("Number of Clone Classes: {}".format(len(self.project.CLASSES)))
            # self.addText(obj.src_path)
            self.draw()


class Interface(Thread):
    type = "treemap"  # Default is treemap

    def setType(self, type):
        self.type = type

    def About(self):
        pass

    def __init__(self):
        Thread.__init__(self)
        self.root = Tk()
        self.menu = Menu(self.root)
        self.root.minsize(width=700, height=700)
        self.root.maxsize(width=700, height=700)
        self.root.config(menu=self.menu)

        # Filemenu
        self.filemenu = Menu(self.menu)
        self.filemenu.add_command(label="Exit", command=self.root.quit)

        # Visualizationmenu
        self.visualizationmenu = Menu(self.menu)
        self.visualizationmenu.add_command(label="Treemap",
                                           command=lambda: self.setType("treemap"))
        self.visualizationmenu.add_command(label="Piechart",
                                           command=lambda: self.setType("piechart"))
        self.visualizationmenu.add_command(label="Scatterplot",
                                           command=lambda: self.setType("scatter"))
        self.visualizationmenu.add_command(label="Hierarchical Dependecy Graphy",
                                           command=lambda: self.setType("hdg"))

        # Helpmenu
        self.helpmenu = Menu(self.menu)
        self.helpmenu.add_command(label="About...", command=self.About)

        # Root
        self.menu.add_cascade(label="File", menu=self.filemenu)
        self.menu.add_cascade(label="View", menu=self.visualizationmenu)
        self.menu.add_cascade(label="Help", menu=self.helpmenu)

        self.frame = Frame(self.root)
        self.frame.pack()

    def run(self):
        self.root.mainloop()


if __name__ == "__main__":
    try:
        # TestRCF
        testrcf = TestRCF()
        testrcf.start()
        time.sleep(5)

        queue = multiprocessing.Queue()
        fm = Monitoring(queue)
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
        testrcf.join()

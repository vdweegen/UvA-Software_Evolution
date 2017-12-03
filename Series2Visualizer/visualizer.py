from tkinter import *
from filemonitor import Monitor
from threading import Thread
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
    def __init__(self, q, i):
        Thread.__init__(self)
        self.i = i
        self.q = q

    def addText(self, t):
        T = Text(self.i.root, height=2, width=30)
        T.pack()
        T.insert(END, "Got: {}".format(t))

    def run(self):
        while True:
            obj = self.q.get()
            # TODO: Handle different actions here
            self.addText(obj.src_path)

class Interface(object):
    def Treemap(self):
        pass

    def Scatter(self):
        pass

    def HDG(self):
        pass

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
        self.visualizationmenu.add_command(label="Treemap", command=self.Treemap)
        self.visualizationmenu.add_command(label="Scatterplot", command=self.Scatter)
        self.visualizationmenu.add_command(label="Hierarchical Dependecy Graphy", command=self.HDG)

        # Helpmenu
        self.helpmenu = Menu(self.menu)
        self.helpmenu.add_command(label="About...", command=self.About)

        # Root
        self.menu.add_cascade(label="File", menu=self.filemenu)
        self.menu.add_cascade(label="View", menu=self.visualizationmenu)
        self.menu.add_cascade(label="Help", menu=self.helpmenu)

    def run(self):
        self.root.mainloop()

if __name__ == "__main__":
    try:
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

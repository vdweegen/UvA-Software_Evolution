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
    def __init__(self, q):
        Thread.__init__(self)
        self.q = q

    def run(self):
        while True:
            obj = self.q.get()
            print(obj)

class Interface(object):
    def NewFile(self):
        pass

    def OpenFile(self):
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
        self.filemenu = Menu(self.menu)
        self.menu.add_cascade(label="File", menu=self.filemenu)
        self.filemenu.add_command(label="New", command=self.NewFile)
        self.filemenu.add_command(label="Open...", command=self.OpenFile)
        self.filemenu.add_separator()
        self.filemenu.add_command(label="Exit", command=self.root.quit)

        self.helpmenu = Menu(self.menu)
        self.menu.add_cascade(label="Help", menu=self.helpmenu)
        self.helpmenu.add_command(label="About...", command=self.About)

    def run(self):
        self.root.mainloop()

if __name__ == "__main__":
    try:
        queue = multiprocessing.Queue()
        fm = Monitoring(queue)
        fm.start()

        h = Handler(queue)
        h.start()

        i = Interface()
        i.run()

        fm.join()
        h.join()
    except KeyboardInterrupt:
        fm.kill()
    finally:
        fm.join()
        h.join()

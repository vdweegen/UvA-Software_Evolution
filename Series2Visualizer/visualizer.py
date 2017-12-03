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

if __name__ == "__main__":
    try:
        queue = multiprocessing.Queue()
        fm = Monitoring(queue)
        fm.start()

        h = Handler(queue)
        h.start()

        fm.join()
        h.join()
    except KeyboardInterrupt:
        fm.kill()
    finally:
        fm.join()
        h.join()

# def NewFile():
#     print("New File!")
#
# def OpenFile():
#     name = filedialog()
#     print(name)
#
# def About():
#     print("This is a simple example of a menu")
#
# root = Tk()
# menu = Menu(root)
# root.minsize(width=700, height=700)
# root.maxsize(width=700, height=700)
# root.config(menu=menu)
# filemenu = Menu(menu)
# menu.add_cascade(label="File", menu=filemenu)
# filemenu.add_command(label="New", command=NewFile)
# filemenu.add_command(label="Open...", command=OpenFile)
# filemenu.add_separator()
# filemenu.add_command(label="Exit", command=root.quit)
#
# helpmenu = Menu(menu)
# menu.add_cascade(label="Help", menu=helpmenu)
# helpmenu.add_command(label="About...", command=About)
#
# mainloop()

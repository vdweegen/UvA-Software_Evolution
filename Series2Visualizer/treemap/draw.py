from tkinter import *
from random import randint
import squarify


#TODO: Build map between the clones and the rectables
#   1. Since the dicts are sorted we can use the index to
#   create a mapping based on the indexes.
#   2. Create a custom Canvas object for the squares with
#   an overloaded mouseover to open a window with the clone/class
#   information
class TreeMap:
    def vals(self, project):
        self.values = [project.get_sloc()]

        # Classes with clones
        for cls in project.CLASSES:
            for cos in cls:
                self.values.append(cos.get_sloc())

        self.x = 0
        self.y = 0
        self.width = 700
        self.height = 700

        self.values.sort(reverse=False)

        self.values_normalized = squarify.normalize_sizes(
            self.values,
            self.width,
            self.height
        )
        # self.rects = squarify.squarify(
        #     self.values,
        #     self.x,
        #     self.y,
        #     self.width,
        #     self.height
        # )

        # padded rectangles will probably visualize better for certain cases
        self.padded_rects = squarify.padded_squarify(
            self.values_normalized,
            self.x,
            self.y,
            self.width,
            self.height
        )

    def randomcolor(self):
        r = lambda: randint(0,255)
        return '#%02X%02X%02X' % (r(), r(), r())

    def draw(self, canv):
        c = Canvas(canv, width=self.width, height=self.height)
        c.pack()
        for i in self.padded_rects:
            c.create_rectangle(
                i["x"],
                i["y"],
                i["x"]+i["dx"],
                i["y"]+i["dy"],
                fill=self.randomcolor())
        canv.update()
from tkinter import *
from random import randint
import squarify

# these values define the coordinate system for the returned rectangles
# the values will range from x to x + width and y to y + height
class TreeMap:
    def vals(self, values):
        # TODO: values -> vals
        self.vals = []
        # Currently draws random pycharts
        self.x = 0
        self.y = 0
        self.width = 700
        self.height = 433

        # self.vals = [500, 433, 78, 25, 25, 7]
        for i in range(0,50):
            self.vals.append(randint(100,500))
        self.vals = squarify.normalize_sizes(
            self.vals,
            self.width,
            self.height
        )
        # self.rects = squarify.squarify(
        #     self.vals,
        #     self.x,
        #     self.y,
        #     self.width,
        #     self.height
        # )

        # padded rectangles will probably visualize better for certain cases
        self.padded_rects = squarify.padded_squarify(
            self.vals,
            self.x,
            self.y,
            self.width,
            self.height
        )

    def randomcolor(self):
        r = lambda: randint(0,255)
        return ('#%02X%02X%02X' % (r(),r(),r()))

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

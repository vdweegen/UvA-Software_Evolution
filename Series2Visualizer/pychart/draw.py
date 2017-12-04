from tkinter import *
from random import randint

# these values define the coordinate system for the returned rectangles
# the values will range from x to x + width and y to y + height
class PyChart:
    def prop(self, n):
        return 360.0 * n / 1000

    def vals(self, values):
        # TODO: values -> vals
        self.vals = {}
        # Currently draws random pycharts
        self.vals['q1'] = randint(200,250) # Type 1 Clones
        self.vals['q2'] = randint(200,400) # Type 2 Clones
        self.vals['q3'] = randint(200,350) # Type 3 Clones
        self.vals['q4'] = 1000 - (self.vals['q1'] + self.vals['q2'] + self.vals['q3']) # Total No of Lines

    def draw(self, canv):
        c = Canvas(canv, width=154, height=154)
        c.pack()
        c.create_arc((2,2,152,152), fill="#FAF402", outline="#FAF402", start=self.prop(0), extent = self.prop(self.vals['q1']))
        c.create_arc((2,2,152,152), fill="#00AC36", outline="#00AC36", start=self.prop(self.vals['q1']), extent = self.prop(self.vals['q2']))
        c.create_arc((2,2,152,152), fill="#7A0871", outline="#7A0871", start=self.prop(self.vals['q1']+self.vals['q2']), extent = self.prop(self.vals['q3']))
        c.create_arc((2,2,152,152), fill="#E00022", outline="#E00022", start=self.prop(self.vals['q1']+self.vals['q2']+self.vals['q3']), extent = self.prop(self.vals['q4']))
        canv.update()

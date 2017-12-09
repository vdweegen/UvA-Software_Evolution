from tkinter import *
from random import randint


# these values define the coordinate system for the returned rectangles
# the values will range from x to x + width and y to y + height
class PyChart:
    width = 500
    height = 500
    project_sloc = 0

    def prop(self, n):
        return 360.0 * n / self.project_sloc

    def vals(self, project):
        self.project_sloc = project.get_sloc()

        self.vals = {'q1': 0, 'q2': 0, 'q3': 0, 'q4': 0}

        # Classes with clones
        for cls in project.CLASSES:
            for cos in cls:
                if cos.get_type() == 1:  # Type 1 Clones
                    self.vals['q1'] += cos.get_sloc()
                if cos.get_type() == 2:  # Type 2 Clones
                    self.vals['q2'] += cos.get_sloc()
                if cos.get_type() == 3:  # Type 3 Clones
                    self.vals['q3'] += cos.get_sloc()

        self.vals['q4'] = self.project_sloc - (self.vals['q1'] + self.vals['q2'] + self.vals['q3'])  # Total No of Lines

    def draw(self, canv):
        c = Canvas(canv, width=self.width, height=self.height)
        c.pack()
        c.create_arc((2, 2, self.width, self.height), fill="#FAF402", outline="#FAF402",
                     start=self.prop(0),
                     extent=self.prop(self.vals['q1']))
        c.create_arc((2, 2, self.width, self.height), fill="#00AC36", outline="#00AC36",
                     start=self.prop(self.vals['q1']),
                     extent=self.prop(self.vals['q2']))
        c.create_arc((2, 2, self.width, self.height), fill="#7A0871", outline="#7A0871",
                     start=self.prop(self.vals['q1'] + self.vals['q2']),
                     extent=self.prop(self.vals['q3']))
        c.create_arc((2, 2, self.width, self.height), fill="#E00022", outline="#E00022",
                     start=self.prop(self.vals['q1'] + self.vals['q2'] + self.vals['q3']),
                     extent=self.prop(self.vals['q4']))
        canv.update()

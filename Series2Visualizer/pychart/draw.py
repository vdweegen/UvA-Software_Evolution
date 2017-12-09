from tkinter import *


class PyChart:
    width = 500
    height = 500
    project_sloc = 0
    color_type_one = "blue"
    color_type_two = "yellow"
    color_type_three = "red"
    color_type_base = "green"

    def __init__(self):
        self.values = {'q1': 0, 'q2': 0, 'q3': 0, 'q4': 0}

    def prop(self, n):
        return 360.0 * n / self.project_sloc

    def vals(self, project):
        self.project_sloc = project.get_sloc()

        # Classes with clones
        for cls in project.CLASSES:
            for cos in cls:
                if cos.get_type() == 1:  # Type 1 Clones
                    self.values['q1'] += cos.get_sloc()
                if cos.get_type() == 2:  # Type 2 Clones
                    self.values['q2'] += cos.get_sloc()
                if cos.get_type() == 3:  # Type 3 Clones
                    self.values['q3'] += cos.get_sloc()

        self.values['q4'] = self.project_sloc - (self.values['q1'] + self.values['q2'] + self.values['q3'])  # Total No of Lines

    def draw(self, canv):
        l = Canvas(canv, width=190, height=self.height)
        l.pack(side=LEFT, anchor=NW)
        w = Label(l, text="% Clone Type #1", bg=self.color_type_one, fg="white")
        w.pack(fill=X)
        w = Label(l, text="% Clone Type #2", bg=self.color_type_two, fg="black")
        w.pack(fill=X)
        w = Label(l, text="% Clone Type #3", bg=self.color_type_three, fg="white")
        w.pack(fill=X)
        w = Label(l, text="% Project SLOC", bg=self.color_type_base, fg="white")
        w.pack(fill=X)

        c = Canvas(canv, width=self.width, height=self.height)
        c.pack(side=RIGHT)
        c.create_arc((2, 2, self.width, self.height), fill=self.color_type_one, outline="black",
                     start=self.prop(0),
                     extent=self.prop(self.values['q1']))
        c.create_arc((2, 2, self.width, self.height), fill=self.color_type_two, outline="black",
                     start=self.prop(self.values['q1']),
                     extent=self.prop(self.values['q2']))
        c.create_arc((2, 2, self.width, self.height), fill=self.color_type_three, outline="black",
                     start=self.prop(self.values['q1'] + self.values['q2']),
                     extent=self.prop(self.values['q3']))
        c.create_arc((2, 2, self.width, self.height), fill=self.color_type_base, outline="black",
                     start=self.prop(self.values['q1'] + self.values['q2'] + self.values['q3']),
                     extent=self.prop(self.values['q4']))
        canv.update()

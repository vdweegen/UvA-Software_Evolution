from tkinter import *


class PyChart:
    width = 500
    height = 500
    project_sloc = 0

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
        c = Canvas(canv, width=self.width, height=self.height)
        c.pack()
        c.create_arc((2, 2, self.width, self.height), fill="#FAF402", outline="#FAF402",
                     start=self.prop(0),
                     extent=self.prop(self.values['q1']))
        c.create_arc((2, 2, self.width, self.height), fill="#00AC36", outline="#00AC36",
                     start=self.prop(self.values['q1']),
                     extent=self.prop(self.values['q2']))
        c.create_arc((2, 2, self.width, self.height), fill="#7A0871", outline="#7A0871",
                     start=self.prop(self.values['q1'] + self.values['q2']),
                     extent=self.prop(self.values['q3']))
        c.create_arc((2, 2, self.width, self.height), fill="#E00022", outline="#E00022",
                     start=self.prop(self.values['q1'] + self.values['q2'] + self.values['q3']),
                     extent=self.prop(self.values['q4']))
        canv.update()

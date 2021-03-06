from tkinter import *
from random import randint
import squarify
import colorsys

class TreeMap:
    canv = None
    values = None
    valuedetails = None
    colors = None

    def __init__(self, skip_initial=False, color_per_clone=False):
        self.height = 700
        self.width = 700
        self.y = 0
        self.x = 0
        self.values = []
        if color_per_clone:
            self.types = []
        self.valuedetails = []
        self.__skip_initial = skip_initial
        self.__color_per_clone = color_per_clone

    def get_colors(self, N):
        HSV_tuples = [(x * 1.0 / N, 0.5, 0.5) for x in range(N)]
        hex_out = []
        for rgb in HSV_tuples:
            rgb = map(lambda x: int(x * 255), colorsys.hsv_to_rgb(*rgb))
            hex_out.append('#%02x%02x%02x' % tuple(rgb))
        return hex_out

    def get_type_color(self, t=0):
        if t == 1:
            return "blue"
        if t == 2:
            return "yellow"
        if t == 3:
            return "red"
        return "green"

    def vals(self, project):
        if not self.__skip_initial:
            self.values = [project.get_sloc()]
            self.valuedetails = [None]
            self.types = [None]

        # Classes with clones
        for cls in project.CLASSES:
            for cos in cls:
                __sloc = cos.get_sloc()
                self.values.append(__sloc)
                if self.__color_per_clone:
                    self.types.append(cos.get_type())
                if not self.__skip_initial:
                    self.values[0] -= __sloc
                self.valuedetails.append(cos)

        # self.values.sort(reverse=False)
        self.colors = self.get_colors(len(self.values))

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

    def onObjectClick(self, event):
        # print('Got object click', event.x, event.y)
        item = event.widget.find_closest(event.x, event.y)
        _index = int(event.widget.gettags(item)[0].split("-")[1])
        self.show_details(_index)

    CLONE_DETAILS = """Clone Details
    ID:            {}
    Clone Class:   {}
    Type:          {}
    Metadata
        Mass:      {}
        Lenght:    {}
        SLOC:      {}
    Location
        File:      {}
        Row:       {}
        Column:    {}
        Offset:    {}
        
    Fragment:
    
    {}
    """

    PROJECT_DETAILS = """
    Add some fancy project details here (since you clicks the percentage
    of non-duplicated code).
    """

    def format_long_fragment(self, fragment):
        return fragment[:200] + (fragment[200:] and '\n====== OUTPUT TRUNCATED ======')

    def show_details(self, index):
        toplevel = Toplevel()
        clone = self.valuedetails[index]
        if clone:
            __fragment = clone.CLONE["fragment"]
            text = self.CLONE_DETAILS.format(
                           clone.CLONE["id"],
                           clone.CLONE["clone_class"],
                           clone.CLONE["pairs"][0]["type"],
                           clone.CLONE["metadata"]["mass"],
                           clone.CLONE["metadata"]["length"],
                           clone.CLONE["metadata"]["sloc"],
                           clone.CLONE["location"]["file"],
                           clone.CLONE["location"]["row"],
                           clone.CLONE["location"]["column"],
                           clone.CLONE["location"]["offset"],
                           self.format_long_fragment(__fragment)
                       )
        else:
            text = self.PROJECT_DETAILS
        label1 = Label(toplevel,
                       text=text,
                       height=0,
                       width=0,
                       justify=LEFT
                       )
        label1.pack()

    def draw(self, canv):
        self.canv = canv
        c = Canvas(self.canv, width=self.width, height=self.height)
        # c.pack()
        for j in range(0, len(self.padded_rects)):
            i = self.padded_rects[j]
            c.create_rectangle(
                i["x"],
                i["y"],
                i["x"]+i["dx"],
                i["y"]+i["dy"],
                fill=self.colors[j] if not self.__color_per_clone else self.get_type_color(self.types[j]),
                tags="rectangle-{}".format(j))
            c.tag_bind('rectangle-{}'.format(j),
                       '<ButtonPress-1>',
                       self.onObjectClick)
        c.pack()
        # canv.update()
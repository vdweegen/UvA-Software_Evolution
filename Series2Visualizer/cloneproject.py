import json


class CloneProject(object):
    METADATA = None
    CLASSES = []

    def __init__(self, _project="", _location="", _time="", _sloc="", _loc=""):
        self.METADATA = {
            "project": _project,
            "location": _location,
            "time": _time,
            "sloc": _sloc,
            "loc": _loc
        }

    def get_loc(self):
        return self.METADATA["loc"]

    def get_sloc(self):
        return self.METADATA["sloc"]

    def add_class(self, _class):
        self.CLASSES.append(_class)

    def reload(self, metadata):
        self.METADATA = metadata

    def __repr__(self) -> str:
        return json.dumps(self.METADATA)


class CloneObject(object):
    CLONE = None

    def __init__(self, _id=0, _clone_class="", _type=0, _mass=0,
                 _length=0, _sloc=0, _file="", _row=0, _column=0, _offset=[]):
        self.CLONE = {
            "id": _id,
            "clone_class": _clone_class,
            "type": _type,
            "metadata": {
                "mass": _mass,
                "length": _length,
                "sloc": _sloc
            },
            "location": {
                "file": _file,
                "row": _row,
                "column": _column,
                "offset": _offset
            },
            "fragment": "if (isEmpty(var)) { System.out.println(\"hello world\");}"
        }

    def get_sloc(self):
        return self.CLONE["metadata"]["sloc"]

    def get_type(self):
        return self.CLONE["type"]

    def load(self, content):
        self.CLONE = content

    def __repr__(self) -> str:
        return json.dumps(self.CLONE)

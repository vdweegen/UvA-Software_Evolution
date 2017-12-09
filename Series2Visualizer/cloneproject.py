import json


class CloneProject(object):
    METADATA = None
    CLASSES = []

    def __init__(self, _project = "", _location = "", _time = "", _sloc = "", _loc = ""):
        self.METADATA = {
            "project": _project,
            "location": _location,
            "time": _time,
            "sloc": _sloc,
            "loc": _loc
        }

    def reload(self, metadata):
        self.METADATA = metadata

    def __repr__(self) -> str:
        return json.dumps(self.METADATA)


class CloneObject(object):
    CLONE = None

    def __init__(self, _id, _clone_class, _type, _mass,
                 _length, _sloc, _file, _row, _column, _offset):
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

    def __repr__(self) -> str:
        return json.dumps(self.CLONE)
import json
from threading import Thread
import random
from shutil import rmtree
import string
import time
import os


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


class TestRCF(Thread):
    DIR = "./watchdir"

    META_JSON = {
        "project": "sampleProject{}".format(time.time().hex()),
        "location": "c:/temp/cloneProject",
        "time": "{}".format(time.time()),
        "sloc": random.randint(24000, 30000),
        "loc": random.randint(30000, 40000)
    }

    def run(self):
        # os.chdir(self.DIR)
        rmtree(self.DIR, True)
        os.mkdir(self.DIR)
        time.sleep(5)

        f = open(self.DIR+"/METADATA.json", "w+")
        f.write(json.dumps(self.META_JSON))
        f.close()

        for i in range(0, 100):
            f = open(self.DIR+"/rcf{:04d}.json".format(i), "w+")
            cloneobj = []
            cloneclass_name = "".join(
                random.choice(string.ascii_letters) for x in range(random.randint(4, 8)))+".java"
            cloneclass_folder = "".join(
                random.choice(string.ascii_letters) for x in range(random.randint(3, 9)))
            for j in range(0, random.randint(1, 5)):
                _mass = random.randint(1, 6)
                _length = random.randint(21, 28)
                _sloc = random.randint(7, 20)
                cloneobj.append(
                    CloneObject(j,
                                cloneclass_name,
                                random.randint(1, 3),
                                _mass,
                                _length,
                                _sloc,
                                "{0}/{1}/{2}".format(
                                    self.META_JSON["location"],
                                    cloneclass_folder,
                                    cloneclass_name),
                                random.randint(0, _length),
                                random.randint(0, 20),
                                [random.randint(0, 50),
                                 random.randint(51, 100)]
                                ),
                )
            f.write(cloneobj.__str__())
            f.close()
            time.sleep(1)


if __name__ == "__main__":
    t = TestRCF()
    print(json.dumps(t.META_JSON))
    cloneobj = []
    cloneclass_name = "".join(random.choice(string.ascii_letters) for x in range(random.randint(4, 8)))+".java"
    cloneclass_folder = "".join(random.choice(string.ascii_letters) for x in range(random.randint(3, 9)))
    for j in range(0, random.randint(1, 5)):
        _mass = random.randint(1, 6)
        _length = random.randint(21, 28)
        _sloc = random.randint(7, 20)
        cloneobj.append(
            CloneObject(j,
                        cloneclass_name,
                        random.randint(1, 3),
                        _mass,
                        _length,
                        _sloc,
                        "{0}/{1}/{2}".format(
                            t.META_JSON["location"],
                            cloneclass_folder,
                            cloneclass_name),
                        random.randint(0, _length),
                        random.randint(0, 20),
                        [random.randint(0, 50),
                         random.randint(51, 100)]
                        ),
        )
    print(cloneobj)
import json
from threading import Thread
import random
from shutil import rmtree
import string
import time
import os
from cloneproject import CloneObject, CloneProject

class TestRCF(Thread):
    DIR = "./watchdir"

    def run(self):
        # os.chdir(self.DIR)
        rmtree(self.DIR, True)
        os.mkdir(self.DIR)
        time.sleep(10)
        f = open(self.DIR+"/METADATA.json", "w+")
        proj = CloneProject(
            "sampleProject{}".format(time.time().hex()),
            "c:/temp/cloneProject",
            "{}".format(time.time()),
            random.randint(2400, 3000),
            random.randint(3000, 4000)
        )
        f.write(proj.__str__())
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
                                    proj.METADATA["location"],
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
    proj = CloneProject(
            "sampleProject{}".format(time.time().hex()),
            "c:/temp/cloneProject",
            "{}".format(time.time()),
            random.randint(24000, 30000),
            random.randint(30000, 40000)
        )
    print(proj)
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
                            proj.METADATA["location"],
                            cloneclass_folder,
                            cloneclass_name),
                        random.randint(0, _length),
                        random.randint(0, 20),
                        [random.randint(0, 50),
                         random.randint(51, 100)]
                        ),
        )
    print(cloneobj)
from threading import Thread

from shutil import rmtree
import time
import os

class TestRCF(Thread):
    DIR = "./watchdir"

    def run(self):
        # os.chdir(self.DIR)
        rmtree(self.DIR, True)
        os.mkdir(self.DIR)
        time.sleep(5)

        for i in range(0, 100):
            f = open(self.DIR+"/rcf{}.txt".format(i), "w+")
            f.write("joehoe")
            f.close()
            time.sleep(1)
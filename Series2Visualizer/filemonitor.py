import sys
import time
import logging
from multiprocessing import Queue
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

class CloneDetectionEventHandler(FileSystemEventHandler):
    def __init__(self, q):
        super(FileSystemEventHandler, self).__init__()
        # print('Initializing')
        self.q = q
    # def on_modified(self, event):
    #     # print("modified")
    #     self.q.put("modified")
    def on_created(self, event):
        # print("created")
        self.q.put(event)
    def on_deleted(self, event):
        # print("deleted")
        self.q.put(event)

class Monitor:
    def __init__(self,q):
        logging.basicConfig(level=logging.INFO,
                            format='%(asctime)s - %(message)s',
                            datefmt='%Y-%m-%d %H:%M:%S')

        self.path = sys.argv[1] if len(sys.argv) > 1 else './watchdir'
        self.event_handler = CloneDetectionEventHandler(q)
        self.observer = Observer()
        self.observer.schedule(self.event_handler, self.path, recursive=True)

    def kill(self):
        self.observer.stop()
        self.observer.join()

    def watch(self):
        self.observer.start()
        try:
            while True:
                time.sleep(1)
        except KeyboardInterrupt:
            self.observer.stop()
        self.observer.join()

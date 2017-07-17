#!/usr/bin/env python
# -*- coding: utf-8 -*-

# https://docs.python.org/3/library/socketserver.html

import logging
import os
import socket
from socketserver import BaseRequestHandler, TCPServer, ThreadingMixIn
import subprocess
import threading
import urllib.parse as parse

BROWSER = "vivaldi-stable"
LOGFILE = "/home/niels/files/sharecare/threaded_server.log"

logger = logging.getLogger(__name__)
logger.setLevel(logging.DEBUG)

log_handler = logging.FileHandler(filename=LOGFILE, delay=True)
log_handler.setLevel(logging.DEBUG)
logger.addHandler(log_handler)

formatter = logging.Formatter("%(asctime)s - %(levelname)s - %(message)s")
log_handler.setFormatter(formatter)


def validate_url(url):
    o = parse.urlparse(url)
    if all(o[:2]):
        return True
    else:
        msg = f"Invalid url: \"{url}\""
        logger.error(msg)
        raise ValueError(msg)


def demobilize(url):
    o = parse.urlparse(url)
    if not o.netloc.startswith("m."):
        return url
    else:
        nnetloc = o.netloc.replace("m.", "www.")
        return parse.urlunsplit((o.scheme,
                                nnetloc,
                                o.path,
                                o.query,
                                o.fragment))
 

def x_running():
    PID = subprocess.run(["pgrep", "Xorg"], stdout=subprocess.PIPE).stdout
    if PID is not None:
        logger.info(f"Xorg: PID {PID.decode().strip()} -- X is running")
        return True
    else:
        logger.warning(f"X is not running")
        return False


class ThreadedTCPRequestHandler(BaseRequestHandler):

    def handle(self):
        self.data = self.request.recv(4096).strip()
        url = self.data.decode('utf-8')
        logger.info(f"Connection from {self.client_address[0]}:{self.client_address[1]}") 
        if self.data: 
            try:
                validate_url(url) 
                url = demobilize(url)
                if x_running():
                    subprocess.run([BROWSER, f"{url}"], stdout=subprocess.DEVNULL)
                    logger.info(f"Opened \"{url}\" in {BROWSER}")
                    self.request.sendall(bytes("ACK\n", "utf-8"))
                else:
                    self.request.sendall(bytes("NOX\n", "utf-8"))

            except ValueError:
                logger.error(f"invalid url: {self.data}")

class ThreadedTCPServer(ThreadingMixIn, TCPServer):
    pass   

if __name__ == "__main__":

    HOST, PORT = "192.168.1.2", 8001
    ThreadedTCPServer.allow_reuse_address = True
    with ThreadedTCPServer((HOST, PORT), ThreadedTCPRequestHandler) as server:

        # Start a thread with the server -- that thread will then start one
        # more thread for each request
        server_thread = threading.Thread(target=server.serve_forever)
        # Exit the server thread when the main thread terminates
        server_thread.daemon = True
        server_thread.start()
        server.serve_forever()

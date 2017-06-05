#!/usr/bin/env python
# -*- coding: utf-8 -*-

# https://docs.python.org/3/library/socketserver.html

import logging
import os
import socket
from socketserver import BaseRequestHandler, TCPServer, ThreadingMixIn
import subprocess
import threading
from urllib.parse import urlparse

BROWSER = "vivaldi-stable"
LOGFILE = "/home/niels/files/sharecare/threaded_server.log"
LINKSFILE = "/home/niels/shared_links"

logger = logging.getLogger(__name__)
logger.setLevel(logging.DEBUG)

log_handler = logging.FileHandler(filename=LOGFILE, delay=True)
log_handler.setLevel(logging.DEBUG)
logger.addHandler(log_handler)

formatter = logging.Formatter("%(asctime)s - %(name)s - %(levelname)s - %(message)s")
log_handler.setFormatter(formatter)


def validate_url(url):
    o = urlparse(url)
    if all(o[:2]):
        return True
    else:
        msg = f"Invalid url: \"{url}\""
        logger.error(msg)
        raise ValueError(msg)


def x_running():
    return True if 'DISPLAY' in os.environ else False


class ThreadedTCPRequestHandler(BaseRequestHandler):

    def handle(self):
        self.data = self.request.recv(4096).strip()
        url = self.data.decode('utf-8')
        logger.info(f"Connection from {self.client_address[0]}:{self.client_address[1]}") 
        if self.data: 
            try:
                validate_url(url) 
                if x_running():
                    subprocess.run([BROWSER, f"{url}"], stdout=subprocess.DEVNULL)
                    logger.info(f"Opened \"{url}\" in {BROWSER}")
                else:
                    with open(LINKSFILE, 'a') as lf:
                        lf.write(f"{url}\n")
                    logger.info(f"saved \"{url}\"")

                self.request.sendall(bytes(self.data.upper()))
            except ValueError:
                pass


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

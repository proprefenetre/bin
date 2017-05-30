#!/usr/bin/env python
# -*- coding: utf-8 -*-

# https://docs.python.org/3/library/socketserver.html

import logging
from urllib.parse import urlparse
from socketserver import BaseRequestHandler, TCPServer
import subprocess

BROWSER = "vivaldi-stable"
LOGFILE = "/home/niels/files/sharecare/server.log"
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
        msg = f"Invalid url: {url}"
        logger.error(msg)
        raise ValueError(msg)


class TCPHandler(BaseRequestHandler):
    """ request handler class"""

    def handle(self):
        self.data = self.request.recv(4096).strip()
        url = self.data.decode('utf-8')
        logger.info(f"Connection from {self.client_address[0]}:{self.client_address[1]}") 
        if self.data: 
            validate_url(url) 
            subprocess.run([BROWSER, f"{url}"], stdout=subprocess.DEVNULL)
            logger.info(f"Opened \"{url}\" in {BROWSER}")
            self.request.sendall(bytes(self.data.upper()))

if __name__ == "__main__":

    HOST, PORT = "192.168.1.2", 8001

    TCPServer.allow_reuse_address = True
    with TCPServer((HOST, PORT), TCPHandler) as server:
        server.serve_forever()



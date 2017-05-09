#!/usr/bin/env python
# -*- coding: utf-8 -*-

# https://docs.python.org/3/library/socketserver.html

from socketserver import BaseRequestHandler, TCPServer
import subprocess

BROWSER = "chromium"

class TCPHandler(BaseRequestHandler):
    """ request handler class"""

    def handle(self):
        self.data = self.request.recv(4096).strip()
        # print(f"connected from: {self.client_address}\ndata: {self.data}")
        subprocess.run([BROWSER, f"{self.data.decode('utf-8')}"],
                stdout=subprocess.DEVNULL)
        self.request.sendall(bytes(self.data.upper()))

if __name__ == "__main__":
    HOST, PORT = "192.168.1.2", 8001
    TCPServer.allow_reuse_address = True
    with TCPServer((HOST, PORT), TCPHandler) as server:
        server.serve_forever()

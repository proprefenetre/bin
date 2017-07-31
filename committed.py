#!/usr/bin/env python
# -*- coding: utf-8 -*-

import argparse
from datetime import datetime
from pathlib import Path
import shlex
import subprocess
import time


def tdelta(then):
    # return timedelta in seconds
    return (datetime.now() - datetime.fromtimestamp(then)).seconds


class Committed:
    #   {{{1 #
    def __init__(self, repo, interval=300):
        self.repo = repo
        self.interval = interval        # in seconds

    @property
    def repo(self):
        return self._repo

    @repo.setter
    def repo(self, value):
        if Path(value, ".git").exists():
            self._repo = Path(value)
        else:
            raise Exception(f"{value}: not a git repository")

    @repo.deleter
    def repo(self):
        del self._repo

    def git_cmd(self, args):
        cmd = shlex.split(f"git {args}")
        proc = subprocess.run(cmd,
                              stdout=subprocess.PIPE,
                              cwd=self.repo,
                              encoding="utf-8")
        return proc.stdout

    def notify(self, title, msg):
        cmd = shlex.split(f"notify-send -a {shlex.quote(title)} {shlex.quote(msg)}")
        proc = subprocess.run(cmd,
                              stdout=subprocess.PIPE,
                              encoding="utf-8")
        return proc.returncode

    def last_commit(self):
        ts, *t_since = self.git_cmd("--no-pager log --pretty=format:'%ct %ar' --max-count=1").split()
        return int(ts), ' '.join(t_since)

    def is_dirty(self):
        return self.git_cmd("status --porcelain")

    def check(self):
        title = "Commit your changes!"
        msg = f"{self.repo.name}: last commit was {self.last_commit()[-1]}!"
        if self.is_dirty():
            self.notify(title, msg)

    def watch(self):
        while True:
            if tdelta(self.last_commit()[0]) > (self.interval):
                self.check()
            time.sleep(self.interval)
    #  1}}} #


def run():
    parser = argparse.ArgumentParser(description="Remind you to commit changes to a repo")
    parser.add_argument("-r", "--repo", type=str, metavar="path/to/repo", default=Path.cwd())
    parser.add_argument("-i", "--interval", type=int, default=300, metavar='s', help="commit interval (seconds)")

    args = vars(parser.parse_args())

    if not args["repo"]:
        parser.print_help()
        return

    c = Committed(args["repo"], args["interval"])
    print(f"watching {c.repo} with {c.interval}s intervals")
    c.watch()


if __name__ == "__main__":

    run()

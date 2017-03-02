#!/usr/bin/env python
# -*- coding: utf-8 -*-

# cycle through windows. Adapted from https://faq.i3wm.org/question/1773/how-can-i-configure-i3wm-to-make-alttab-action-just-like-in-windows/%3C/p%3E.html

import argparse
import json
import subprocess
import sys


"""
Execute the given command and return the 
output as a list of lines
"""

def get_i3_tree():
    proc = subprocess.run(["i3-msg", "-t", "get_tree"], stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT, encoding='utf-8')
    return json.loads(proc.stdout)

# def command_output(cmd):
#     output = []
#     if (cmd):
#         p = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
#         for line in p.stdout.readlines():
#             output.append(line.rstrip())
#     return output
#
#
# def output_to_dict(output_list):
#     output_string = ""
#     for line in output_list:
#         output_string += line.decode('utf-8')
#     return json.loads(output_string)


def find_windows(tree_dict):
    windows = []
    if ("nodes" in tree_dict and len(tree_dict["nodes"]) > 0):
        for node in tree_dict["nodes"]:
            windows += find_windows(node)
    else:
        if (tree_dict["layout"] != "dockarea" and not tree_dict["name"].startswith("i3bar for output") and not tree_dict["window"] == None):
            windows.append(tree_dict)
    return windows


def change_i3_focus(w_id):
    subprocess.run(["i3-msg", f"[id=\"{w_id}\"]", "focus"],
            stdout=subprocess.DEVNULL)


def cycle(w_list, flag):
    for n, w in enumerate(w_list):
        if (w_list[n]["focused"] == True):
            try:
                idx = n+1 if flag == 'forward' else n-1
                change_i3_focus(w_list[idx]['window'])
            except IndexError:
                change_i3_focus(w_list[0]['window'])


def iface():
    parser = argparse.ArgumentParser(description='cycle through windows')
    parser.add_argument('-f', '--forward', action='store_true', help='cycle '
                        'forwards [ws1 = start, wsn = end]')
    parser.add_argument('-b', '--backward', action='store_true', help='cycle '
                        'backwards')

    args = vars(parser.parse_args())

    w_list = find_windows(get_i3_tree())

    if not any(args.values()):
        parser.print_help()
    else:
        for k, v in args.items():
            if v:
                cycle(w_list, k)
                
if __name__ == "__main__":
    iface()
    

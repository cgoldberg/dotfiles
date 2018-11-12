#!/usr/bin/env python3

import os
import sys

# recursively delete files under the current directory that are not images (recursive)
# restricted to run in a 'Google Photos' directory.


if __name__ == '__main__':

    delete_extensions = ('.json', '.js', '.jso', '.mov', '.avi')

    cur_dir = os.getcwd()
    if os.path.split(cur_dir)[-1] == 'Google Photos':
        dir = cur_dir
    else:
        print('error: current directory is not "Google Photos"')
        sys.exit(1)

    for root, _, files in os.walk(dir):
        for f in files:
            if f.lower().endswith(delete_extensions):
                path = os.path.join(root, f)
                print('removing: {}'.format(path))
                os.unlink(path)


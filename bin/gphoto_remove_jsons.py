#!/usr/bin/env python3
import os

if __name__ == '__main__':
    dir = os.getcwd()
    for root, dirs, file_names in os.walk(dir):
        for file_name in file_names:
            path = os.path.join(root, file_name)
            if file_name.lower().endswith('.json'):
                print('removing: {}'.format(path))
                os.unlink(path)

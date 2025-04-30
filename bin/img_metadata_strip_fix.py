#!/usr/bin/env python3
# Corey Goldberg, 2014-2025
#
# image metadata cleaner


"""Recursively scan a directory and clear metadata from image files.

* removes all metadata (Exif, IPTC, XMP, GPS Info, comment, thumbnail)
* works with .jpg and .png formats
* modifications are done in-place

requires:
  * gexiv2 (GObject-based wrapper for the Exiv2 library
      - Install on Ubuntu/Debian: $ sudo apt install gir1.2-gexiv2*
  * exiv2
      - Install on Ubuntu/Debian: $ sudo apt install exiv2
"""


import os
import subprocess
import sys
import time

try:
    from gi.repository import GExiv2
except ImportError:
    sys.exit("gexiv2 not installed")


def clear_all_metadata(img_path):
    metadata = GExiv2.Metadata(img_path)
    metadata.clear_comment()
    metadata.clear_exif()
    metadata.clear_iptc()
    metadata.clear_xmp()
    metadata.delete_gps_info()
    metadata.erase_exif_thumbnail()
    metadata.clear()
    metadata.save_file()


if __name__ == "__main__":
    dir = os.getcwd()
    for root, dirs, filenames in os.walk(dir):
        for filename in filenames:
            file_path = os.path.join(root, filename)
            if filename.lower().endswith(("jpg", "png")):
                # delete all metadata with exiv2
                subprocess.call(["exiv2", "-d", "a", "delete", file_path])
                # delete all metadata again with gexiv
                clear_all_metadata(file_path)
                print(file_path)

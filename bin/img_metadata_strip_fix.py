#!/usr/bin/env python3
#
# image metadata cleaner and timestamp fixer.
# Corey Goldberg, 2014
#


"""Recursively scan a directory tree for image files and cleanup metadata.

  * removes all metadata (Exif, IPTC, XMP, GPS Info, comment, thumbnail)
  * sets metadata and file timestamps to oldest datetime found
  * works with .jpg and .png formats
  * modifications are done in-place
  * requires gexiv2 (GObject-based wrapper for the Exiv2 library
    - Install gexiv2 on Ubuntu/Debian: $ sudo apt-get install gir1.2-gexiv2-X
"""


import subprocess
import os
import sys
import time

try:
    from gi.repository import GExiv2
except ImportError:
    sys.exit('gexiv2 not installed')


DATE_PATTERN = '%Y:%m:%d %H:%M:%S'


def fix_image_dates(img_path):
    ct = os.path.getctime(img_path)
    ctime = time.strftime(DATE_PATTERN, time.localtime(ct))
    mt = os.path.getmtime(img_path)
    mtime = time.strftime(DATE_PATTERN, time.localtime(mt))
    exif = GExiv2.Metadata(img_path)
    try:
        dtime_image = exif['Exif.Image.DateTime']
    except KeyError:
        dtime_image = None
    try:
        dtime_image_original = exif['Exif.Image.DateTimeOriginal']
    except KeyError:
        dtime_image_original = None
    try:
        dtime_image_preview = exif['Exif.Image.PreviewDateTime']
    except KeyError:
        dtime_image_preview = None
    try:
        dtime_digitized = exif['Exif.Photo.DateTimeDigitized']
    except KeyError:
        dtime_digitized = None
    try:
        dtime_original = exif['Exif.Photo.DateTimeOriginal']
    except KeyError:
        dtime_original = None
    oldest_time = sorted(
        [x for x in (ctime, mtime, dtime_image,
                     dtime_image_original, dtime_image_preview,
                     dtime_digitized, dtime_original)
            if x is not None]
        )[0]
    exif.clear_comment()
    exif.clear_exif()
    exif.clear_iptc()
    exif.clear_xmp()
    exif.delete_gps_info()
    exif.erase_exif_thumbnail()
    exif.clear()
    exif['Exif.Image.DateTime'] = oldest_time
    exif['Exif.Photo.DateTimeDigitized'] = oldest_time
    exif['Exif.Photo.DateTimeOriginal'] = oldest_time
    exif.save_file()
    epoch = int(time.mktime(time.strptime(oldest_time, DATE_PATTERN)))
    os.utime(img_path, (epoch, epoch))
    return oldest_time


if __name__ == '__main__':
    dir = os.getcwd()
    for root, dirs, filenames in os.walk(dir):
        for filename in filenames:
            file_path = os.path.join(root, filename)
            if filename.lower().endswith(('jpg', 'png')):
                # delete all metadata using exiv2
                subprocess.call(['exiv2', '-d', 'a', 'delete', file_path])
                # clear metadata fields with gexiv and set dates
                oldest_time = fix_image_dates(file_path)
                print('{} [{}]'.format(file_path, oldest_time))

from __future__ import division
import math
import os
import struct
import subprocess
import sys


def get_image_size(file_path):
    """
    Return (width, height) for a given img file content - no external
    dependencies except the os and struct modules from core
    """
    size = os.path.getsize(file_path)

    with open(file_path) as input:
        height = -1
        width = -1
        data = input.read(25)

        if ((size >= 24) and data.startswith('\211PNG\r\n\032\n')
              and (data[12:16] == 'IHDR')):
            # PNGs
            w, h = struct.unpack(">LL", data[16:24])
            width = int(w)
            height = int(h)
        elif (size >= 16) and data.startswith('\211PNG\r\n\032\n'):
            # older PNGs?
            w, h = struct.unpack(">LL", data[8:16])
            width = int(w)
            height = int(h)
    return width, height

def get_offsets(file_path, dimensions, tiles):
    width, height = dimensions
    cols, rows = tiles
    rem_x, rem_y = width % cols, height % rows

    print "Columns: {cols}\nRows: {rows}\nRemainder X: {rem_x}\nRemainder Y: {rem_y}".format(
        cols=cols, rows=rows, rem_x=rem_x, rem_y=rem_y)

    output = []
    for i in xrange(cols):
        col = []
        for j in xrange(rows):
            off_x = (i * math.floor(width / cols))
            if i >= cols - rem_x:
                off_x += 1
            off_y = (j * math.floor(height / rows))
            if j >= rows - rem_y:
                off_y += 1
            col.append((off_x, off_y))
        output.append(col)
    return output

def get_tile_dimensions(dimensions, offsets):
    output = []
    for i in xrange(len(offsets)):
        col = []
        cur_col = offsets[i]
        if i < len(offsets) - 1:
            next_col = offsets[i + 1]
        else:
            next_col = [(dimensions[0], y) for x, y in offsets[i]]
        for j in xrange(len(offsets[i])):
            cur_row = offsets[i][j]
            if j < len(offsets[i]) - 1:
                next_row = offsets[i][j + 1]
            else:
                next_row = offsets[i][j][0], dimensions[1]
            col.append((next_col[0][0] - cur_col[0][0], next_row[1] - cur_row[1]))
        output.append(col)
    return output

def generate_image(filename, dimensions, offset, outfile):
    command = "convert {filename} -crop {width}x{height}+{xoff}+{yoff} {outfile}"
    command = command.format(
        filename=filename,
        width=int(dimensions[0]),
        height=int(dimensions[1]),
        xoff=int(offset[0]),
        yoff=int(offset[1]),
        outfile=outfile
    )
    print command
    subprocess.check_call(command.split())

def prepare_image(filename):
    filename_base = filename.split('/')[-1].split('.')[0]
    tempname = "{}.mpc".format(filename_base)
    if not os.path.isfile(tempname):
        command = "convert -limit memory 8192 {} {}".format(filename, tempname)
        print command
        subprocess.check_call(command.split())
    return tempname

def delete_tempfile(tempname):
    temproot = tempname.split('.')[0]
    command = "rm -f {0}.mpc {0}.cache".format(temproot)
    print command
    subprocess.check_call(command.split())

def main():
    filename = os.path.expanduser(sys.argv[1])
    outprefix = os.path.expanduser(sys.argv[2])
    dim = get_image_size(filename)
    tile_counts = (int(sys.argv[3]), int(sys.argv[4]))
    offsets = get_offsets(filename, dim, tile_counts)
    tile_sizes = get_tile_dimensions(dim, offsets)

    tempname = prepare_image(filename)
    for colno, col in enumerate(zip(offsets, tile_sizes)):
        for rowno, row in enumerate(zip(col[0], col[1])):
            num = tile_counts[0] * (rowno % tile_counts[1]) + (colno % tile_counts[0])
            generate_image(tempname, row[1], row[0],
                           "{0}_{1:02d}.png".format(outprefix, num + 1))
    #delete_tempfile(tempname)


if __name__ == "__main__":
    main()

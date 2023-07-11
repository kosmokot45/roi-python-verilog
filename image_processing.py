"""
Image processing.

Usage:
  image_processing.py <command> <filename_i> <filename_o>
  image_processing.py <command> <filename_i> <filename_o> <w> <h>

Examples:
  image_processing.py .\image_processing.py prep PeriodicTable.png data_to_fpga.txt
  image_processing.py .\image_processing.py res data_from_fpga.txt res.png 101 101

Options:
  -h, --help

"""
from docopt import docopt
from PIL import Image
import numpy as np 

def prepareData(filename_i, filename_o):
    img = Image.open(filename_i).convert('L')
    img_arr = np.array(img)

    pixels = []
    for width in img_arr:
        for pixel in width:
            pixels.append(pixel)

    with open(filename_o, "w") as file:
        for i, pixel in enumerate(pixels):
            if i != len(pixels)-1:
                file.write(f"{pixel}\n")
            else:            
                file.write(f"{pixel}")

def createImage(filename_i, filename_o, w, h):
    with open(filename_i, "r") as file:
        lines = file.readlines()

    img_arr = np.array(lines)
    mat = np.reshape(img_arr,(h, w))

    img = Image.fromarray(np.uint8(mat) , 'L')

    img.show()
    img.save(filename_o)

def main():
    args = docopt(__doc__)

    command = args['<command>']
    filename_i = args['<filename_i>']
    filename_o = args['<filename_o>']
    
    if command == 'prep':
        prepareData(filename_i, filename_o)
    elif command == 'res':
        w = int(args['<w>'])
        h = int(args['<h>'])
        createImage(filename_i, filename_o, w, h)

if __name__ == '__main__':
    main()
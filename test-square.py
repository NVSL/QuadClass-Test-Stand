from solid import *
from solid.utils import *
from util import inch_to_mm
square_size = 5
board_width=12
board_height = 24
pattern_width=inch_to_mm(board_width) - 25
pattern_height=inch_to_mm(board_height) - 25
open("test-square.scad", "w").write(scad_render(
    left(pattern_width/2)(forward(pattern_height/2)(square(5,5)))
    +    left(-pattern_width/2)(forward(pattern_height/2)(square(5,5)))
    +    left(-pattern_width/2)(forward(-pattern_height/2)(square(5,5)))
    +    left(pattern_width/2)(forward(-pattern_height/2)(square(5,5)))
))


from solid import *
from solid.utils import *

def inch_to_mm(x):
    return x*25.4

#screw_hole_diameter=2.5;
screw_shaft_length=16;
bolt_diameter=5;
bolt_thickness=1.6;
mortice_hole_distance=10;
mortice_width=10;
shaft_diameter = inch_to_mm(1/16);

# plywood
material_thickness=3;#2.55; 
screw_hole_diameter = 2.5 - 0.3;
shaft_diameter = inch_to_mm(1/16)- 0.2;

# 3/16 plexi
#material_thickness=4.7;
#screw_hole_diameter = 2.5 - 0.15;
#shaft_diameter = inch_to_mm(1/6) - 0.05;

clip_outer_radius=10;
clip_inner_radius = inch_to_mm(1/16);

brace_length = 87;
brace_width = 80;

side_length = 130;
side_height=side_length/2*sqrt(3);

from new_stand import GripJoint

def test_brace(length=110, width=40):
    base =  down(width)(square((length,width)))
    for i, depth in enumerate(range(10, 30, 4)):
        base -= right(10 + i*10)(forward(40)(GripJoint(depth, squeeze=0.5)()))
    for i, depth in enumerate(range(10, 30, 4)):
        base -= right(10 + i*10 + 50)(forward(40)(GripJoint(depth, squeeze=0.25)()))
    return base


print(scad_render(test_brace()))


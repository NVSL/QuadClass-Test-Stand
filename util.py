from solid import *
from solid.utils import *

class StackUp(object):
    def __init__(self, spacing=1):
        self.spacing = 1
        self.layout = None
        self.cursor = 0
        
    def add(self, o):
        new = o()
        if not self.layout:
            self.layout = new
        else:
            self.layout += self.layout + (back(self.cursor + o.layout_height)(new))
        
        self.cursor += o.layout_height + self.spacing
        return self

def smooth_hole(diameter):
    return scale([0.1,0.1])(circle(d=diameter*10))


def inch_to_mm(x):
    return x*25.4

def zip_tie_holes(distance=5.6):
    zip_tie_width = 2.6; #inch_to_mm(0.09);
    zip_tie_thickness = 1.15; #inch_to_mm(0.04);

    return (translate([-distance/2,0])(square([zip_tie_thickness, zip_tie_width], center=True)) + 
            translate([distance/2,0])(square([zip_tie_thickness, zip_tie_width], center=True)))
    

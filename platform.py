from solid import *
from solid.utils import *
from new_stand import smooth_hole, StackUp
import math

class  motor_grip(object):
    def __init__(self,
                 mount_outer_diameter = 16,
		 mount_inner_diameter = 7.9, #8.5-0.6, // 0.6 is for 1/8" plywood
		 mount_cut_width = 4,
		 arm_length = 22, #//55/2 + 10,
		 arm_width = 10,
		 slot_width = 1,
		 slot_depth = 1):
        self.mount_outer_diameter = mount_outer_diameter 
	self.mount_inner_diameter = mount_inner_diameter 
	self.mount_cut_width =      mount_cut_width   
	self.arm_length =           arm_length        
	self.arm_width =            arm_width 
	self.slot_width =           slot_width
        self.slot_depth =           slot_depth

    def __call__(self):
        return (
	    translate([-self.arm_length/2, 0])(square([self.arm_length, self.arm_width], center=True) )
	    + translate([-(self.arm_length + self.mount_inner_diameter/2),0])(scale([1.2,1])(smooth_hole(diameter=self.mount_outer_diameter)))
	    - translate([-(self.arm_length + self.mount_inner_diameter/2),0])(
                smooth_hole(diameter=self.mount_inner_diameter))
	    - translate([-(self.arm_length + self.mount_inner_diameter/2 + 10),0])(
	        square([self.mount_outer_diameter, self.mount_cut_width], center=True))
        ) - translate([-(self.arm_length-self.slot_depth/2), 0])(square([self.slot_depth+0.1, self.slot_width], center=True))
    
    
class  platform_2(object):
    def __init__(self,
                 width=53,
                 height=53):
        self.width= width
        self.height = height
        self.layout_width = self.height
        self.layout_height = max(self.width, self.width)

        print self
        
    def __call__(self):
	x = 20;
	l= 35;
	w = 7;
        d = 47.5
        
        outline = (square([self.width, self.height], center=True)
	           + translate([7.5,0])(square([5,65],center=True))
	           + translate([-7.5,0])(square([5,65],center=True))
                   
	           + translate([-x, 0] )(translate([w/2-7,0])(square([w,102],center=True)))
	           + translate([+x, 0] )(translate([-w/2+7,0])(square([w,102],center=True)))
                   
	           + translate([-x,-d])(rotate(a=0)(motor_grip(slot_depth=2, arm_length=23, arm_width=7)()))
                   + translate([x, -d])(rotate(a=180)(motor_grip(slot_depth=2, arm_length=23, arm_width=7)()))
	           + translate([-x, d])(rotate(a=0)(motor_grip(slot_depth=2, arm_length=23, arm_width=7)()))
	           + translate([x,  d])(rotate(a=180)(motor_grip(slot_depth=2, arm_length=23, arm_width=7)())))

        w=16;

        cutout = (square([42, 39], center=True))
#		  + translate([0, height/2-3])(zip_tie_holes())
#		  + translate([0, -(height/2-3)])(zip_tie_holes()))
                #rotate(a=90)(adafruit_quarter_perm_proto())


        return outline -cutout

class FCB_mouting_holes(object):

    def __call__(self):
        dx = 26
        dy = 4
        return (translate([dx, dy])(smooth_hole(diameter=2.26)) +
                translate([-dx, dy])(smooth_hole(diameter=2.26)) +
                translate([-dx, -dy])(smooth_hole(diameter=2.26)) +
                translate([dx, -dy])(smooth_hole(diameter=2.26)))

class  platform_3(object):
    def __init__(self,
                 board_width=58,
                 board_height=61):
        self.edge_width = 10
        self.board_width = board_width
        self.board_height = board_height
        self.width= board_width
        self.height = board_height
        self.edge_lip = 6
        self.layout_width = self.height
        self.layout_height = max(self.width, self.width)
        self.full_width= 100
        self.full_height = 100
        
    def __call__(self):
	x = 20
	l= 35
	w = 7
        d = 0
        arm_length = math.sqrt((self.full_width/2)**2 + (self.full_height/2)**2)
        
        outline = (square([self.width, self.height], center=True)

                   + translate([-x, 0])(translate([w/2-7,0])(square([w,102],center=True)))
	           + translate([+x, 0])(translate([-w/2+7,0])(square([w,102],center=True)))
                   
	           + rotate(a=45)(motor_grip(slot_depth=2, arm_length=arm_length, arm_width=7)())
                   + rotate(a=135)(motor_grip(slot_depth=2, arm_length=arm_length, arm_width=7)())
	           + rotate(a=225)(motor_grip(slot_depth=2, arm_length=arm_length, arm_width=7)())
	           + rotate(a=315)(motor_grip(slot_depth=2, arm_length=arm_length, arm_width=7)()))

        cutout = (square([self.width-self.edge_lip*2, self.height-self.edge_lip*2], center=True))# +
                  #                  FCB_mouting_holes()())
                  #		  + translate([0, height/2-3])(zip_tie_holes())
                  #		  + translate([0, -(height/2-3)])(zip_tie_holes()))
                  #rotate(a=90)(adafruit_quarter_perm_proto())
                  
                  
        return outline -cutout - FCB_mouting_holes()()
                  
open("platform.scad", "w").write(scad_render(StackUp().
                                                  add(platform_3()).
                                                  layout))

from solid import *
from solid.utils import *
import math
from util import smooth_hole, StackUp, inch_to_mm, zip_tie_holes

class  motor_grip(object):
    def __init__(self,
                 mount_outer_diameter = 16,
		 mount_inner_diameter = 7.9, #8.5-0.6, // 0.6 is for 1/8" plywood
		 mount_cut_width = 4,
		 arm_length = 22, #//55/2 + 10,
		 arm_width = 10,
		 slot_width = 1,
		 slot_depth = 1,
                 grommets=False,
                 grommet_diameter=0):

        self.mount_outer_diameter = mount_outer_diameter 
	self.mount_inner_diameter = mount_inner_diameter 
	self.mount_cut_width =      mount_cut_width   
	self.arm_length =           arm_length        
	self.arm_width =            arm_width 
	self.slot_width =           slot_width
        self.slot_depth =           slot_depth
        self.grommet_inner_diameter = grommet_diameter
        self.grommets = grommets
        self.grommet_outer_diameter = max(inch_to_mm(13.0/16), self.grommet_inner_diameter + 8)
        
    def __call__(self):

        if not self.grommets:
            return (
	        translate([-self.arm_length/2, 0])(square([self.arm_length, self.arm_width], center=True) )
	        + translate([-(self.arm_length + self.mount_inner_diameter/2),0])(scale([1.2,1])(smooth_hole(diameter=self.mount_outer_diameter)))
	        - translate([-(self.arm_length + self.mount_inner_diameter/2),0])(
                    smooth_hole(diameter=self.mount_inner_diameter))
	        - translate([-(self.arm_length + self.mount_inner_diameter/2 + 10),0])(
	            square([self.mount_outer_diameter, self.mount_cut_width], center=True))
            ) - translate([-(self.arm_length-self.slot_depth/2), 0])(square([self.slot_depth+0.1, self.slot_width], center=True))
        else:
            return (
	        translate([-self.arm_length/2, 0])(square([self.arm_length, self.arm_width], center=True) )
	        + translate([-(self.arm_length + self.grommet_inner_diameter/2),0])(smooth_hole(diameter=self.grommet_outer_diameter))
	        - translate([-(self.arm_length + self.grommet_inner_diameter/2),0])(
                    smooth_hole(diameter=self.grommet_inner_diameter))
            )
            
            

class  platform_2(object):
    def __init__(self,
                 width=53,
                 height=53,
                 grommets=False,
                 grommet_diameter=0):
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
                   
	           + translate([-x,-d])(rotate(a=0)(motor_grip(slot_depth=2, arm_length=23, arm_width=7, grommet_diameter=grommet_diameter, grommets=grommets)()))
                   + translate([x, -d])(rotate(a=180)(motor_grip(slot_depth=2, arm_length=23, arm_width=7, grommet_diameter=grommet_diameter, grommets=grommets)()))
	           + translate([-x, d])(rotate(a=0)(motor_grip(slot_depth=2, arm_length=23, arm_width=7, grommet_diameter=grommet_diameter, grommets=grommets)()))
	           + translate([x,  d])(rotate(a=180)(motor_grip(slot_depth=2, arm_length=23, arm_width=7, grommet_diameter=grommet_diameter, grommets=grommets)()))
                   + zip_tie_holes()
                   )

        w=16;

        cutout = (square([42, 39], center=True))
#		  + translate([0, height/2-3])(zip_tie_holes())
#		  + translate([0, -(height/2-3)])(zip_tie_holes()))
                #rotate(a=90)(adafruit_quarter_perm_proto())


        return outline -cutout

class FCB_mouting_holes(object):

    def __call__(self):
        dx = 11.5 #24
        dy = 20 #24
        return (translate([dx, dy])(smooth_hole(diameter=2.26)) +
                translate([-dx, dy])(smooth_hole(diameter=2.26)) +
                translate([-dx, -dy])(smooth_hole(diameter=2.26)) +
                translate([dx, -dy])(smooth_hole(diameter=2.26)))

class  platform_3(object):
    def __init__(self,
                 board_width=45, #54
                 board_height=45,
                 arms=True):
        self.board_width = board_width
        self.board_height = board_height
        self.width= board_width
        self.height = board_height
        self.edge_lip = 7.5
        self.layout_width = self.height
        self.layout_height = max(self.width, self.width)
        self.full_width= 80
        self.full_height = 80
        self.arms = arms
        self.grommets = True
        self.grommet_diameter = inch_to_mm(9.0/16)
        
    def __call__(self):
	x = 20
	l= 35
	w = 20
        d = 0
        arm_length = math.sqrt((self.full_width/2)**2 + (self.full_height/2)**2)
        
        outline = (square([self.width, self.height], center=True)

	           + (square([w,80],center=True) - square([w-10,80],center=True))
	           + (square([80,w],center=True) - square([80, w-10],center=True))
                   + translate([0, 0])(smooth_hole(diameter=2))
                   )
                   
        if self.arms:
            outline += (rotate(a=45)(motor_grip(slot_depth=2, arm_length=arm_length, arm_width=10, grommet_diameter=self.grommet_diameter, grommets=self.grommets)())
                        + rotate(a=135)(motor_grip(slot_depth=2, arm_length=arm_length, arm_width=10, grommet_diameter=self.grommet_diameter, grommets=self.grommets)())
                        + rotate(a=225)(motor_grip(slot_depth=2, arm_length=arm_length, arm_width=10, grommet_diameter=self.grommet_diameter, grommets=self.grommets)())
                        + rotate(a=315)(motor_grip(slot_depth=2, arm_length=arm_length, arm_width=10, grommet_diameter=self.grommet_diameter, grommets=self.grommets)()))

        cutout = (square([self.width-self.edge_lip*2, self.height-self.edge_lip*2], center=True) + 
                  translate([0, (self.board_height/2 - self.edge_lip/3)])(zip_tie_holes())
                  + translate([0, -(self.board_height/2 - self.edge_lip/3)])(zip_tie_holes())
                  + translate([(self.board_height/2 - self.edge_lip/3),0] )(rotate(90)(zip_tie_holes()))
                  + translate([-(self.board_height/2 - self.edge_lip/3),0])(rotate(90)(zip_tie_holes()))
                  )

                  
                  
        return outline - cutout - FCB_mouting_holes()() - translate([9, 15])(square([12,4], center=True)) - translate([-9, -15])(square([12,4], center=True))

                  
open("platform.scad", "w").write(scad_render(StackUp().
                                             add(platform_3()).
                                             layout))
open("board_mount.scad", "w").write(scad_render(StackUp().
                                             add(platform_3(arms=False)).
                                             layout))

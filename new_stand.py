from solid import *
from solid.utils import *
from util import smooth_hole, StackUp, inch_to_mm, zip_tie_holes


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

def mortice_hole_distance(brace_width, mortice_width):
    return (brace_width-mortice_width)/2-1.5*bolt_diameter


from platform import zip_tie_holes


class Side(object):
    def __init__(self,
                 width,
                 extension,
                 extension_height,
                 platform_thickness,
                 bearing_mount=False,
                 docking_slots=True,
                 servo_mounts=True):

        self.width = width
        self.extension = extension
        self.extension_height = extension_height
        self.pivot_diameter = inch_to_mm(1/8.0)            if bearing_mount else inch_to_mm(1/8.0)
        self.pivot_hole_diameter = inch_to_mm(1/4.0) - 0.1 if bearing_mount else inch_to_mm(1/8.0)
        self.platform_thickness = platform_thickness

        self.height = self.width/2*sqrt(3)


        self.column_width = 25
        self.pedestal_height = 25
        self.squeeze = 0.25

        self.big_brace_joint = GripJoint(depth=20, nominal_thickness=material_thickness, squeeze=0.5)
        self.big_brace_width = self.big_brace_joint.depth * 2

        #self.end_brace_joint = GripJoint(depth=self.pedestal_height/2, nominal_thickness=material_thickness, squeeze=0.5)
        #self.end_brace_width = self.pedestal_height

        self.layout_height = self.height
        self.layout_width = self.width

    def __call__(self):

        remote_recess = 76
        
        return (
            polygon([[-self.width/2,0],[self.width/2,0],[0,self.height]])
            + translate([0, self.extension_height/2])(square(size=[self.width+2*self.extension, self.extension_height], center=True)  )
            - forward(self.height-17)(
                forward(10+3*self.platform_thickness)(square([20,20], center=True))
                +smooth_hole(self.pivot_hole_diameter)#circle(self.pivot_hole_diameter, center=True)
                +forward(30/2)(square([self.pivot_hole_diameter, 30], center=True))
                -translate([ self.pivot_hole_diameter*7/8, self.pivot_hole_diameter/1.8])(smooth_hole(self.pivot_hole_diameter))
                -translate([-self.pivot_hole_diameter*7/8, self.pivot_hole_diameter/1.8])(smooth_hole(self.pivot_hole_diameter))
                +forward(0.5 * self.platform_thickness + self.pivot_diameter/2)(square([30, self.platform_thickness], center=True)-
                                                                                square([10, self.platform_thickness], center=True))
                +forward((0.5-2) * self.platform_thickness + self.pivot_diameter/2)(square([30, self.platform_thickness], center=True)-
                                                                                square([10, self.platform_thickness], center=True))
                #+circle(d=self.pivot_hole_diameter)#circle(self.pivot_hole_diameter, center=True)
            )

            # cut off the shoulders
            -translate([  200/2 + self.column_width/2 , 200/2 + self.pedestal_height])(square([200,200],  center=True))
            -translate([-(200/2 + self.column_width/2), 200/2 + self.pedestal_height])(square([200,200],  center=True))

            -translate([-(remote_recess/2 + self.column_width/2), remote_recess/2 + self.pedestal_height - 3 ])(square([remote_recess,remote_recess],  center=True))

            
            #right(self.width/2-20)(back(0.6)(rotate(180)(self.end_brace_joint())))
            #-left(self.width/2-20)(back(0.6)(rotate(180)(self.end_brace_joint())))
            
            -(left(40)(forward(self.pedestal_height/2)(rotate(90)(brace_slot(self.big_brace_width, self.big_brace_joint)))))
            -(forward(self.height/2)(brace_slot(self.big_brace_width, self.big_brace_joint)))
        )


def brace_slot(width, joint):
    return (square((material_thickness+joint.squeeze, width + 2), center=True) +
                  back((width+2)/2)(joint()))


def test_brace(length=120, width=40):
    base =  down(width)(square((length,width)))
    for i, depth in enumerate(range(10, 30, 2)):
        base -= right(10 + i*10)(forward(40)(GripJoint(depth=depth, squeeze=0.25)()))

    return base

class GripJoint(object):
    def __init__(self, depth=10, nominal_thickness=3, squeeze=0.15):
        self.depth = depth
        self.nominal_thickness = nominal_thickness
        self.squeeze = squeeze
        self.thin = self.nominal_thickness-self.squeeze
        self.thick = self.nominal_thickness+self.squeeze

    def __call__(self, sided=False):
        if sided:
            brace = polygon(points=[(-self.nominal_thickness/2,0), (-self.nominal_thickness/2 + self.thick,0),
                                    (-self.nominal_thickness/2 + self.thin, -self.depth), (-self.nominal_thickness/2, -self.depth)]) 
        else:
            brace = polygon(points=[(-self.thick/2,0), (self.thick/2,0), (self.thin/2,-self.depth), (-self.thin/2,-self.depth)]) 
        return brace

class Brace(object):
    def __init__(self, length, width, joint):
        self.joint = joint
        self.width = width
        self.length = length
        self.full_length = length + 30
        self.joint_width = self.joint.depth*2

        self.layout_height = max(self.width, self.joint_width)
        self.layout_width = self.full_length
        
    def __call__(self):
        return (left(self.length/2)(square((self.length, self.width)))
                + forward(self.width/2 - self.joint.depth)(
                    (left(self.full_length/2)(
                        square((self.full_length, self.joint_width)))

                - left(self.length/2 + self.joint.thick/2)(
                    forward(self.joint_width)(
                        scale((-1,1))(
                            self.joint(sided=True))))
                - right(self.length/2 + self.joint.thick/2)(
                    forward(self.joint_width)(
                        scale(( 1,1))(
                            self.joint(sided=True))))))
                - forward(self.width/2)(zip_tie_holes(18))  #18 is the width of an FTDI header + a little bit
        )

#print(scad_render(test_brace()))

side = Side(200, 0,0, bearing_mount=False, platform_thickness=material_thickness)
big_brace = Brace(150, 60, side.big_brace_joint)
#small_brace = Brace(230, 0, side.end_brace_joint)

if True:
    open("new_side.scad", "w").write(scad_render(StackUp().
                  add(side).
                  #add(side).
                  #add(big_brace).
                  #add(big_brace).
                  #add(small_brace).
                  #add(small_brace).
                  layout))
if False:
    open("new_small_brace.scad", "w").write(scad_render(StackUp().
                  #add(side).
                  #add(side).
                  #add(big_brace).
                  #add(big_brace).
                  #add(small_brace).
                  #add(small_brace).
                  layout))
if True:
    open("new_big_brace.scad", "w").write(scad_render(StackUp().
                  #add(side).
                  #add(side).
                  add(big_brace).
                  #add(big_brace).
                  #add(small_brace).
                  #add(small_brace).
                  layout))

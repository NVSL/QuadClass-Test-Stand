screw_hole_diameter=2.5;
screw_shaft_length=16;
bolt_diameter=5;
bolt_thickness=1.6;
mortice_hole_distance=10;
mortice_width=10;
material_thickness=2.55; // plywood
// plexiglass material_thickness=4.1;


include <test_stand_conf.scad>

$fa=10;

function inch_to_mm(x) = x*25.4;

module smooth_hole(diameter) {
    scale([0.1,0.1]) circle(d=diameter*10);
}
module screw_hole () {
    smooth_hole(screw_hole_diameter);
}

module mortice() {
    square([mortice_width, material_thickness], center=true);
}

module secured_mortice(x, y, rotation) {
    translate([x,y]) rotate(a=rotation) {
        mortice();
        translate([-(mortice_width/2+mortice_hole_distance),0]) screw_hole();
        translate([(mortice_width/2+mortice_hole_distance),0]) screw_hole();
    }
}

module side(width, height, extension, extension_height) {
    pivot_diameter=inch_to_mm(1/16);

    difference() {
        union() {
            polygon([[-width/2,0],[width/2,0],[0,height]]);
            translate([0,extension_height/2]) square(size=[width+2*extension, extension_height], center=true);  
        }  
        //secured_mortice(0,10, 0);
        secured_mortice(-20,35, 60);
        secured_mortice(20,35, -60);
        //secured_mortice(0,50, 90);
        
        translate([0, 80]) {
            union() {
                smooth_hole(pivot_diameter);
                translate([-10, pivot_diameter/2+material_thickness/2]) translate([-mortice_width/2,0]) mortice();
                translate([10, pivot_diameter/2+material_thickness/2]) translate([mortice_width/2,0]) mortice();
            }   
        }
        
    } 
}

module tenon() {
    translate([0,material_thickness/2]) square([mortice_width, material_thickness], center=true);
}

module tenon_attach() {
    
    union() {
        translate([0,-(screw_shaft_length-material_thickness)/2]) square([screw_hole_diameter, screw_shaft_length-material_thickness], center=true);
        translate([0,-(screw_shaft_length-material_thickness)/2]) square([bolt_diameter, bolt_thickness], center=true);
    }
    
}

module secured_tenon_n(x, y, rotation) {
    translate([x,y]) rotate(a=rotation) union() {
        translate([-(mortice_width/2+mortice_hole_distance),0]) tenon_attach();
        translate([(mortice_width/2+mortice_hole_distance),0]) tenon_attach();
    }
}
module secured_tenon_p(x, y, rotation) {
    translate([x,y]) rotate(a=rotation) union() {
        tenon();
    }
}

module brace(length, width) {
    difference() {
        union() {
            square([length, width], center=true);
            secured_tenon_p(-length/2,0,90);
            secured_tenon_p(length/2,0,-90);
        }
        secured_tenon_n(length/2,0,-90);
        secured_tenon_n(-length/2,0,90);
    }
}


module clip() {
    inner = clip_inner_radius;
    outer = clip_outer_radius;
    channel = 2*clip_inner_radius-0.45;
    difference() {
        circle(r=outer);
        union() {
                translate([outer/2,0]) square([outer,channel],center=true);
                scale([inner, inner]) scale([.1,.1]) circle(r=10);
        }
    }
}

include<MotorDriver-rev1.scad>

module header_slot(positions) {
square([inch_to_mm((positions+.5)*.1),inch_to_mm((1+.5)*.1)], center=true);
}

module Adafruit_LSM9DS1() {
    translate([-33.02/2, -20.32/2])  {
        translate([inch_to_mm(.1), inch_to_mm(.7)]) smooth_hole(diameter=2.5);
        translate([inch_to_mm(1.2), inch_to_mm(.7)]) smooth_hole(diameter=2.5);
        translate([inch_to_mm(1.2), inch_to_mm(.1)]) smooth_hole(diameter=2.5);
        translate([inch_to_mm(.1), inch_to_mm(.1)]) smooth_hole(diameter=2.5);
        translate([inch_to_mm(.65), inch_to_mm(.7)]) header_slot(5);    
        translate([inch_to_mm(.65), inch_to_mm(.1)]) header_slot(9);        
    }

}

module platform() {
    difference() {
        union() {
            square([80,24],center=true);
            translate([15,0]) square([10,46],center=true);
            translate([-15,0]) square([10,46],center=true);
            translate([0,0]) square([40,35],center=true);
        }
        translate([21,-6]) MotorDriver_rev1();
        translate([-21,6]) rotate(a=180) MotorDriver_rev1();
        rotate(a=90) Adafruit_LSM9DS1();
    }
}

module adafruit_quarter_perm_proto() {
    union() {
        //square([44,55], center=true);
        translate([-inch_to_mm(1.25/2),0]) smooth_hole(diameter=3.2);
        translate([inch_to_mm(1.25/2),0]) smooth_hole(diameter=3.2);
    }
    
    
}
module platform_2() {
    difference() {
        union() {
            //square([80,24],center=true);
            square([44,55], center=true);
            translate([15,0]) square([10,65],center=true);
            translate([-15,0]) square([10,65],center=true);
            translate([0,0]) square([80,10],center=true);
        }
        //translate([21,-6]) MotorDriver_rev1();
        //translate([-21,6]) rotate(a=180) MotorDriver_rev1();
        adafruit_quarter_perm_proto();
        translate([-35,0]) prop_mount_holes();
        translate([35,0]) prop_mount_holes();
    }
}

module prop_mount_holes() {
    mount_hole_diameter=2.1;
    gap=1.5;
    translate([mount_hole_diameter+gap,0]) smooth_hole(mount_hole_diameter);
    translate([-(mount_hole_diameter+gap),0]) smooth_hole(mount_hole_diameter);
    translate([-0,-0]) smooth_hole(mount_hole_diameter);
}


module prop_mount() {
    arm_length = 33;
    arm_width = 4;
    base_width = 5;
    base_length = 12;    
    
    mount_outer_diameter = 7;
    mount_inner_diameter = 4.18;
    mount_cut_width = 3;
    difference() {
        union() {

            translate([-arm_length/2, 0]) square([arm_length,arm_width], center=true);
            translate([-(arm_length+mount_inner_diameter/2),0]) difference() {
                smooth_hole(diameter=mount_outer_diameter);
                smooth_hole(diameter=mount_inner_diameter);
                translate([-mount_outer_diameter/2,0]) square([mount_outer_diameter,mount_cut_width], center=true);
            }
            translate([-base_length/2,0]) square([base_length,base_width], center=true);
        }
        translate([-base_length/2,0]) prop_mount_holes();
    }
}
//prop_mount();
//prop_mount_holes();
//adafruit_quarter_perm_proto();

//platform_2();
side(side_length, side_height, 40, 4);

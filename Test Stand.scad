screw_hole_diameter=2.5;
screw_shaft_length=16;
bolt_diameter=5;
bolt_thickness=1.6;
mortice_hole_distance=10;
mortice_width=10;
material_thickness=5;

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
        secured_mortice(0,10, 0);
        secured_mortice(-30,40, 60);
        secured_mortice(30,40, -60);
        
        translate([0, 80]) {
            union() {
                smooth_hole(pivot_diameter);
                translate([0, pivot_diameter+material_thickness/2+1]) mortice();
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


color("blue") side(130, 130/2*sqrt(3), 40, 4);
translate([0,-75]) brace(52,50);

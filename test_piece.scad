use<test_stand_parts.scad>

module half_brace(length, width) {
    difference() {
        union() {
            square([length, width], center=true);
            secured_tenon_p(length/2,0,-90);
        }
        secured_tenon_n(length/2,0,-90);
    }
}

/*difference() {
    half_brace(30,50);
    translate([-5,0]) rotate(a=90) secured_mortice(0,0);
    
    translate([0,25]) smooth_hole(diameter=3);
    
    for(i=[-.35:0.05:0]) {
        translate([0,60*i + 9]) smooth_hole(diameter=2.5+i);
        translate([5,60*i + 9]) smooth_hole(diameter=inch_to_mm(1/16)+i);
    }
}

translate([0,55]) difference() {
    half_brace(40,50);
    rotate(a=90) secured_mortice(0,0);
        translate([-11,14]) zip_tie_holes();
        translate([-11,-14]) zip_tie_holes();
}
*/
translate([-30,60]) {
    difference() {
        union() {
            translate([0,-60])square([10,170], center=true);
            for(j=[-12:1:-4]) {
                i = j*.05;
                translate([0,400*i+100]) motor_grip(mount_inner_diameter=8.5+i, arm_length=20, slot_depth=5);
            }
        }
        smooth_hole(diameter=2);
    }

}
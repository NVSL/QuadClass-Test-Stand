include<test_stand_parts.scad>


module big_kit() {
        length = 200;
        width = 230;
        translate([-20,-108]) side_pair(length, bearing_mount=true, servo_mounts=false, docking_slots=false);
        translate([-30,180]) rotate(a=0) configured_main_brace(width);
        translate([105,100]) rotate(a=90) configured_side_brace(width);
        translate([135,100]) rotate(a=90) configured_side_brace(width);
}

difference() {
    //square([inch_to_mm(12), inch_to_mm(12)], center=true);
    translate([0,-inch_to_mm(6)/2]) big_kit();
}

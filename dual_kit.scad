include<test_stand_parts.scad>

module one_kit(length, width) {
        translate([-8,-108]) side_pair(length);
        translate([-110,29]) rotate(a=90) configured_main_brace(width);
        translate([97, -9]) rotate(a=0) platform_2();
        translate([28,-1]) rotate(a=90) configured_side_brace(width);
        translate([-105.5,-33]) rotate(a=0) configured_side_brace(width);
}

module dual_kit() {
    translate([0,inch_to_mm(6)/2]) one_kit(side_length, brace_length);
    translate([0,-inch_to_mm(6)/2]) one_kit(side_length, brace_length);
}


difference() {
    square([inch_to_mm(12), inch_to_mm(12)], center=true);
    dual_kit();
}

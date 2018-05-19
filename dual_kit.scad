include<test_stand_parts.scad>

module configured_side() {
        side(side_length, 20, 4, horizontal_brace_width=brace_width, horizontal_mortice_width=20,     
        vertical_brace_width=28, vertical_mortice_width=5);
}

module configured_big_side() {
        side(200, 20, 4, horizontal_brace_width=brace_width, horizontal_mortice_width=20,     
        vertical_brace_width=28, vertical_mortice_width=5);
}


module configured_main_brace() {
   brace(brace_length,brace_width, mortice_width=20);
}

module configured_side_brace() {
    brace(brace_length,28, mortice_width=5);
}

module side_pair() {
    translate([-31,34]) configured_side();
    translate([3,4+side_height+1 + 64]) rotate(a=180) configured_side();
}
module side_big_pair() {
    translate([-31,34]) configured_big_side();
    translate([3,4+side_height+1 + 64]) rotate(a=180) configured_big_side();
}

module one_kit() {
        translate([-8,-108]) side_pair();
        translate([-110,29]) rotate(a=90) configured_main_brace();
        translate([97, -9]) rotate(a=0) platform_2();
        //translate([28,-1]) rotate(a=90) configured_side_brace();
        //translate([-105.5,-33]) rotate(a=0) configured_side_brace();
}
module one_big_kit() {
        translate([-8,-108]) side_big_pair();
        translate([-110,29]) rotate(a=90) configured_main_brace();
        translate([97, -9]) rotate(a=0) platform_2();
        //translate([28,-1]) rotate(a=90) configured_side_brace();
        //translate([-105.5,-33]) rotate(a=0) configured_side_brace();
}

difference() {
    square([inch_to_mm(12), inch_to_mm(12)], center=true);
    translate([0,-inch_to_mm(6)/2]) one_kit();
    //translate([0,inch_to_mm(6)/2]) one_kit();
}

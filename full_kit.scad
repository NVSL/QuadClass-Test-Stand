include<test_stand_parts.scad>

module configured_side() {
    side(side_length, side_height, 25, 4, horizontal_brace_width=brace_width+15, horizontal_mortice_width=20, vertical_brace_width=brace_width/2, vertical_mortice_width=5);
}

module configured_main_brace() {
            difference() {
                brace(brace_length,brace_width+15, mortice_width=20);
                translate([-52,-54]) atmega128rfa_breakout();
            }
}

module configured_side_brace() {
    brace(brace_length,brace_width/2, mortice_width=5);
}
module side_pair() {
    translate([-45, 34]) {   
        translate([24,0]) configured_side();
        translate([88,4+side_height+1]) rotate(a=180) configured_side();
    }
}

module partial_set() {
    translate([-45, 34]) {   
        translate([24,0]) side(side_length, side_height, 25, 4, horizontal_brace_width=brace_width+15, horizontal_mortice_width=20, vertical_brace_width=brace_width/2, vertical_mortice_width=5);
        //translate([65+90,4 + 8 + side_height]) rotate(a=180) side(side_length, side_height, 40, 4);

        translate([-52,61]) rotate(a=60) union() {
            difference() {
                brace(brace_length,brace_width+15, mortice_width=20);
                translate([-52,-54]) atmega128rfa_breakout();
            }
        }        
        //translate([-60,-17]) rotate(a=0) brace(brace_length,brace_width/2, mortice_width=5);
        //translate([40,-17]) rotate(a=0) brace(brace_length,brace_width/2, mortice_width=5);
            
        //translate([145, 42]) rotate(a=57) platform_2();

        //translate([130, 100]) clip();
        //translate([130, 20]) clip();
        translate([140,30]) platform_2();
    }
 
//translate([0,-50]) brace(brace_length,75);
}

module side_pair() {
        translate([24,0]) configured_side();
        translate([88,4+side_height+1]) rotate(a=180) configured_side();
}
module sides() {
    translate([-85, 34]) rotate(a=0) {   
        side_pair();
    }
    translate([150, 84])  rotate(a=90) scale([-1,1]){   
        side_pair();
    }
}

module two_kits() {
        translate([-46,34]) side_pair();
        translate([-35,-65]) side_pair();
        translate([-105,-2]) configured_main_brace();
        translate([-105, 116]) rotate(a=0) configured_main_brace();
        translate([-87, -92.5]) rotate(a=90) platform_2();
        translate([56, -92.5]) rotate(a=90) platform_2();
    
        translate([-16,-86]) rotate(a=90) configured_side_brace();
        translate([128,100]) rotate(a=90) configured_side_brace();
        translate([128,-2]) rotate(a=90) configured_side_brace();
        translate([128,-97]) rotate(a=90) configured_side_brace();
}
difference() {
    //square([inch_to_mm(12), inch_to_mm(12)], center=true);
    two_kits();
}

include<test_stand_parts.scad>


module full_set() {
    translate([-45, 34]) {   
        translate([24,0]) side(side_length, side_height, 25, 4, horizontal_brace_width=brace_width+15, horizontal_mortice_width=20, vertical_brace_width=brace_width/2, vertical_mortice_width=5);
        translate([88,4+side_height+1]) rotate(a=180) side(side_length, side_height, 25, 4, horizontal_brace_width=brace_width+15, horizontal_mortice_width=20, vertical_brace_width=brace_width/2, vertical_mortice_width=5);
        //translate([65+90,4 + 8 + side_height]) rotate(a=180) side(side_length, side_height, 40, 4);

        translate([-52,61]) rotate(a=60) union() {
            difference() {
                brace(brace_length,brace_width+15, mortice_width=20);
                rotate(a=90) translate([-40,-54])atmega128rfa_breakout();
            }
        }        
        translate([-60,-17]) rotate(a=0) brace(brace_length,brace_width/2, mortice_width=5);
        translate([40,-17]) rotate(a=0) brace(brace_length,brace_width/2, mortice_width=5);
            
        //translate([145, 42]) rotate(a=57) platform_2();

        //translate([130, 100]) clip();
        //translate([130, 20]) clip();
    }
 
//translate([0,-50]) brace(brace_length,75);
}
//difference() {
//    square([inch_to_mm(12), inch_to_mm(12)], center=true);
    full_set();
//    translate([0,-inch_to_mm(6)]) full_set();
//}

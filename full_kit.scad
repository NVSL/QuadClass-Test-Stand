include<test_stand_parts.scad>

module configured_side() {
    side(side_length, side_height, 25, 4, horizontal_brace_width=brace_width+15, horizontal_mortice_width=20, vertical_brace_width=28, vertical_mortice_width=5);
}

module configured_main_brace() {
            difference() {
                brace(brace_length,brace_width+15, mortice_width=20, hole=false);
                //translate([-52,-54]) atmega128rfa_breakout();
            }
}

module configured_side_brace() {
    brace(brace_length, 28, mortice_width=5, hole=true);
}
module side_pair() {
    translate([-45, 34]) {   
        translate([24,0]) configured_side();
        translate([88,4+side_height+1]) rotate(a=180) configured_side();
    }
}

module partial_set() {
    translate([-45, 34]) {   
        translate([24,0]) side(side_length, side_height, 25, 4, horizontal_brace_width=brace_width+15, horizontal_mortice_width=20, vertical_brace_width=28, vertical_mortice_width=5);
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
        translate([88,4+side_height+.2]) rotate(a=180) configured_side();
}
module sides() {
    translate([-85, 34]) rotate(a=0) {   
        side_pair();
    }
    translate([150, 84])  rotate(a=90) scale([-1,1]){   
        side_pair();
    }
}

module one_kit() {
        translate([-86,35]) side_pair();
        
  
           translate([-105.5,18]) rotate(a=0) configured_side_brace();
            translate([-15 ,12]) rotate(a=0) configured_side_brace();
    
            translate([85, 30]) rotate(a=90) platform_2();
        translate([-105,-60]) configured_main_brace();
      
}

module two_kits() {
        translate([-86,35]) side_pair();
        translate([149.5,90]) rotate(a=90) scale([-1,1])  side_pair();
        translate([26,-150]) rotate(a=0) scale([-1,1])  side_pair();
        
  
           translate([-105.5,18]) rotate(a=0) configured_side_brace();
            translate([-15 ,12]) rotate(a=0) configured_side_brace();
            translate([-105.5,-11]) rotate(a=0) configured_side_brace();
            translate([-15,-18]) rotate(a=0) configured_side_brace();
            translate([120,-80]) rotate(a=90) configured_side_brace();
            translate([85,-95]) rotate(a=90) configured_side_brace();
  
        translate([0, -10]) {
            translate([-95, -340]) rotate(a=90) platform_2();
            translate([-6, -377]) rotate(a=90) platform_2();
            translate([85, -340]) rotate(a=90) platform_2();
        translate([-105,-216]) configured_main_brace();
        translate([0, -216]) rotate(a=0) configured_main_brace();
        translate([105, -216]) rotate(a=0) configured_main_brace();
      
       }
}
difference() {
    //translate([0,-inch_to_mm(6),]) square([inch_to_mm(12), inch_to_mm(24)], center=true);
    //two_kits();
    translate([0,0]) square([inch_to_mm(12), inch_to_mm(12)], center=true);
    one_kit();
}

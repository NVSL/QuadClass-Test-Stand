include<test_stand_parts.scad>

side(side_length, side_height, 40, 4);
translate([65+90,4 + 8 + side_height]) rotate(a=180) side(side_length, side_height, 40, 4);

translate([-75,65]) rotate(a=60) brace(brace_length,brace_width);
translate([75,65]) rotate(a=-60) brace(brace_length,brace_width);
    
translate([220, 57]) rotate(a=60) platform_2();

translate([220, 100]) clip();
translate([130, 20]) clip();
    
//translate([0,-50]) brace(brace_length,75);

include<test_stand_parts.scad>

side(side_length, side_height, 40, 4);
translate([65+60,4 + 4 + side_height]) rotate(a=180) side(side_length, side_height, 40, 4);

    translate([-60,65]) rotate(a=60) brace(brace_length,brace_width);
    translate([65,65-8]) rotate(a=-60) brace(brace_length,brace_width);
    
    translate([197, 44]) platform_2();

translate([210, 100]) clip();
    translate([150, 20]) clip();
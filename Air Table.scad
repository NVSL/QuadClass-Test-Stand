use<test_stand_parts.scad>


air_hole_spacing = 10;
air_hole_diameter = 1;

perimeter_hole_diameter = 2.6;
perimeter_hole_fraction = 0.25;

width=6 * (air_hole_spacing/perimeter_hole_fraction) + air_hole_spacing;
height=6* (air_hole_spacing/perimeter_hole_fraction) + air_hole_spacing;

module perimeter_holes() {
    for(x = [-width/2:air_hole_spacing/perimeter_hole_fraction:width/2]) {
        translate([x + air_hole_spacing/2, height/2 - air_hole_spacing/2]) smooth_hole(diameter=perimeter_hole_diameter);
        translate([x + air_hole_spacing/2, -(height/2 - air_hole_spacing/2)]) smooth_hole(diameter=perimeter_hole_diameter);
    }    
    for(y = [-height/2:air_hole_spacing/perimeter_hole_fraction:height/2]) {
        translate([width/2 - air_hole_spacing/2, y + air_hole_spacing/2]) smooth_hole(diameter=perimeter_hole_diameter);
        translate([-(width/2 - air_hole_spacing/2), y + air_hole_spacing/2]) smooth_hole(diameter=perimeter_hole_diameter);
    }    
}

module top_plate() {
    difference() {
        square([width,height], center=true);
        for(x = [-width/2:air_hole_spacing:width/2]) {
            for(y = [-height/2:air_hole_spacing:height/2]) { 
                //translate([x,y]) smooth_hole(diameter=diameter);
                translate([x + air_hole_spacing/2,y + air_hole_spacing/2]) circle(d=air_hole_diameter);
            }
        }
        perimeter_holes();
    }
}

module bottom_plate() {
    difference() {
        square([width,height], center=true);
        perimeter_holes();
        smooth_hole(diameter=20);
    }
}

top_plate();
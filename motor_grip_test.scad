use<test_stand_parts.scad>

module motor_grip_test() {
    difference() {
        union() {
            translate([0,-60])square([10,130], center=true);
            for(j=[-6:1:0]) {
                i = j*.05;
                translate([0,400*i]) motor_grip(mount_inner_diameter=8.5+i, arm_length=20);
            }
        }
        smooth_hole(diameter=2);
    }


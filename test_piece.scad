use<test_stand_parts.scad>
difference() {
    brace(52,50);
    rotate(a=90) secured_mortice(0,0);
}

translate([0,55]) difference() {
    brace(52,50);
    rotate(a=90) secured_mortice(0,0);
}


module clip(outer, inner, channel) {
    difference() {
        circle(r=outer);
        union() {
                translate([outer/2,0]) square([outer,channel],center=true);
                scale([inner, inner]) scale([.1,.1]) circle(r=10);
        }
    }
}

function in_to_mm(x) = 25.4*x;
outer=19;
inner = 2.25;
clip(outer,inner,2*inner-0.45);

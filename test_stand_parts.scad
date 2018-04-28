function inch_to_mm(x) = x*25.4;

//screw_hole_diameter=2.5;
screw_shaft_length=16;
bolt_diameter=5;
bolt_thickness=1.6;
mortice_hole_distance=10;
mortice_width=10;
shaft_diameter = inch_to_mm(1/16);
// plywood
material_thickness=3;//2.55; 
screw_hole_diameter = 2.5 - 0.3;
shaft_diameter = inch_to_mm(1/16)- 0.2;

// 3/16 plexi
//material_thickness=4.7;
//screw_hole_diameter = 2.5 - 0.15;
//shaft_diameter = inch_to_mm(1/6) - 0.05;

clip_outer_radius=10;
clip_inner_radius = inch_to_mm(1/16);

brace_length = 87;
brace_width = 80;

side_length = 130;
side_height=side_length/2*sqrt(3);

$fa=10;


module smooth_hole(diameter) {
	scale([0.1,0.1]) circle(d=diameter*10);
}
module screw_hole () {
	smooth_hole(screw_hole_diameter);
}

module mortice(mortice_width=mortice_width) {
	square([mortice_width, material_thickness], center=true);
}

module secured_mortice(x, y, rotation, mortice_width=mortice_width, mortice_hole_distance=mortice_hole_distance) {
	translate([x,y]) rotate(a=rotation) {
		mortice(mortice_width=mortice_width);
		translate([-(mortice_width/2+mortice_hole_distance),0]) screw_hole();
		translate([(mortice_width/2+mortice_hole_distance),0]) screw_hole();
	}
}

function mortice_hole_distance(brace_width, mortice_width) = (brace_width-mortice_width)/2-1.5*bolt_diameter;

module servo(servo_width, servo_height)
{
			mount_diameter = inch_to_mm(0.08)/2; // /2 so we can screw into the wood.
			mount_offset = inch_to_mm((1.276/2-0.097));
			square([servo_width,servo_height], center=true);
			translate([mount_offset, 0]) smooth_hole(mount_diameter);
			translate([-(mount_offset), 0]) smooth_hole(mount_diameter);
}

module side(width, height, extension, extension_height, horizontal_brace_width=brace_width, horizontal_mortice_width=mortice_width, vertical_brace_width=brace_width, vertical_mortice_width=mortice_width) {
	pivot_diameter=inch_to_mm(1/16);

	difference() {
		union() {
			polygon([[-width/2,0],[width/2,0],[0,height]]);
			translate([0,extension_height/2]) square(size=[width+2*extension, extension_height], center=true);  
		}  
		h_hole_distance = mortice_hole_distance(horizontal_brace_width, horizontal_mortice_width);
		v_hole_distance = mortice_hole_distance(vertical_brace_width,vertical_mortice_width);
        
		//secured_mortice(0,10, 0);
		secured_mortice(53,14, -60, mortice_width=vertical_mortice_width, mortice_hole_distance=v_hole_distance);
		secured_mortice(-53,14, 60, mortice_width=vertical_mortice_width, mortice_hole_distance=v_hole_distance);
		secured_mortice(0,5, 0, mortice_width=horizontal_mortice_width, mortice_hole_distance=h_hole_distance);
		//secured   _mortice(0,50, 90);
        
		column_width = 20;
		pedestal_height = 25;
 
		translate([0, 95]) {
			union() {
				translate([0, 20]) square([20,20], center=true);
				translate([0, 20]) square([pivot_diameter, 40], center=true);
				smooth_hole(pivot_diameter);
				translate([-5, pivot_diameter/2+(material_thickness+0.5)/2]) translate([-(mortice_width+0.5)/2,0]) square([mortice_width+0.5, material_thickness+0.5], center=true);
				translate([ 5, pivot_diameter/2+(material_thickness+0.5)/2]) translate([ (mortice_width+0.5)/2,0]) square([mortice_width+0.5, material_thickness+0.5], center=true);
                
				notch_depth = 3;
				notch_width = 1.5;
				for(i=[-5:-5:-30]) {
					translate([column_width/2-notch_depth/2, i]) square([notch_depth, notch_width],center=true);
					translate([-(column_width/2-notch_depth/2), i]) square([notch_depth, notch_width],center=true);
				}                
			}   
		}
        
 
		translate([100/2+column_width/2,100/2+ pedestal_height]) square([100,100],  center=true);
		translate([-(100/2 + column_width/2),100/2 + pedestal_height]) square([100,100],  center=true);

		//https://cdn.solarbotics.com/products/schematics/25500-dim-imp.pdf
		servo_width = inch_to_mm(0.89);
		servo_height = inch_to_mm(0.472);
		translate([servo_width/2 + column_width/2 + 3, pedestal_height-servo_height/2 + 2]) servo(servo_width, servo_height);
		translate([-(servo_width/2 + column_width/2 + 3), pedestal_height-servo_height/2 + 2]) servo(servo_width, servo_height);
        
		translate([60,82]) rotate(a=180) atmega128rfa_breakout();
		translate([-60,82]) rotate(a=180) scale([-1,1]) atmega128rfa_breakout();
	} 

}

module tenon(mortice_width) {
	translate([0,material_thickness/2]) square([mortice_width, material_thickness], center=true);
}

module tenon_attach() {
    
	union() {
		translate([0,-(screw_shaft_length-material_thickness)/2]) square([screw_hole_diameter, screw_shaft_length-material_thickness + 1], center=true);
		translate([0,-(screw_shaft_length-material_thickness)*(7/8)]) square([bolt_diameter, bolt_thickness], center=true);
	}
    
}

module secured_tenon_n(x, y, rotation, hole_distance=mortice_hole_distance, mortice_width=mortice_width) {
	translate([x,y]) rotate(a=rotation) union() {
		translate([-(mortice_width/2+hole_distance),0]) tenon_attach();
		translate([(mortice_width/2+hole_distance),0]) tenon_attach();
	}
}
module secured_tenon_p(x, y, rotation, mortice_width) {
	translate([x,y]) rotate(a=rotation) union() {
		tenon(mortice_width=mortice_width);
	}
}

module atmega128rfa_breakout() {
	translate([0, 27.04]) union() {
		translate([15.24, 50.8]) smooth_hole(diameter=2.5);
		translate([66.04, 35.56]) smooth_hole(diameter=2.5);
		translate([66.04, 7.62]) smooth_hole(diameter=2.5);
		translate([13.97, 2.54]) smooth_hole(diameter=2.5);
	}
}

module brace(length, width, mortice_width=mortice_width) {
	difference() {
		union() {
			square([length, width], center=true);
			secured_tenon_p(-length/2,0,90, mortice_width=mortice_width);
			secured_tenon_p(length/2,0,-90, mortice_width=mortice_width);
		}
		hole_distance = mortice_hole_distance(width, mortice_width);
		secured_tenon_n(length/2,0,-90, hole_distance=hole_distance, mortice_width=mortice_width);
		secured_tenon_n(-length/2,0,90, hole_distance=hole_distance, mortice_width=mortice_width);
	}
}


module clip() {
	inner = clip_inner_radius;
	outer = clip_outer_radius;
	channel = 2*clip_inner_radius-0.45;
	difference() {
		circle(r=outer);
		union() {
			translate([outer/2,0]) square([outer,channel],center=true);
			scale([inner, inner]) scale([.1,.1]) circle(r=10);
		}
	}
}

include<MotorDriver-rev1.scad>

module header_slot(positions) {
	square([inch_to_mm((positions+.5)*.1),inch_to_mm((1+.5)*.1)], center=true);
}

module Adafruit_LSM9DS1() {
	translate([-33.02/2, -20.32/2])  {
		translate([inch_to_mm(.1), inch_to_mm(.7)]) smooth_hole(diameter=2.5);
		translate([inch_to_mm(1.2), inch_to_mm(.7)]) smooth_hole(diameter=2.5);
		translate([inch_to_mm(1.2), inch_to_mm(.1)]) smooth_hole(diameter=2.5);
		translate([inch_to_mm(.1), inch_to_mm(.1)]) smooth_hole(diameter=2.5);
		translate([inch_to_mm(.65), inch_to_mm(.7)]) header_slot(5);    
		translate([inch_to_mm(.65), inch_to_mm(.1)]) header_slot(9);        
	}

}

module platform() {
	difference() {
		union() {
			square([80,24],center=true);
			translate([15,0]) square([10,46],center=true);
			translate([-15,0]) square([10,46],center=true);
			translate([0,0]) square([40,35],center=true);
		}
		translate([21,-6]) MotorDriver_rev1();
		translate([-21,6]) rotate(a=180) MotorDriver_rev1();
		rotate(a=90) Adafruit_LSM9DS1();
	}
}

module adafruit_quarter_perm_proto(hole_diameter=3.2) {
	union() {
		//square([44,55], center=true);
		translate([-35.5/2,0]) smooth_hole(diameter=hole_diameter);
		translate([35.5/2,0]) smooth_hole(diameter=hole_diameter);
	}
    
    
}

module zip_tie_holes() {
	zip_tie_width = 2.6;//inch_to_mm(0.09);
	zip_tie_thickness = 1.15;//inch_to_mm(0.04);

	//zip_tie_thickness = inch_to_mm(0.04);
	distance = 5.6;
	translate([-distance/2,0]) square([zip_tie_thickness, zip_tie_width], center=true);
	translate([distance/2,0]) square([zip_tie_thickness, zip_tie_width], center=true);
}

module motor_grip(mount_outer_diameter = 16,
		  mount_inner_diameter = 7.9, //8.5-0.6, // 0.6 is for 1/8" plywood
		  mount_cut_width = 4,
		  arm_length = 22, //55/2 + 10,
		  arm_width = 10,
		  slot_width = 1,
		  slot_depth = 1) {

	difference() {
		union() {
			translate([-arm_length/2, 0]) square([arm_length,arm_width], center=true);
			translate([-(arm_length+mount_inner_diameter/2),0]) difference() {
				smooth_hole(diameter=mount_outer_diameter);
				smooth_hole(diameter=mount_inner_diameter);
				translate([-mount_outer_diameter/2,0]) square([mount_outer_diameter,mount_cut_width], center=true);
				//translate([-(slot_depth/2 + mount_inner_diameter/2), 0]) square([slot_depth, slot_width], center=true);
			}
		}
		translate([-(arm_length-slot_depth/2), 0]) square([slot_depth+0.1, slot_width], center=true);
	}
}

module platform_2() {
	width = 53;
	height = 55;
    
	difference() {
		union() {
			//square([80,24],center=true);
			square([width,height], center=true);
			translate([7.5,0]) square([5,65],center=true);
			translate([-7.5,0]) square([5,65],center=true);

			x = 20;
			l = 35;
			w = 7;
            
			translate([-x, 0] ) translate([w/2-7,0]) square([w,102],center=true);
			translate([+x, 0] ) translate([-w/2+7,0]) square([w,102],center=true);

  
			translate([-x,-47.5]) rotate(a=0)   motor_grip(slot_depth=2, arm_length=23, arm_width=7);//, arm_length=55/2+27);
			translate([x, -47.5]) rotate(a=180) motor_grip(slot_depth=2, arm_length=23, arm_width=7);//, arm_length=55/2+27);
			translate([-x, 47.5]) rotate(a=0)   motor_grip(slot_depth=2, arm_length=23, arm_width=7);//, arm_length=55/2+27);
			translate([x,  47.5]) rotate(a=180) motor_grip(slot_depth=2, arm_length=23, arm_width=7);//, arm_length=55/2+27);
		}
        
		rotate(a=90) adafruit_quarter_perm_proto();
		w=16;
		//translate([-(5+w/2), 0]) square([w,39], center=true);
		//translate([ (5+w/2), 0]) square([w,39], center=true);
		square([42, 39], center=true);
		translate([0, height/2-3]) zip_tie_holes();
		translate([0, -(height/2-3)]) zip_tie_holes();
        
	}
    
	/*translate([-45,0]) rotate(a=0) union() {
	  difference() {
	  square([10,height], center=true);
	  rotate(a=90) adafruit_quarter_perm_proto(hole_diameter=5.5);
	  translate([0, height/2-5]) zip_tie_holes();
	  translate([0, -(height/2-5)]) zip_tie_holes();
	  }   
	  }*/
}

module prop_mount_holes() {
	mount_hole_diameter=2.1;
	gap=1.5;
	translate([mount_hole_diameter+gap,0]) smooth_hole(mount_hole_diameter);
	translate([-(mount_hole_diameter+gap),0]) smooth_hole(mount_hole_diameter);
	translate([-0,-0]) smooth_hole(mount_hole_diameter);
}



module prop_mount() {
	base_width = 5;
	base_length = 12;    
    
	difference() {
		union() {
			motor_grip();
			translate([-base_length/2,0]) square([base_length,base_width], center=true);
		}
		translate([-base_length/2,0]) prop_mount_holes();
	}
}
//prop_mount();
//prop_mount_holes();
//adafruit_quarter_perm_proto();

//platform_2();
//side(side_length, side_height, 25, 4, horizontal_brace_width=brace_width, horizontal_mortice_width=20, vertical_brace_width=28, vertical_mortice_width=5);

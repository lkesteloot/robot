// Holder of the AS5045 PCB. Units are mm.

include <config.scad>;

module pcb_plate() {
    module screw_hole(x, y) {
        translate ([x, y, -plate_thickness/2]) {
            cylinder(plate_thickness*2, hole_radius, hole_radius);
        }
    }
    
    module plate() {
        left_hole_x = pcb_plate_width - arm_radius - hole_short_distance;
        difference () {
            cube([pcb_plate_width, pcb_plate_height, plate_thickness]);
            screw_hole(pcb_plate_width - arm_radius, arm_radius);
            screw_hole(pcb_plate_width - arm_radius, pcb_plate_height - arm_radius);
            screw_hole(left_hole_x, arm_radius);
            screw_hole(left_hole_x, pcb_plate_height - arm_radius);
            translate ([left_hole_x - arm_radius - 1, 2*arm_radius, -plate_thickness/2]) {
                cube([pcb_plate_width, pcb_plate_height - 4*arm_radius, plate_thickness*2]);
            }
        }
    }
    
    module bracket() {
        difference () {
            cube([bracket_thickness, pcb_plate_height, bracket_height]);
            bracket_hole(arm_radius, arm_radius + support_radius + plate_thickness, bracket_hole_length);
            bracket_hole(pcb_plate_height - arm_radius, arm_radius + support_radius + plate_thickness, bracket_hole_length);
        }
    }
    
    module support() {
        difference() {
            cube([bracket_thickness + support_radius, pcb_plate_height, plate_thickness + support_radius]);
            translate ([bracket_thickness + support_radius, -1, plate_thickness + support_radius]) {
                rotate ([-90, 0, 0]) {
                    cylinder(pcb_plate_height + 2, support_radius, support_radius);
                }
            }
        }
    }

    translate ([-pcb_plate_width/2, -pcb_plate_height/2, 0]) {
        plate();
        bracket();
        support();
    }
}

pcb_plate();
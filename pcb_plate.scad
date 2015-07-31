// Holder of the AS5045 PCB. Units are mm.

include <config.scad>;

module screw_hole(x, y) {
    translate ([x, y, -plate_thickness/2]) {
        cylinder(plate_thickness*2, hole_radius, hole_radius);
    }
}

module plate() {
    left_hole_x = plate_width - arm_radius - hole_short_distance;
    difference () {
        cube([plate_width, plate_height, plate_thickness]);
        screw_hole(plate_width - arm_radius, arm_radius);
        screw_hole(plate_width - arm_radius, plate_height - arm_radius);
        screw_hole(left_hole_x, arm_radius);
        screw_hole(left_hole_x, plate_height - arm_radius);
        translate ([left_hole_x - arm_radius - 1, 2*arm_radius, -plate_thickness/2]) {
            cube([plate_width, plate_height - 4*arm_radius, plate_thickness*2]);
        }
    }
}

module bracket() {
    difference () {
        cube([bracket_thickness, plate_height, bracket_height]);
        bracket_hole(arm_radius, arm_radius + support_radius + plate_thickness, bracket_hole_length);
        bracket_hole(plate_height - arm_radius, arm_radius + support_radius + plate_thickness, bracket_hole_length);
    }
}

module support() {
    difference() {
        cube([bracket_thickness + support_radius, plate_height, plate_thickness + support_radius]);
        translate ([bracket_thickness + support_radius, -1, plate_thickness + support_radius]) {
            rotate ([-90, 0, 0]) {
                cylinder(plate_height + 2, support_radius, support_radius);
            }
        }
    }
}

translate ([-plate_width/2, -plate_height/2, 0]) {
    plate();
    bracket();
    support();
}
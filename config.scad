// Units are mm

$fn = 100;

// Measured on PCB:
hole_radius = 2.58/2;
hole_short_distance = 12.5;
hole_long_distance = 22.8;
hole_edge_clearance = 2.63; // Edge of hole to pins.

// Measured elsewhere (bracket, etc.):
center_from_left = 19.1;

// Made-up numbers:
pin_margin = 1;
plate_thickness = 2;
support_radius = 3;
bracket_height = 15;
bracket_hole_length = 3; // Between centers of holes.
bracket_thickness = plate_thickness;

// Computed:
hole_center_clearance = hole_edge_clearance + hole_radius;
arm_radius = hole_center_clearance - pin_margin;
center_from_right = arm_radius + hole_short_distance/2;
pcb_plate_width = center_from_right + center_from_left;
pcb_plate_height = hole_long_distance + arm_radius*2;

// This hole is along the X axis. Z is the bottom of the hole.
// It goes from X = 0 to X = +.
module bracket_hole(y, z, length) {
    translate ([-bracket_thickness/2, y, z]) {
        rotate ([0, 90, 0]) {
            cylinder(bracket_thickness*2, hole_radius, hole_radius);
        }
    }
    translate ([-bracket_thickness/2, y, z + length]) {
        rotate ([0, 90, 0]) {
            cylinder(bracket_thickness*2, hole_radius, hole_radius);
        }
    }
    translate ([-bracket_thickness/2, y - hole_radius, z]) {
        cube([bracket_thickness*2, hole_radius*2, length]);
    }
}


// Plate between the aluminum channel and the PCB plate. Units are mm.

include <config.scad>;
include <acrobotics.scad>;

_shaft_length = 38.1; // D-shaft sticking out + adapter + magnet, measured.
_as5045_spacing = 1;  // They ask for 1mm spacing.
_as5045_thickness = 6.2; // Thickness of board and chip, measured.
plate_length_margin = 5; // Extra just in case.
plate_length = acrobotics_channel_width + _shaft_length + _as5045_spacing + _as5045_thickness + plate_length_margin;

module plate() {
    plate_height = acrobotics_channel_width;
    bracket_hole_margin = 5;
    bracket_hole_long_length = 20;

    difference() {
        cube([plate_length, plate_height, plate_thickness]);
        translate([0, (plate_height - pcb_plate_height)/2, 0]) {
            rotate([0, -90, 0]) {
                bracket_hole(arm_radius, -plate_length + bracket_hole_margin, bracket_hole_long_length);
                bracket_hole(pcb_plate_height - arm_radius, -plate_length + bracket_hole_margin, bracket_hole_long_length);
            }
        }
        translate([acrobotics_first_hole, plate_height/2, -plate_thickness/2]) {
            // Rotate 90 degrees so it matches up with channel holes.
            rotate([0, 0, 90]) {
                acrobotics_holes(plate_thickness*2, true);
            }
        }
        
        // Removed unused areas.
        first_square_width = plate_length - acrobotics_channel_width - bracket_hole_long_length - bracket_hole_margin*2;
        translate([acrobotics_channel_width, arm_radius*2, -plate_thickness/2]) {
            cube([first_square_width, plate_height - arm_radius*4, plate_thickness*2]);
        }
        second_square_length = bracket_hole_long_length + 2*hole_radius;
        second_square_height = pcb_plate_height - 5*arm_radius;
        translate([acrobotics_channel_width + first_square_width + 4, (acrobotics_channel_width - second_square_height)/2, -plate_thickness/2]) {
            cube([second_square_length, second_square_height, plate_thickness*2]);
        }
     }
 }
 
 plate();
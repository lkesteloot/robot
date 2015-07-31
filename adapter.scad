// Adapter between the aluminum channel and the PCB plate. Units are mm.

include <config.scad>;
include <acrobotics.scad>;

adapter_height = acrobotics_channel_width;
shaft_length = 38.1; // D-shaft sticking out + adapter + magnet, measured.
as5045_spacing = 1;  // They ask for 1mm spacing.
as5045_thickness = 6.2; // Thickness of board and chip, measured.
adapter_length = acrobotics_channel_width + shaft_length + as5045_spacing + as5045_thickness;
echo(adapter_length);
bracket_hole_margin = 5;
bracket_hole_long_length = 10;

difference() {
    cube([adapter_length, adapter_height, plate_thickness]);
    translate([0, (adapter_height - plate_height)/2, 0]) {
        rotate([0, -90, 0]) {
            bracket_hole(arm_radius, -adapter_length + bracket_hole_margin, bracket_hole_long_length);
            bracket_hole(plate_height - arm_radius, -adapter_length + bracket_hole_margin, bracket_hole_long_length);
        }
    }
    translate([acrobotics_first_hole, adapter_height/2, -plate_thickness/2]) {
        acrobotics_holes(plate_thickness*2, true);
    }
    translate([acrobotics_channel_width, arm_radius*2, -plate_thickness/2]) {
        cube([adapter_length - acrobotics_channel_width - bracket_hole_long_length - bracket_hole_margin*2, adapter_height - arm_radius*4, plate_thickness*2]);
    }
 }
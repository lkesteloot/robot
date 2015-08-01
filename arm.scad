// Entire arm.

include <config.scad>;
include <acrobotics.scad>;
include <plate.scad>;
include <pcb_plate.scad>;
include <magnet_adapter.scad>;

translate([acrobotics_channel_width, acrobotics_channel_width, 0]) {
    rotate([0, -90, 90]) {
        color("LightGray") {
            acrobotics_channel(3);
        }
    }
}

translate([0, acrobotics_channel_width + plate_thickness, acrobotics_channel_width]) {
    rotate([90, 0, 0]) {
        color("green") {
            plate();
        }
    }
}

translate([plate_length - plate_length_margin, acrobotics_channel_width - pcb_plate_width/2, acrobotics_first_hole + acrobotics_channel_width]) {
    rotate([90, 0, -90]) {
        color("green") {
            pcb_plate();
        }
    }
}

translate([acrobotics_channel_width + _shaft_length - adapter_height, acrobotics_channel_width/2, acrobotics_first_hole + acrobotics_channel_width]) {
    rotate([0, 90, 0]) {
        color("green") {
            magnet_adapter();
        }
    }
}
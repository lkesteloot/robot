include <config.scad>;

inch_to_mm = 25.4;

acrobotics_channel_width = 1.50*inch_to_mm;
acrobotics_hole_spacing = 1.50/2*inch_to_mm;
acrobotics_first_hole = (0.22 + 1.061/2)*inch_to_mm;
acrobotics_thickness = 0.09*inch_to_mm;

// Makes a pattern of Acrobotics holes, facing toward +Z and
// aligned so that a channel would go down the X axis.
// The large hole is at the origin. Specify the height of the holes.
// The patterns share some holes. By default this module produces
// the shared holes on the left. Specify "right_end = true" to also
// make the shared holes on the right, for the right-most last set
// in a channel.
//
// See diagrams here:
//     https://www.servocity.com/html/3_00__aluminum_channel__585442.html
module acrobotics_holes(height, right_end) {
    // These numbers are all in inches, from the Acrobotics website.
    large_radius_in = 0.25;
    medium_radius_in = 0.08;
    small_radius_in = 0.07;
    large_hole_spacing_in = 1.50/2;
    large_diagonal_spacing_in = 1.50;
    small_diagonal_spacing_in = 0.77;
    large_orthogonal_spacing_in = large_diagonal_spacing_in/sqrt(2);
    
    // Convert to mm, add padding to holes.
    large_radius = large_radius_in*inch_to_mm + 0.1;
    medium_radius = medium_radius_in*inch_to_mm + 0.1;
    small_radius = small_radius_in*inch_to_mm + 0.2;
    large_hole_spacing = large_hole_spacing_in*inch_to_mm;
    small_diagonal_spacing = small_diagonal_spacing_in*inch_to_mm;
    large_orthogonal_spacing = large_orthogonal_spacing_in*inch_to_mm;

    module hole(x, y, r) {
        translate([x, y, 0]) {
            cylinder(height, r, r);
        }
    }
    
    module small_hole(x, y) {
        hole(x, y, small_radius);
    }

    module medium_hole(x, y) {
        hole(x, y, medium_radius);
    }

    module large_hole(x, y) {
        hole(x, y, large_radius);
    }

    // Large center hole.
    large_hole(0, 0);

    // Left-most two holes, very top and bottom.
    first_x = large_orthogonal_spacing/2;
    first_y = large_orthogonal_spacing/2;
    small_hole(-first_x, -first_y);
    small_hole(-first_x, first_y);
    
    // Next two holes to the right of that.
    second_x = 0.956/2*inch_to_mm;   
    second_y = 0.544/2*inch_to_mm;
    small_hole(-second_x, -second_y);
    small_hole(-second_x, second_y);
    
    // Single hole to the right of that.
    third_x = 1.50/4*inch_to_mm;
    medium_hole(-third_x, 0);
    
    // The next two are symmetric with the second pair.
    small_hole(-large_hole_spacing+second_x, -second_y);
    small_hole(-large_hole_spacing+second_x, second_y);
    
    // The next two holes to the right of that.
    fourth_x = 0.439/2*inch_to_mm;
    small_hole(-fourth_x, first_y);
    small_hole(-fourth_x, -first_y);
    
    // Holes directly above and below the large hole.
    fifth_y = small_diagonal_spacing/2;
    small_hole(0, fifth_y);
    small_hole(0, -fifth_y);
    
    if (right_end) {
        small_hole(first_x, -first_y);
        small_hole(first_x, first_y);
        small_hole(second_x, -second_y);
        small_hole(second_x, second_y);
        medium_hole(third_x, 0);
        small_hole(large_hole_spacing-second_x, -second_y);
        small_hole(large_hole_spacing-second_x, second_y);
        small_hole(fourth_x, first_y);
        small_hole(fourth_x, -first_y);
    }
}

// Goes toward the +x axis, with a corner at the origin and
// the rest in the positive Y and Z semispaces. The holes
// face up (Z).
module acrobotics_plate(count) {
    length = (count + 1)*acrobotics_channel_width/2;
    difference() {
        cube([length, acrobotics_channel_width, acrobotics_thickness]);
        for (i = [0 : count - 1]) {
            translate([acrobotics_first_hole + acrobotics_hole_spacing*i, acrobotics_channel_width/2, -acrobotics_thickness/2]) {
                acrobotics_holes(acrobotics_thickness*2, i == count - 1);
            }
        }
    }
}

// Goes toward the +x axis, with a corner at the origin and
// the rest in the positive Y and Z semispaces. The open part
// of the channel is at +Z.
module acrobotics_channel(count) {
    // Unused:
    /// corner_radius = 0.1*inch_to_mm;

    acrobotics_plate(count);
    translate([0, acrobotics_thickness, 0]) {
        rotate([90, 0, 0]) {
            acrobotics_plate(count);
        }
    }
    translate([0, acrobotics_channel_width, 0]) {
        rotate([90, 0, 0]) {
            acrobotics_plate(count);
        }
    }
}

acrobotics_plate(1);

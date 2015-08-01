// Units are mm.

$fn = 100;
real_shaft_radius = 6.39/2; // Measured shaft.
shaft_radius = real_shaft_radius + 0.2;  // Adjust for 3D printer.
d_diameter = 5.77; // Distance from D surface to other side of shaft.
real_d_radius = d_diameter - real_shaft_radius;
d_radius = real_d_radius + 0.1; // Adjust for 3D printer.
shaft_insert = 11;  // 5 for test
real_magnet_radius = 3;
magnet_radius = real_magnet_radius + 0.4; // Adjust for 3D printer.
magnet_height = 2.5;
wall_thickness = 1.2; // Multiple of 0.4, which is filament diameter.
adapter_radius = max(shaft_radius, magnet_radius) + wall_thickness;
adapter_height = 20; // At least shaft_insert + magnet_height. 10 for test.
foot_height = 2;
foot_radius = adapter_radius + 2;

// Make the shaft, vertically along Z axis, starting at Z = 0 and
// going for height.
module shaft(height) {
    difference() {
        cylinder(height, shaft_radius, shaft_radius);
        translate([d_radius, -shaft_radius*2, -1]) {
            cube([shaft_radius*4, shaft_radius*4, height + 2]);
        }
    }
}

// Make the magnet along Z axis, starting at Z = 0.
module magnet(extra_height) {
    cylinder(magnet_height + extra_height, magnet_radius, magnet_radius);
}

module big_x(height, height_below, height_above, skip_positive_x) {
    total_height = height + height_below + height_above;
    translate([0, 0, total_height/2 - height_below]) {
        translate([-adapter_radius, 0, 0]) {
            cube([adapter_radius*2, adapter_radius*0.6, total_height], center=true);
        }
        if (!skip_positive_x) {
            translate([adapter_radius, 0, 0]) {
                cube([adapter_radius*2, adapter_radius*0.6, total_height], center=true);
            }
        }
        cube([adapter_radius*0.6, adapter_radius*3, total_height], center=true);
    }
}

// Make the magnet adapter along Z axis, starting at Z = 0
// and with given height.
module magnet_adapter() {
    difference() {
        union() {
            cylinder(adapter_height, adapter_radius, adapter_radius);
            cylinder(foot_height, foot_radius, foot_radius);
        }
        translate([0, 0, -1]) {
            shaft(shaft_insert + 1);
            big_x(shaft_insert + 1, 1, 0, true);
        }
        translate([0, 0, adapter_height - magnet_height]) {
            magnet(1);
            big_x(magnet_height, 0, 1, false);
        }
    }
}

// magnet_adapter();

$fs = 0.1;
$fn = 100;

/* [General] */
render_part = "a"; // [w:Wheel, t:Tire, a:Wheel And Tire Joined]

// diameter of the whole wheel with tire
wheel_diameter = 50;
wheel_width = 8;

// just for general understanding and debugging of wheel/tire profiles in fast render view
debug_tire_profile = true;

// slice the whole wheel vertically
slice_wheel = false;

// 0 - wheel is not sliced, 50 - is sliced in the middle, 100 - the whole wheel is sliced out
// -1 - means that slice_wheel_mm is used
// percent calculated from the wheel diameter
slice_wheel_percent = 50;
// the same, but in mm
slice_wheel_mm = 0;

/* [Hub] */
hub_diameter = 8;

// -1 - the same as 0.75 of wheel width
hub_height_mm = -1;

hub_hole_diameter = 3;
hub_hole_flat_diameter = 2.5;
hub_hole_flat_angle = 0;

hub_hole_add_cap = true;
hub_hole_cap_position = "t"; // [t:Top, b:Bottom]
hub_hole_cap_hight = 1; 

// makes hole larger for this value (in mm)
hub_hole_extension = 0.17;

// 0 - hub is aligned to one side of the wheel, 50 - in the middle, 100 - to another side
// -1 - means that hub_align_mm is used
// position of the hub along the z axis in percent calculated from wheel width
hub_align_percent = 0; // [-1:1:100]

// the same, but in mm. Could be negative
hub_align_mm = 0;

/* [Spokes and Disc] */
spoke_count = 3;
spoke_width = 12;

// -1 - the same as wheel width / 3
spoke_height_mm = -1;

// 0 - spokes are aligned to one side of the wheel, 50 - in the middle, 100 - to another side
// -1 - means that spoke_align_mm is used
// percent calculated from wheel width
// will not match absolute value for hub if it has different height!
spoke_align_percent = 0; // [-1:1:100]

// the same, but in mm. Could be negative
spoke_align_mm = 0;

add_disc = false;

// -1 - the same as hub diameter
disc_inner_diameter_mm = -1;

// -1 - the same as rim diameter
disc_outer_diameter_mm = -1;

disc_thickness = 1;

// 0 - disk is aligned to one side of the wheel, 50 - in the middle, 100 - to another side
// -1 - means that disc_align_mm is used
// percent calculated from wheel width
disc_align_percent = 0; // [-1:1:100]

// the same, but in mm. Could be negative
disc_align_mm = 0;

/* [Rim] */
rim_internal_thicknes = 1;

// -1 - the same as spoke height * 2
rim_internal_height_mm = wheel_width * 0.8;

// 0 - rim is aligned to one side of the wheel, 50 - in the middle, 100 - to another side
// -1 - means that rim_align_mm is used
// percent calculated from wheel width
// will not match absolute value for spokes if they have different height!
rim_internal_align_percent = 0; // [-1:1:100]

// the same, but in mm. Could be negative
rim_internal_align_mm = 0;

rim_external_thicknes = 2;

// -1 - the same as wheel width
rim_external_height_mm = -1;

// 0 - rim is aligned to one side of the wheel, 50 - in the middle, 100 - to another side
// -1 - means that rim_align_mm is used
// percent calculated from wheel width
rim_external_align_percent = 0; // [-1:1:100]

// the same, but in mm. Could be negative
rim_external_align_mm = 0;

/* [Tire Slots] */
add_tire_slots = true;

// all next arrays should be size of tire_slots_count
tire_slots_count = 2;

tire_slots_depth = [1, 1];

tire_slots_width_external = [1.5, 1.5];

// angles of tire slot walls from bottom (by z axis) to top one
tire_slots_angles = [[0, 45], [45, 0]];

// 0 - tire slot is aligned to one side of the wheel, 50 - in the middle, 100 - to another side
// -1 - means that tire_slot_align_mm is used
// percent calculated from rim external width
// array, one value for each tire_slot
tire_slots_align_percent = [0, 100]; // [-1:1:100]

// the same, but in mm. Could be negative
tire_slots_align_mm = [0, 0];

/* [Tire] */
tire_thicknes = 3;

// tire inner diameter will be decreased by this amount of mm to titgh it on the wheel
tire_stretching_mm = 0.2;

// width of tire bevel along z axis.
// array of two elements: first is bottom bevel, second is top bevel along z axis
tire_bevel_width = [1, 1];

// angle of tire bevel. 0 - is no bevel
tire_bevel_angle = [45, 45];

/* [Protector] */
add_protector = true;

protector_loops = 3;

protector_loops_phase_percent = [0, 60, -1];

protector_loops_height = [-1, 4, -1];

protector_loops_align_percent = [0, 0, 0];

no_protector_width_between_loops = 0.5;

protector_elements_in_loop = [20, -1];

protector_depth = [.5, .8];

protector_tip_width_percent = [50, 70];

/* [Global] */
/*[Hidden]*/
// a small value to increment/decrement values when needed to improve fast render view
aBit = $preview ? 0.001 : 0; 

// ----- Calc additional values -----
hub_height = (hub_height_mm == -1) ? wheel_width * 0.75 : hub_height_mm;
spoke_height = (spoke_height_mm == -1) ? wheel_width / 3 : spoke_height_mm;
rim_internal_height = (rim_internal_height_mm == -1) ? spoke_height * 2 : rim_internal_height_mm;
rim_external_height = (rim_external_height_mm == -1) ? wheel_width : rim_external_height_mm;

hub_radius = hub_diameter / 2;
wheel_radius = wheel_diameter / 2;

spoke_length = wheel_radius - hub_radius - rim_internal_thicknes - rim_external_thicknes - tire_thicknes;

rim_internal_inner_radius = hub_radius + spoke_length;

rim_external_inner_radius = hub_radius + spoke_length + rim_internal_thicknes;
rim_external_radius = rim_external_inner_radius + rim_external_thicknes;

// full length of a spoke to be cut
spoke_inner_length_correction = hub_radius;
spoke_outer_length_correction = rim_internal_inner_radius;
spoke_full_length = spoke_length + spoke_inner_length_correction + spoke_outer_length_correction;

disc_inner_diameter = (disc_inner_diameter_mm == -1)
            ? hub_radius * 2
            : disc_inner_diameter_mm;

disc_outer_diameter = (disc_outer_diameter_mm == -1)
            ? rim_internal_inner_radius * 2
            : disc_outer_diameter_mm;

hub_align = (hub_align_percent < 0)
            ? hub_align_mm
            : (wheel_width - hub_height) * hub_align_percent / 100;

spoke_align = (spoke_align_percent < 0)
            ? spoke_align_mm
            : (wheel_width - spoke_height) * spoke_align_percent / 100;

disc_align = (disc_align_percent < 0)
            ? disc_align_mm
            : (wheel_width - disc_thickness) * disc_align_percent / 100;

rim_internal_align = (rim_internal_align_percent < 0)
            ? rim_internal_align_mm
            : (wheel_width - rim_internal_height) * rim_internal_align_percent / 100;

rim_external_align = (rim_external_align_percent < 0)
            ? rim_external_align_mm
            : (wheel_width - rim_external_height) * rim_external_align_percent / 100;

tire_stretching = render_part == "a" ? 0.1 : tire_stretching_mm;

slice_wheel_align = debug_tire_profile ?
            wheel_diameter / 2
            : (slice_wheel_percent < 0)
                ? slice_wheel_mm
                : wheel_diameter * (100 - slice_wheel_percent) / 100;

protector_default_height  = (wheel_width - no_protector_width_between_loops * (protector_loops -1)) / protector_loops + aBit;

rotate_angle = $preview && debug_tire_profile ? 180 : 360;

// circle calculations https://www.mathopenref.com/sagitta.html

module wheel_generator() {
    difference() {
        wheel();
        if ($preview && (slice_wheel || debug_tire_profile)) slice();
    }
}

module slice() {
    translate([0, -slice_wheel_align - aBit, 0])
        cube([wheel_diameter * 2, wheel_diameter, wheel_width * 2], center = true);
}

// ----- Wheel Modules -----
module wheel() {
    if (render_part == "w" || render_part == "a") {
        color("green") hub();
        spokes();
        if (add_disc) color("BurlyWood") disc();
        rim();
    }
    if (render_part == "t" || render_part == "a") {
        color("DarkGrey") tire();
    }
}

// ----- Protector Modules -----
module protector() {
    for (protector_loop = [0: protector_loops - 1]) {
        phase_percent = len(protector_loops_phase_percent) < protector_loop + 1
                            ? protector_loops_phase_percent[0]
                            : protector_loops_phase_percent[protector_loop];
        element_count = protector_elements_in_loop[protector_loop] < 0
                            || len(protector_elements_in_loop) < protector_loop + 1
                            ? protector_elements_in_loop[0]
                            : protector_elements_in_loop[protector_loop];
        depth = protector_depth[protector_loop] < 0
                            || len(protector_depth) < protector_loop + 1
                            ? protector_depth[0]
                            : protector_depth[protector_loop];
        tip_width_percent = protector_tip_width_percent[protector_loop] < 0
                            || len(protector_tip_width_percent) < protector_loop + 1
                            ? protector_tip_width_percent[0]
                            : protector_tip_width_percent[protector_loop];
        loop_height =  protector_loops_height[protector_loop] < 0
                            || len(protector_loops_height) < protector_loop + 1
                            ? protector_default_height
                            : protector_loops_height[protector_loop];
        loop_align_percent = len(protector_loops_align_percent) < protector_loop + 1
                            ? 0
                            : protector_loops_align_percent[protector_loop];
        height_align = ((protector_default_height + no_protector_width_between_loops) * protector_loop
                                + protector_default_height / 2 - wheel_width / 2 - aBit / 2)
                            + (protector_default_height + no_protector_width_between_loops) / 100 * loop_align_percent
                            + (protector_default_height - loop_height) / 2;

        
        protector_loop(height_align = height_align,
                        phase_percent = phase_percent,
                        element_count = element_count,
                        depth = depth,
                        tip_width_percent = tip_width_percent,
                        height = loop_height);
    }
}

module protector_loop(height_align, phase_percent, element_count, depth, tip_width_percent, height) {
    protector_element_period = 360 / element_count;
    protector_bottom_angle = protector_element_period / 100 * (100 - tip_width_percent);
    phase = protector_element_period / 100 * phase_percent;

    rotate([0, 0, phase - aBit])
        translate([0, 0, height_align])
            for(angle = [0: 360 / element_count : 360 - aBit]) {
                rotate([0, 0, angle]) protector_element(angle = protector_bottom_angle, depth = depth, height = height);
            }
}

module protector_element(angle, depth, height) {
    rotate_extrude(angle = angle)
            protector_notch_profile(depth, height);
}

module protector_notch_profile(depth, height) {
    translate([wheel_radius - depth, -protector_default_height / 2, 0])
        square([depth * 2, height]);
}

// ----- Tire Modules -----
module tire() {
    difference() {
        rotate_extrude(angle = rotate_angle, convexity = 6)
            tire_profile();
        if (add_protector) protector();
    }
}

module tire_profile() {
    difference() {
        tire_profile_itself();
        translate([-tire_stretching / 2, 0, 0]) rim_external_profile();
    }
}    

module tire_profile_itself() {
    difference() {
        bare_tire_profile();
        tire_bevels_profile();
    }
}

module tire_bevels_profile() {
    translate([wheel_radius, wheel_width / 2 - tire_bevel_width[0]])
        rotate([0, 0, tire_bevel_angle[0]])
            square(tire_bevel_width[0] * 2);
    translate([wheel_radius, -wheel_width / 2 + tire_bevel_width[1]])
        rotate([0, 0, -90 - tire_bevel_angle[1]])
            square(tire_bevel_width[1] * 2);
}

module bare_tire_profile() {
    max_slot_depth = max(tire_slots_depth);
    translate([rim_external_radius - max_slot_depth - tire_stretching / 2, -wheel_width / 2])
        square([tire_thicknes + max_slot_depth + tire_stretching / 2, wheel_width]);
}

module tire_slots_profile() {
    for (i = [0: tire_slots_count - 1]) {
        tire_slot_depth = tire_slots_depth[i];
        tire_slot_width_external = tire_slots_width_external[i];
        tire_slot_angles = tire_slots_angles[i];
        tire_slot_align_percent = tire_slots_align_percent[i];
        tire_slot_align_mm = tire_slots_align_mm[i];
            
            tire_slot_align = (tire_slot_align_percent < 0)
                ? tire_slot_align_mm
                : (rim_external_height - tire_slot_width_external) * tire_slot_align_percent / 100;
            
            tire_slot_profile(depth = tire_slot_depth,
                     width_external = tire_slot_width_external,
                     angles = tire_slot_angles,
                     align = tire_slot_align);
    }
}

module tire_slot_profile(depth, width_external, angles, align) {
    translate([rim_external_radius - depth, align - rim_external_height / 2, 0]) {
        difference() {
            square([depth, width_external]);
            translate([depth, 0, 0]) rotate([0, 0, 180 - angles[0]]) square(depth + width_external);
            translate([depth, width_external, 0]) rotate([0, 0, 90 + angles[1]]) square(depth + width_external);
        }
    }
}

// ----- Hub modules -----
module hub() {
    difference() {
        hub_cylinder(height = hub_height, align = calc_hub_align(), angle = rotate_angle);
        hub_hole();
    }
}

function calc_hub_align() = -(wheel_width - hub_height) / 2 + hub_align - aBit;

module hub_hole_flat() {
    difference() {
        size = hub_hole_diameter * 2; // to be sure that cube is bigger enough
        flat_shift = size / 2 - hub_hole_diameter / 2 + hub_hole_flat_diameter + hub_hole_extension;
        
        translate([flat_shift, 0, 0]) cube([size, size, hub_height + 2 * aBit], center = true);
    }
}

module hub_cylinder(height, align, angle) {
    translate([0, 0, align])
        rotate_extrude(angle = angle, convexity = 6)
            translate([0, -height / 2, 0]) square([hub_radius, height]);
}

module hub_hole() {
    hub_hole_cap_shift = aBit / 2 + hub_hole_cap_hight;
    hub_hole_cap_align = !hub_hole_add_cap ? 0 :
                            hub_hole_cap_position == "t" ? -hub_hole_cap_shift : hub_hole_cap_shift;
    
    translate ([0, 0, hub_hole_cap_align + calc_hub_align()]) rotate([0, 0, hub_hole_flat_angle])
        difference() {
            hub_hole_cylinder();
            hub_hole_flat();
        }
}

module hub_hole_cylinder(diameter = hub_hole_diameter) {
    cylinder(d = diameter + hub_hole_extension, h = hub_height + aBit, center = true);   
}

// ----- Spoke Modules -----
module spokes() {
    align = -(wheel_width - spoke_height) / 2 + spoke_align;
    
    difference() {
        translate([0, 0, align]) {
            difference() {
                for(angle = [0: 360 / spoke_count : 360 - aBit]) {
                     color("pink") rotate([0, 0, angle]) spoke();
                }
                rim_internal(thicknes = spoke_full_length, height = wheel_width * 5, angle = 360);
            }
        }
        hub_cylinder(height = (wheel_width + spoke_height) * 3, align = 0, angle = 360);
    }
}

module spoke() {
    let (spoke_offset = spoke_full_length / 2 + hub_radius - spoke_inner_length_correction) {
        translate([spoke_offset, 0, 0]) {
            cube([spoke_full_length, spoke_width, spoke_height], center = true);
        }
    }
}

// ----- Disc Modules -----
module disc() {
    align = -(wheel_width - disc_thickness) / 2 + disc_align;
    
    translate([0, 0, align]) {
        difference() {
            disc_itself();
            disc_hole();
        }
    }
}

module disc_itself() {
    cylinder(h = disc_thickness, d = disc_outer_diameter, center = true);
}

module disc_hole() {
    cylinder(h = disc_thickness + aBit, d = disc_inner_diameter, center = true);
}

// ----- Rim Modules -----
module rim() {
    color("purple") rim_internal();
    rim_external();
}

module rim_external() {
    rotate_extrude(angle = rotate_angle, convexity = 6) {
        rim_external_profile();
    }
}

module rim_external_profile() {
    difference() {
        rim_external_profile_itself();
        if (add_tire_slots) tire_slots_profile();
    }
}

module rim_external_profile_itself() {
    let (align = -(wheel_width - rim_external_height) / 2 + rim_external_align) {
        translate([0, align, 0]) {
            bare_rim_external_profile();
        }
    }
}

module bare_rim_external_profile() {
    translate([rim_external_inner_radius, - rim_external_height / 2, 0])
        square([rim_external_thicknes, rim_external_height]);
}

module rim_internal(thicknes = rim_internal_thicknes, height = rim_internal_height, angle = rotate_angle) {
    rotate_extrude(angle = angle, convexity = 6) {
        rim_internal_profile(thicknes = thicknes, height = height);
    }
}

module rim_internal_profile(thicknes, height) {
    let (align = -(wheel_width - rim_internal_height) / 2 + rim_internal_align) {
        translate([0, align, 0]) {
            bare_rim_internal_profile(thicknes = thicknes, height = height);
        }
    }
}

module bare_rim_internal_profile(thicknes, height) {
    translate([rim_internal_inner_radius, - rim_internal_height / 2, 0])
        square([thicknes, height]);
}

// ----- Math Modules -----
module trapezia(base_width = 5, top_width = 3, height = 3) {
    points = [
        [0, base_width / 2],
        [0, -base_width / 2],
        [height, -top_width / 2],
        [height, top_width / 2],
    ];
    polygon(points);
}

module triangle(base_width = 5, height = 3) {
    trapezia(base_width = base_width, top_width = 0, height = height);
}

// calculates sagitta (how deep cube has overlap cylinder to have no gap between them)
function cube_to_cylinder(w, r) = r - sqrt(r * r - pow(w / 2, 2));

wheel_generator();
$fs = 0.1;
// $fn = 300;

/* [Tab] */
render_part = "a"; // [a:Wheel, b:Tire, c:Wheel And Tire Joined]

wheel_radius = 20;
wheel_width = 8;

// rim обод
// hub ступица
// shaft ось
// spoke спица

/* [Hub] */
hub_radius = 4;

// -1 - the same as 0.75 of wheel width
hub_height_mm = -1;

hub_hole_diameter = 3;
hub_hole_flat_diameter = 2.5;
hub_hole_flat_angle = 0;

hub_hole_add_cap = false;
hub_hole_cap_position = "t"; // [t:Top, b:Bottom]
hub_hole_cap_hight = 1; 

// makes hole larger for this value (in mm)
hub_hole_extension = 0.17;

// 0 - hub is aligned to one side of the wheel, 50 - in the middle, 100 - to another side
// -1 - means that hub_align_mm is used
// percent calculated from wheel width
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

add_disc = true;

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
rim_internal_height_mm = -1;

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
rim_external_align_percent = 50; // [-1:1:100]

// the same, but in mm. Could be negative
rim_external_align_mm = 0;

/* [Global] */

/*[Hidden]*/
// a small value to increment/decrement values when needed
aBit = 0.1; 

hub_height = (hub_height_mm == -1) ? wheel_width * 0.75 : hub_height_mm;
spoke_height = (spoke_height_mm == -1) ? wheel_width / 3 : spoke_height_mm;
rim_internal_height = (rim_internal_height_mm == -1) ? spoke_height * 2 : rim_internal_height_mm;
rim_external_height = (rim_external_height_mm == -1) ? wheel_width : rim_external_height_mm;

// ----- Calc additional values -----
spoke_length = wheel_radius - hub_radius - rim_internal_thicknes - rim_external_thicknes;

rim_internal_inner_radius = hub_radius + spoke_length;

rim_external_inner_radius = hub_radius + spoke_length + rim_internal_thicknes;

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

// circle calculations https://www.mathopenref.com/sagitta.html

module whole_wheel() {
    if (render_part == "a") wheel();
    else if (render_part == "b") tire();
    else if (render_part == "c") union() {wheel(); tire();}
}

// ----- Wheel Modules -----
module wheel() {
    difference() {
        union() {
            hub();
            spokes();
            if (add_disc) color("BurlyWood") disc();
            rim();
        }
        hub_hole(); // one more time for thick spokes and disc
    }
}

module hub() {
    difference() {
        color("green") hub_cylinder();
        hub_hole();
    }
}

function calc_hub_align() = -(wheel_width - hub_height) / 2 + hub_align;

module hub_hole_flat() {
    difference() {
        size = hub_hole_diameter * 2; // to be sure that cube is bigger enough
        flat_shift = size / 2 - hub_hole_diameter / 2 + hub_hole_flat_diameter + hub_hole_extension;
        
        translate([flat_shift, 0, 0]) cube([size, size, hub_height + 2 * aBit], center = true);
    }
}

module hub_cylinder() {
    translate([0, 0, calc_hub_align()])
        cylinder(r = hub_radius, h = hub_height, center = true);
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

module spokes() {
    align = -(wheel_width - spoke_height) / 2 + spoke_align;
    
    translate([0, 0, align]) {
        intersection() {
            for(angle = [0: 360 / spoke_count : 360 - aBit]) {
                 color("pink") rotate([0, 0, angle]) spoke();
            }
            rim_internal_hole(spoke_height + aBit);
        }
    }
}

module spoke() {
    let (inner_length_correction = hub_radius,
        outer_length_correction = rim_internal_inner_radius,
        length = spoke_length + inner_length_correction + outer_length_correction,
        spoke_distance = length / 2 + hub_radius - inner_length_correction) {

        translate([spoke_distance, 0, 0]) {
            cube([length, spoke_width, spoke_height], center = true);
        }
    }
}

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

module rim() {
    union () {
        color("purple")  rim_internal();
        rim_external();
    }
}

module rim_internal() {
    let (align = -(wheel_width - rim_internal_height) / 2 + rim_internal_align) {
        
        translate([0, 0, align]) {
            difference() {
                rim_internal_itself();
                rim_internal_hole();
            }
        }
    }
}

module rim_external() {
    let (align = -(wheel_width - rim_external_height) / 2 + rim_external_align) {
        
        translate([0, 0, align]) {
            difference() {
                rim_external_itself();
                rim_external_hole();
            }
        }
    }
}

module rim_external_itself() {
    let (radius = rim_external_inner_radius + rim_external_thicknes) {
        cylinder(h = rim_external_height, r = radius, center = true);
    }
}

module rim_external_hole(height = rim_external_height + aBit) {
    cylinder(h = height, r = rim_external_inner_radius, center = true);
}

module rim_internal_itself() {
    let (radius = rim_internal_inner_radius + rim_internal_thicknes) {
        cylinder(h = rim_internal_height, r = radius, center = true);
    }
}

module rim_internal_hole(height = rim_internal_height + aBit) {
    cylinder(h = height, r = rim_internal_inner_radius, center = true);
}

// ----- Tire Modules -----
module tire() {
    differense() {
        rubber_part();
        rim_part();
    }
    rotate_extrude() trapezia();
}

module rubber_part() {
    
}

module rim_part() {
    
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
*rotate_extrude(angle=90) trapezia(base_width = 5, height = 7);

// calculates sagitta (how deep cube has overlap cylinder to have no gap between them)
function cube_to_cylinder(w, r) = r - sqrt(r * r - pow(w / 2, 2));

whole_wheel();
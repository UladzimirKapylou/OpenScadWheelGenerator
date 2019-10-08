$fs = 0.1;
// $fn = 300;

/* [Tab] */
render_part = "a"; // [a:Wheel, b:Tire, c:Wheel And Tire Joined]

wheel_radius = 20;

// rim обод
// hub ступица
// shaft ось
// spoke спица

/* [Hub] */
hub_radius = 4;
hub_height = 7;

hub_hole_diameter = 3;
hub_hole_flat_diameter = 2.5;
hub_hole_flat_angle = 0;

// makes hole larger for this value (in mm)
hub_hole_extension = 0.2;

/* [Spokes] */
spoke_count = 5;
spoke_width = 2;
spoke_height = 7;

/* [Rim] */
rim_thicknes = 2;
rim_height = 7;

// utility small value to increment/decrement values when needed
aBit = 0.1; 

/* [Global] */
/*[Hidden]*/
spoke_length = wheel_radius - hub_radius - rim_thicknes;
rim_inner_radius = hub_radius + spoke_length;

// circle calculations https://www.mathopenref.com/sagitta.html

module whole_wheel() {
    if (render_part == "a") wheel();
    else if (render_part == "b") tire();
    else if (render_part == "c") union() {wheel(); tire();}
}

// ----- Wheel Modules -----
module wheel() {
    union() {
    hub();
    spokes();
    rim();}
}

module hub() {
    difference() {
        color("green") hub_cylinder();
        rotate([0, 0, hub_hole_flat_angle]) difference() {
            hub_hole();
            hub_hole_flat();
        }
    }
}

module hub_hole_flat() {
    difference() {
        size = hub_hole_diameter * 2; // to be sure
        
        hub_hole(size);
        flat_shift = size / 2 - hub_hole_diameter + hub_hole_flat_diameter - hub_hole_extension;
        
        translate([flat_shift, 0, 0]) cube([size, size, hub_height + 2 * aBit], center = true);
    }
}

module hub_cylinder() {
    linear_extrude(height = hub_height, center = true)
    circle(r = hub_radius);
}

module hub_hole(diameter = hub_hole_diameter) {
    cylinder(d = diameter + hub_hole_extension, h = hub_height + aBit, center = true);   
}

module spokes() {
    for(angle = [0: 360 / spoke_count : 360 - aBit]) {
         color("pink") rotate([0, 0, angle]) spoke();
    }
}

module spoke() {
    let (inner_length_correction = cube_to_cylinder(spoke_width, hub_radius),
        outer_length_correction = cube_to_cylinder(spoke_width, rim_inner_radius),
        length = spoke_length + inner_length_correction + outer_length_correction,
        spoke_distance = length / 2 + hub_radius - inner_length_correction) {

        translate([spoke_distance, 0, 0]) {
            cube([length, spoke_width, spoke_height], center = true);
        }
    }
}

module rim() {
    difference() {
        rim_itself();
        rim_inner_cylinder();
    }
}

module rim_itself() {
    let (radius = rim_inner_radius + rim_thicknes) {
        cylinder(h = rim_height, r = radius, center = true);
    }
}

module rim_inner_cylinder() {
    cylinder(h = rim_height + 1, r = rim_inner_radius, center = true);
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
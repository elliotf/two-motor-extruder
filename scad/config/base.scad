// All hail whosawhatsis
da6 = 1 / cos(180 / 6) / 2;
da8 = 1 / cos(180 / 8) / 2;

approx_pi = 3.14159;

// make coordinates more communicative
left  = -1;
right = 1;
front = -1;
rear  = 1;
top = 1;
bottom  = -1;

// address vector positions by their name
x = 0;
y = 1;
z = 2;

// Screws, nuts
m3_diam = 3;
m3_nut_diam  = 5.5;
m3_nut_thickness  = 3;
m3_socket_head_diam = 6;
m3_socket_head_height = 3;
m5_diam = 5;
m5_nut_diam = 8;
m5_nut_thickness = 5;

// Motors
nema17_side = 43;
nema17_len = nema17_side;
nema17_hole_spacing = 31;
nema17_screw_diam = m3_diam;
nema17_shaft_diam = 5;
nema17_shaft_len = 16.5;
nema17_short_shaft_len = 0;
nema17_shoulder_height = 2;
nema17_shoulder_diam = nema17_hole_spacing*.75;

nema14_side = 35.3;
nema14_len = nema14_side;
nema14_hole_spacing = 26;
nema14_screw_diam = m3_diam;
nema14_shaft_diam = 5;
nema14_shaft_len = 20;
nema14_short_shaft_len = 20;
nema14_shoulder_height = 2;
nema14_shoulder_diam = 22;

motor_side = nema17_side;
motor_len = motor_side;
motor_hole_spacing = nema17_hole_spacing;
motor_screw_diam = nema17_screw_diam;
motor_shaft_diam = nema17_shaft_diam;
motor_shaft_len = nema17_shaft_len;
motor_short_shaft_len = nema17_short_shaft_len;
motor_shoulder_height = nema17_shoulder_height;
motor_shoulder_diam = nema17_shoulder_diam;

/*
*/
motor_side = nema14_side;
motor_len = motor_side;
motor_hole_spacing = nema14_hole_spacing;
motor_screw_diam = nema14_screw_diam;
motor_shaft_diam = nema14_shaft_diam;
motor_shaft_len = nema14_shaft_len;
motor_short_shaft_len = nema14_short_shaft_len;
motor_shoulder_height = nema14_shoulder_height;
motor_shoulder_diam = nema14_shoulder_diam;

// Misc settings
extrusion_width = 0.66;
extrusion_height = 0.3;
min_material_thickness = extrusion_width*4;
spacer = 1;

// bearing size

// 608
bearing_height = 7;
bearing_outer  = 22;
bearing_inner  = 8;

// 626
bearing_height = 6;
bearing_outer  = 19;
bearing_inner  = 6;

// 625
bearing_height = 5;
bearing_outer  = 16;
bearing_inner  = 5;

filament_diam = 3;

include <config.scad>;

filament_from_carriage = hotend_diam / 2 + 8; // make sure the hotend can clear the carriage
filament_x = hobbed_diam/2 + filament_diam/2 - .6;

// bearing helps provide clearance for motor mount screws
gear_side_bearing_y = bearing_height/2-m3_socket_head_height+1;

// MR105ZZ
//idler_bearing_outer     = 10;
//idler_bearing_inner     = 5;
//idler_bearing_thickness = 4;
//idler_nut_diam          = 8;

// 625ZZ
idler_bearing_height = 5;
idler_bearing_outer  = 16;
idler_bearing_inner  = 5;
idler_nut_diam       = m5_nut_diam;

idler_width        = idler_bearing_height+14;
idler_thickness    = idler_bearing_inner+3+1;
idler_shaft_diam   = idler_bearing_inner;
idler_shaft_length = idler_width*2;
idler_x            = filament_x + idler_bearing_outer/2 + filament_diam/2;

main_body_motor_side_width = bearing_outer/2+3;
main_body_open_side_width  = idler_x + idler_shaft_diam/2 + 2;
main_body_width            = main_body_motor_side_width + main_body_open_side_width;
main_body_x                = main_body_open_side_width-main_body_width/2;

idler_screw_from_shaft       = bearing_outer/2+idler_screw_nut_diam/2+2;
main_body_idler_side_height  = idler_screw_from_shaft + idler_screw_nut_diam/2 + min_material_thickness*2;
main_body_idler_side_height  = bearing_outer/2 + 2 + 4 + 2;
main_body_hotend_side_height = bearing_outer/2 + 10;
main_body_height             = main_body_idler_side_height + main_body_hotend_side_height;
main_body_z                  = main_body_idler_side_height - main_body_height/2;

hotend_retainer_width_motor_side = main_body_motor_side_width + abs(filament_x);
hotend_retainer_diam             = hotend_diam + min_material_thickness*2;
hotend_retainer_width_idler_side = hotend_retainer_diam/2;
hotend_retainer_width            = hotend_retainer_width_idler_side + hotend_retainer_width_motor_side;

hotend_retainer_height           = hotend_height_above_groove + hotend_groove_height;
hotend_retainer_x                = filament_x - hotend_retainer_width_motor_side + hotend_retainer_width/2;
hotend_retainer_z                = 0;

// motor position
motor_y = mount_plate_thickness;
motor_z = -motor_hole_spacing/2;
motor_x = -1*(main_body_motor_side_width+0.1+motor_side/2);

gear_dist = sqrt(pow(abs(motor_x),2)+pow(abs(motor_z),2));

idler_screw_spacing = (idler_width - idler_bearing_height - 2);

idler_lower_half = 0;
idler_upper_half = idler_screw_from_shaft+idler_screw_diam/2+3;
idler_thumb_lever_thickness = 3;
idler_thumb_lever_length = 6;

bowden_retainer_clip_outer = 12;

filament_y   = mount_plate_thickness + filament_diam;
total_depth  = filament_y + idler_bearing_height * 1.75;
total_height = motor_side + bottom_thickness;

idler_gap_width = 1;
idler_height       = main_body_height - 2;
idler_hinge_height = 2;
idler_gap_x        = idler_x - idler_shaft_diam/2 - 1 - idler_gap_width/2;
idler_gap_z        = main_body_z + (main_body_height/2 - idler_height/2);

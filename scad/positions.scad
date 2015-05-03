include <config.scad>;

// bearing helps provide clearance for motor mount screws
gear_side_bearing_y = bearing_height/2-m3_socket_head_height+1;

main_body_motor_side_width = bearing_outer/2+3;
main_body_open_side_width  = bearing_outer/2+1;
main_body_width            = main_body_motor_side_width + main_body_open_side_width;
main_body_x                = main_body_open_side_width-main_body_width/2;


idler_screw_from_shaft       = bearing_outer/2+idler_screw_nut_diam/2+2;
ext_shaft_hotend_dist        = bearing_outer/2 + 3;
hotend_z                     = -1*ext_shaft_hotend_dist;
main_body_idler_side_height  = idler_screw_from_shaft + idler_screw_nut_diam/2 + min_material_thickness*2;
main_body_idler_side_height  = bearing_outer/2 + 3;
main_body_hotend_side_height = ext_shaft_hotend_dist;
main_body_height             = main_body_idler_side_height + main_body_hotend_side_height;
main_body_z                  = main_body_idler_side_height - main_body_height/2;

hotend_retainer_width_motor_side = main_body_motor_side_width + abs(filament_x);
hotend_retainer_diam             = hotend_diam + min_material_thickness*2;
hotend_retainer_width_idler_side = hotend_retainer_diam/2;
hotend_retainer_width            = hotend_retainer_width_idler_side + hotend_retainer_width_motor_side;

hotend_retainer_height           = hotend_height_above_groove + hotend_groove_height;
hotend_retainer_x                = filament_x - hotend_retainer_width_motor_side + hotend_retainer_width/2;
hotend_retainer_z                = -1*(ext_shaft_hotend_dist + hotend_retainer_height/2);

// motor position
motor_y = mount_plate_thickness;
motor_z = -motor_hole_spacing/2;
//motor_x = -sqrt(pow(gear_dist,2)-pow(motor_z,2));
motor_x = -1*(main_body_motor_side_width+0.1+motor_side/2);

gear_dist = sqrt(pow(abs(motor_x),2)+pow(abs(motor_z),2));


module position_motor() {
  translate([motor_x,motor_y,motor_z]) {
    rotate([90,0,0]) {
      children();
    }
  }
}

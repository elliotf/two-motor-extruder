include <main.scad>;

show_drive_side = 1;
show_idler_side = 1;
show_bridges    = 0;
show_motors     = 1;

idler_assembly_angle = 0;

module assembly() {
  // filament path
  % hole(filament_diam, motor_side*2, resolution);

  // idler screw
  % translate([idler_nut_pos_x,idler_nut_pos_y,idler_nut_pos_z]) {
    rotate([90,0,0]) {
      hole(m3_nut_diam, 3, 6);
      translate([0,0,15]) {
        hole(m3_diam, 30, resolution);
      }
    }
  }

  if (show_drive_side) {
    translate([drive_motor_x+0.05,drive_motor_y,drive_motor_z]) {
      color("orange") drive_side();
    }

    translate([0.05,0,0]) {
      position_drive_motor() {
        if (show_motors) {
          % motor();
        }

        translate([0,0,drive_motor_x]) {
          % color("silver") hobbed_pulley();
        }
      }
    }
  }

  if (show_idler_side) {
    translate([idler_motor_x-0.05,0,hinge_pos_z]) {
      rotate([idler_assembly_angle,0,0]) {
        translate([0,idler_motor_y,-hinge_pos_z]) {
          color("lightblue") idler_side();
        }
      }
    }
    translate([-0.05,0,0]) {
      position_idler_motor() {
        if (show_motors) {
          % motor();
        }

        translate([0,0,-idler_motor_x]) {
          % color("silver") hobbed_pulley();
        }
      }
    }
  }
}

assembly();

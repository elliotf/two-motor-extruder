include <scad/config.scad>;
use <scad/rewrite_simpler.scad>;

// settings

hobbed_pulley_diam           = 9;
hobbed_pulley_effective_diam = 6.9;
hobbed_pulley_len            = 11;
hobbed_pulley_hob_diam       = 5;
hobbed_pulley_hob_to_base    = 8;

filament_diam                = 3;
filament_opening_diam        = filament_diam + 0.5;
filament_bowden_diam         = 6.5;

resolution                   = 32;

// positions

motor_x = motor_shaft_len/2 + motor_shoulder_height + 1;
motor_y = filament_diam/2 + hobbed_pulley_effective_diam/2;

rounded_diam          = motor_side - motor_hole_spacing;
motor_mount_thickness = 4;

drive_motor_x = motor_x * right;
drive_motor_y = motor_y * rear;
drive_motor_z = 0;
idler_motor_x = motor_x * left;
idler_motor_y = motor_y * front;
idler_motor_z = 0;

hinge_diam      = 12;
hinge_len       = drive_motor_x - idler_motor_x - 0.5 - motor_mount_thickness*2;
hinge_gap       = 0.5;
hinge_opening_diam = hinge_diam + hinge_gap*2;
hinge_body_diam = hinge_opening_diam + extrusion_width * 8;
hinge_pos_y     = front*(hinge_body_diam/2);
hinge_pos_z     = -motor_side/2-hinge_diam/2;

module position_drive_motor() {
  translate([motor_x,motor_y,0]) {
    rotate([0,-90,0]) {
      children();
    }
  }
}

module position_idler_motor() {
  translate([idler_motor_x,idler_motor_y,0]) {
    rotate([0,90,0]) {
      children();
    }
  }
}

module drive_side() {
  drive_hinge_pos_y = -drive_motor_y + hinge_pos_y;
  drive_hinge_pos_z = drive_motor_z + hinge_pos_z;

  module body() {
    hull() {
      translate([-motor_mount_thickness/2,0,0]) {
        rotate([0,90,0]) {
          hole(motor_shoulder_diam+1+extrusion_width*8,motor_mount_thickness,resolution);
        }
        for(d=[motor_hole_spacing/2]) {
          for(coords=[[0,d,d],[0,-d,-d],[0,d,-d]]) {
            translate(coords) {
              rotate([0,90,0]) {
                hole(rounded_diam,motor_mount_thickness,resolution);
              }
            }
          }
        }
      }

      translate([-motor_mount_thickness/2,drive_hinge_pos_y,drive_hinge_pos_z]) {
        rotate([0,90,0]) {
          hole(hinge_body_diam,motor_mount_thickness,resolution);
        }
      }
    }

    hull() {
      translate([-motor_mount_thickness/2,0,0]) {
        for(d=[motor_hole_spacing/2]) {
          for(coords=[[0,d,-d],[0,-d,-d]]) {
            translate(coords) {
              rotate([0,90,0]) {
                hole(rounded_diam,motor_mount_thickness,resolution);
              }
            }
          }
        }
      }
      translate([-motor_mount_thickness-hinge_len/2,drive_hinge_pos_y,drive_hinge_pos_z]) {
        rotate([0,90,0]) {
          hole(hinge_body_diam,hinge_len,resolution);
        }
      }
    }
  }

  module holes() {
    // motor shoulder
    hull() {
      rotate([0,90,0]) {
        hole(motor_shoulder_diam+1,motor_shoulder_height*2+1,resolution);
        hole(hobbed_diam+1,motor_x*2,resolution);
      }
    }

    // hinge void
    translate([-motor_mount_thickness-hinge_len,drive_hinge_pos_y,drive_hinge_pos_z]) {
      rotate([0,90,0]) {
        hole(hinge_opening_diam,hinge_len*2,resolution);
      }

      for(r=[0,10]) {
        rotate([r,0,0]) {
          translate([0,hinge_opening_diam/4,motor_side/2]) {
            cube([hinge_len*2,hinge_opening_diam/2,motor_side],center=true);
          }
        }
      }
    }

    // filament_path
    translate([-drive_motor_x,-drive_motor_y,0]) {
      hole(filament_opening_diam,motor_side*3,8);
    }

    // motor screw holes
    translate([-drive_motor_x,0,0]) {
      for(y=[front,rear]) {
        for(z=[top,bottom]) {
          translate([0,motor_hole_spacing/2*y,motor_hole_spacing/2*z]) {
            rotate([0,90,0]) {
              # hole(m3_diam,motor_len*2,resolution);
            }
          }
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module hobbed_pulley() {
  hob_rounded_radius = hobbed_pulley_effective_diam/2 + hobbed_pulley_hob_diam/2;
  difference() {
    translate([0,0,hobbed_pulley_len/2 - hobbed_pulley_hob_to_base]) {
      hole(hobbed_pulley_diam,hobbed_pulley_len,resolution);
    }

    rotate_extrude() {
      translate([hob_rounded_radius,0]) {
        circle(r=hobbed_pulley_hob_diam/2,$fn=resolution);
      }
    }
  }
}

// hinge area
% translate([0,hinge_pos_y,hinge_pos_z]) {
  rotate([0,90,0]) {
    hole(hinge_diam,hinge_len,resolution);
  }
}

// filament path
% hole(filament_diam, motor_side*2, resolution);

translate([drive_motor_x,drive_motor_y,drive_motor_z]) {
  drive_side();
}

position_drive_motor() {
  % motor();

  translate([0,0,motor_x]) {
    % hobbed_pulley();
  }
}

position_idler_motor() {
  % motor();

  translate([0,0,motor_x]) {
    % hobbed_pulley();
  }
}

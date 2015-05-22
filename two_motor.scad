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

rounded_diam           = motor_side - motor_hole_spacing;
motor_screw_length     = 14;
motor_screw_hole_depth = 3;
motor_mount_thickness  = motor_screw_length - motor_screw_hole_depth;

hinge_len            = motor_x;
hinge_gap            = 0.05;
hinge_diam           = 5;
hinge_nut_diam       = 8;
hinge_nut_outer_diam = 9;
hinge_opening_diam   = hinge_diam + hinge_gap*2;
hinge_body_diam      = max(hinge_opening_diam,hinge_nut_diam) + extrusion_width * 8;
hinge_pos_y          = front*(filament_bowden_diam/2+hinge_body_diam/2);
hinge_pos_z          = -motor_side/2-hinge_nut_outer_diam/2;
hinge_offset         = filament_bowden_diam + 1;

drive_motor_x = (motor_x-hinge_offset/2) * right;
drive_motor_y = motor_y * rear;
drive_motor_z = 0;
idler_motor_x = (motor_x+hinge_offset) * left;
idler_motor_y = motor_y * front;
idler_motor_z = 0;

drive_side_height = abs(drive_motor_x) + hinge_offset;
idler_side_height = abs( abs(drive_motor_x - drive_side_height) - abs(idler_motor_x) );

show_drive_side = 1;
show_idler_side = 1;

module position_drive_motor() {
  translate([drive_motor_x,drive_motor_y,0]) {
    rotate([0,-90,0]) {
      children();
    }
  }
}

module cut_rounded_corner(diam,height=50) {
  translate([diam/2,diam/2,0]) {
    difference() {
      translate([-1,-1,0]) {
        cube([diam+1,diam+1,height],center=true);
      }
      hole(diam,height+1, resolution);
      translate([0,diam/2,0]) {
        cube([diam,diam,height+1],center=true);
      }
      translate([diam/2,0,0]) {
        cube([diam,diam,height+1],center=true);
      }
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

module base_body(main_height, hinge_coords) {
  hole_dist = motor_hole_spacing/2;
  hull() {
    for(d=[hole_dist]) {
      for(coords=[[0,d,-d],[0,-d,-d],[0,d,d],[0,-d,d]]) {
        translate(coords) {
          rotate([0,90,0]) {
            hole(rounded_diam,main_height,resolution);
          }
        }
      }
    }
    translate(hinge_coords) {
      rotate([0,90,0]) {
        hole(hinge_body_diam,main_height,resolution);
      }
    }
  }
}

module base_holes() {
}

module drive_side() {
  drive_hinge_pos_y = -drive_motor_y + hinge_pos_y;
  drive_hinge_pos_z = drive_motor_z + hinge_pos_z;

  main_height = drive_side_height;
  hinge_coords = [0,drive_hinge_pos_y,drive_hinge_pos_z];

  module body() {
    // same as above, but for main body
    hull() {
      translate([-main_height/2,0,0]) {
        base_body(main_height, hinge_coords);
      }
      // filament body
      translate([-drive_motor_x,-drive_motor_y,hinge_pos_z]) {
        hole(filament_bowden_diam+2,hinge_body_diam,resolution);
      }
    }
  }

  module holes() {
    // motor shoulder
    hull() {
      rotate([0,90,0]) {
        hole(motor_shoulder_diam+1,motor_shoulder_height*2,resolution);
        hole(hobbed_diam+1,(abs(drive_motor_x)-filament_diam/2)*2,resolution);
      }
    }

    translate([-main_height-1,-drive_motor_y+idler_motor_y,0]) {
      hull() {
        rotate([0,90,0]) {
          hole(motor_shoulder_diam+1,2,resolution);
          hole(hobbed_diam+1,main_height-hinge_offset,resolution);
        }
      }
    }

    // hobbed pulley area
    translate([-main_height/2,0,0]) {
      hull() {
        for(coords=[[0,0,0],[0,-motor_side/2,0]]) {
          translate(coords) {
            rotate([0,90,0]) {
              hole(hobbed_pulley_diam+1,main_height+1,resolution);
            }
          }
        }
      }

      for(side=[top,bottom]) {
        translate([0,-motor_side/2,side*(hobbed_pulley_diam+1)/2]) {
          rotate([0,90*-side,0]) {
            cut_rounded_corner(rounded_diam);
          }
        }
      }
    }

    // hinge void
    translate([0,drive_hinge_pos_y,drive_hinge_pos_z]) {
      translate([-hinge_len-extrusion_height-2,0,0]) {
        rotate([0,90,0]) {
          hole(hinge_opening_diam,hinge_len*2,resolution);
        }
      }
      rotate([0,90,0]) {
        hole(hinge_nut_diam,4,6);
      }
    }

    // filament_path
    translate([-drive_motor_x,-drive_motor_y,0]) {
      //hole(filament_opening_diam,motor_side*3,8);
      hole(filament_bowden_diam,motor_side*3,16);
    }

    // motor screw holes
    for(y=[front,rear]) {
      for(z=[top,bottom]) {
        translate([-motor_x,motor_hole_spacing/2*y,motor_hole_spacing/2*z]) {
          rotate([0,90,0]) {
            hole(m3_diam,motor_len*2,resolution);
            hole(m3_nut_diam,(motor_x-motor_mount_thickness)*2,resolution);

            hull() {
              hole(m3_diam,4,resolution);
              hole(m3_diam+1,1,resolution);
            }
          }
        }
        translate([0,motor_hole_spacing/2*y,motor_hole_spacing/2*z]) {
          rotate([0,90,0]) {
            hull() {
              hole(m3_diam,1+extrusion_width*2,resolution);
              hole(m3_diam+extrusion_width*2,1,resolution);
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

module idler_side() {
  idler_hinge_pos_y = -idler_motor_y + hinge_pos_y;
  idler_hinge_pos_z = idler_motor_z + hinge_pos_z;

  main_height = idler_side_height;
  hinge_coords = [0,idler_hinge_pos_y,idler_hinge_pos_z];

  module body() {
    // same as above, but for main body
    hull() {
      translate([main_height/2,0,0]) {
        base_body(main_height, hinge_coords);
      }
    }
  }

  module holes() {
    // motor shoulder
    hull() {
      rotate([0,90,0]) {
        hole(motor_shoulder_diam+1,motor_shoulder_height*2,resolution);
        hole(hobbed_diam+1,motor_shoulder_diam,resolution);
      }
    }

    translate([main_height+1,-idler_motor_y+idler_motor_y,0]) {
      hull() {
        rotate([0,90,0]) {
          hole(motor_shoulder_diam+1,2,resolution);
          # hole(hobbed_diam+1,main_height-hinge_offset,resolution);
        }
      }
    }

    // hobbed pulley area
    translate([main_height/2,0,0]) {
      hull() {
        for(coords=[[0,0,0],[0,motor_side/2,0]]) {
          translate(coords) {
            rotate([0,90,0]) {
              hole(hobbed_pulley_diam+1,main_height+1,resolution);
            }
          }
        }
      }
    }

    // hinge void
    translate([0,idler_hinge_pos_y,idler_hinge_pos_z]) {
      translate([hinge_len+extrusion_height+2,0,0]) {
        rotate([0,90,0]) {
          hole(hinge_opening_diam,hinge_len*2,resolution);
        }
      }
      rotate([0,90,0]) {
        hole(hinge_nut_diam,4,6);
      }
    }

    // motor screw holes
    for(y=[front,rear]) {
      for(z=[top,bottom]) {
        translate([motor_x,motor_hole_spacing/2*y,motor_hole_spacing/2*z]) {
          rotate([0,90,0]) {
            hole(m3_diam,motor_len*2,resolution);
            hole(m3_nut_diam,(motor_x-motor_mount_thickness)*2,resolution);

            hull() {
              hole(m3_diam,4,resolution);
              hole(m3_diam+1,1,resolution);
            }
          }
        }
        translate([0,motor_hole_spacing/2*y,motor_hole_spacing/2*z]) {
          rotate([0,90,0]) {
            hull() {
              hole(m3_diam,1+extrusion_width*2,resolution);
              hole(m3_diam+extrusion_width*2,1,resolution);
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

if (show_drive_side) {
  translate([drive_motor_x+0.05,drive_motor_y,drive_motor_z]) {
    drive_side();
  }

  translate([0.05,0,0]) {
    position_drive_motor() {
      % motor();

      translate([0,0,drive_motor_x]) {
        % hobbed_pulley();
      }
    }
  }
}


if (show_idler_side) {
  translate([idler_motor_x-0.05,idler_motor_y,idler_motor_z]) {
    idler_side();
  }
  translate([-0.05,0,0]) {
    position_idler_motor() {
      % motor();

      translate([0,0,-idler_motor_x]) {
        % hobbed_pulley();
      }
    }
  }
}

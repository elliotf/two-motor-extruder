include <scad/config.scad>;
use <scad/rewrite_simpler.scad>;

/*

// ideas
printed circular bevel/dovetail so that the idler is prevented from falling out?
  idler would have a circular dovetail that sits in a negative space on the drive side (or vice versa)
  circular path with its origin at the hinge point

// TODO

*/

// settings
hobbed_pulley_diam           = 9;
hobbed_pulley_effective_diam = 6.9;
hobbed_pulley_len            = 11;
hobbed_pulley_hob_diam       = 5;
hobbed_pulley_hob_to_base    = 8;
hobbed_area_opening          = hobbed_pulley_diam + 1;

bowden_tubing_diam        = 6.5;
bowden_retainer_inner     = 11;
bowden_retainer_body_diam = bowden_retainer_inner + 4;
filament_diam             = 3;
filament_opening_diam     = bowden_tubing_diam - 2;

resolution                   = 32;

extrusion_height = .3;
extrusion_width  = .6;

// positions

motor_x = motor_shaft_len/2 + motor_shoulder_height + 1;
motor_y = filament_diam/2 + hobbed_pulley_effective_diam/2;

rounded_diam           = motor_side - motor_hole_spacing;
motor_screw_length     = 10;
motor_screw_hole_depth = 3;
motor_mount_thickness  = motor_screw_length - motor_screw_hole_depth;

hinge_len            = motor_x;
hinge_gap            = 0.05;
hinge_diam           = 5;
hinge_nut_diam       = 8;
hinge_nut_outer_diam = 9;
hinge_opening_diam   = hinge_diam + hinge_gap*2;
hinge_body_diam      = max(hinge_opening_diam,hinge_nut_diam) + extrusion_width * 8;
hinge_pos_y          = front*(bowden_tubing_diam/2+extrusion_width*2+hinge_diam/2);
hinge_pos_z          = -motor_side/2-hinge_nut_outer_diam/2;
hinge_offset         = bowden_retainer_body_diam/2;

drive_motor_x = (motor_x-hinge_offset/2) * right;
drive_motor_y = motor_y * rear;
drive_motor_z = 0;
idler_motor_x = (motor_x+hinge_offset) * left;
idler_motor_y = motor_y * front;
idler_motor_z = 0;

drive_side_height = abs(drive_motor_x) + hinge_offset;
idler_side_height = abs( abs(drive_motor_x - drive_side_height) - abs(idler_motor_x) );

idler_nut_pos_x                 = left*(bowden_tubing_diam/2);
idler_nut_pos_y                 = motor_side*.45;
idler_nut_pos_z                 = motor_side/2 + m3_nut_diam/2;
idler_nut_angle_from_drive_side = -15;
idler_screw_len                 = motor_side;

idler_anchor_pos_x = 0;
idler_anchor_pos_x = 0;

show_drive_side = 1;
show_idler_side = 1;
show_bridges    = 1;

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

module base_body(main_height, hinge_pos_y, opening_side) {
  hole_dist = motor_hole_spacing/2;
  hull() {
    // main body
    for(d=[hole_dist]) {
      for(coords=[[0,d,-d],[0,-d,-d],[0,d,d],[0,-d,d]]) {
        translate(coords) {
          rotate([0,90,0]) {
            hole(rounded_diam,main_height,resolution);
          }
        }
      }
    }
    // hinge
    translate([0,hinge_pos_y,hinge_pos_z]) {
      rotate([0,90,0]) {
        hole(hinge_body_diam,main_height,resolution);
      }
    }
  }
}

module base_holes(main_height, hinge_pos_y, opening_side) {
  // motor shoulder
  rotate([0,90,0]) {
    hole(motor_shoulder_diam,(motor_shoulder_height+1)*2,resolution*2);
    //hole(hobbed_area_opening,(abs(drive_motor_x)-filament_diam/2)*2,resolution*2);
  }

  hull() {
    // clearance for drive-side grub screw
    rotate([0,90,0]) {
      hole(motor_shoulder_diam-4,(motor_shoulder_height+1)*2,resolution*2);
      hole(hobbed_area_opening,(abs(drive_motor_x)-filament_diam/2)*2,resolution*2);
    }
  }

  // bevel the shoulder hole
  translate([-.5*opening_side,0]) {
    hull() {
      rotate([0,90,0]) {
        hole(motor_shoulder_diam+extrusion_width*2,1,resolution*2);
        hole(motor_shoulder_diam,1+extrusion_width*3,resolution*2);
      }
    }
  }

  // clearance for idler-side grub screw
  /*
  translate([opening_side*(main_height+1),0,0]) {
    hull() {
      rotate([0,90,0]) {
        hole(motor_shoulder_diam,2,resolution);
        hole(hobbed_area_opening,main_height-hinge_offset,resolution);
      }
    }
  }
  */

  // hobbed pulley area
  translate([opening_side*main_height/2,0,0]) {
    hull() {
      for(coords=[[0,0,0],[0,opening_side*motor_side/2,0]]) {
        translate(coords) {
          rotate([0,90,0]) {
            hole(hobbed_area_opening,main_height+1,resolution);
          }
        }
      }
    }

    // round the pulley area opening
    for(side=[top,bottom]) {
      translate([0,opening_side*motor_side/2,side*(hobbed_area_opening)/2]) {
        rotate([0,0,90+90*opening_side]) {
          rotate([0,90*-side,0]) {
            cut_rounded_corner(rounded_diam);
          }
        }
      }
    }
  }

  // motor screw holes
  for(y=[front,rear]) {
    for(z=[top,bottom]) {
      translate([main_height*opening_side,motor_hole_spacing/2*y,motor_hole_spacing/2*z]) {
        rotate([0,90,0]) {
          hole(m3_diam,motor_len*2,resolution);
          hole(m3_nut_diam+1,(main_height-motor_mount_thickness)*2,resolution);
        }
      }
      translate([0,motor_hole_spacing/2*y,motor_hole_spacing/2*z]) {
        translate([-.5*opening_side,0,0]) {
          rotate([0,90,0]) {
            hull() {
              hole(m3_diam+extrusion_width*2,1,resolution);
              hole(m3_diam,1+extrusion_width*3,resolution);
            }
          }
        }
      }
    }
  }

  // hinge void
  translate([0,hinge_pos_y,hinge_pos_z]) {
    rotate([0,90,0]) {
      hole(hinge_opening_diam,main_height*2+1,resolution);
    }

    translate([-.5*opening_side,0,0]) {
      rotate([0,90,0]) {
        hull() {
          hole(hinge_opening_diam+extrusion_width*2,1,resolution);
          hole(hinge_opening_diam,1+extrusion_width*3,resolution);
        }
      }
    }
  }
}

module base_bridges(main_height, hinge_pos_y, opening_side) {
  translate([opening_side*(motor_shoulder_height+1+extrusion_height/2),0,0]) {
    rotate([0,90,0]) {
      cube([motor_shoulder_diam+1,motor_shoulder_diam+1,extrusion_height],center=true);
    }
  }
  translate([opening_side*(motor_shoulder_height+1)/2,0,0]) {
    rotate([0,90,0]) {
      hole(motor_shoulder_diam-6,motor_shoulder_height+1,resolution);
    }
  }
}

module drive_side() {
  drive_hinge_pos_y = -drive_motor_y + hinge_pos_y;
  main_height       = drive_side_height;
  filament_pos_x    = -drive_motor_x;
  filament_pos_y    = -drive_motor_y;

  module body() {
    hull() {
      translate([-main_height/2,0,0]) {
        base_body(main_height, drive_hinge_pos_y);
      }
      // filament body at bottom
      translate([filament_pos_x,filament_pos_y,0]) {
        translate([0,0,hinge_pos_z]) {
          hole(bowden_tubing_diam+2,hinge_body_diam,resolution);
        }
      }
    }
  }

  module bowden_retainer_void() {
    translate([0,0,10]) {
      hole(8,20);
    }

    hull() {
      translate([0,0,2]) {
        hole(bowden_retainer_inner,4);
      }
      translate([0,0,7]) {
        translate([0,0,-1]) {
          hole(8,2);
        }
      }
    }
  }

  module holes() {
    base_holes(main_height, drive_hinge_pos_y, front);
    bowden_retainer_lip = extrusion_width*2;

    // filament path
    translate([filament_pos_x,filament_pos_y,0]) {
      hole(filament_opening_diam,motor_side*3,16);

      // bowden retainer holes
      translate([0,0,motor_side/4]) {
        bowden_retainer_void();
      }

      for(side=[top,bottom]) {
        // spool/hotend-side bowden tubing path
        translate([0,0,side*(bowden_retainer_lip+hobbed_area_opening/2+motor_side/2)]) {
          hole(bowden_tubing_diam,motor_side,16);
        }
      }
    }

    # translate([-drive_motor_x,-drive_motor_y,0]) {
      translate([idler_nut_pos_x,idler_nut_pos_y,idler_nut_pos_z]) {
        rotate([0,0,idler_nut_angle_from_drive_side]) {
          rotate([90,0,0]) {
            translate([0,0,motor_side/2]) {
              hole(m3_diam, motor_side, resolution);
            }
            hole(m3_nut_diam, 3, 6);
          }
        }
      }
    }
  }

  module bridges() {
    base_bridges(main_height, drive_hinge_pos_y, front);
  }

  difference() {
    body();
    holes();
  }
  if (show_bridges) {
    bridges();
  }
}

module idler_side() {
  idler_hinge_pos_y = -idler_motor_y + hinge_pos_y;
  main_height       = idler_side_height;

  module body() {
    translate([main_height/2,0,0]) {
      base_body(main_height, idler_hinge_pos_y);
    }
  }

  module holes() {
    base_holes(main_height, idler_hinge_pos_y, rear);
  }

  module bridges() {
    base_bridges(main_height, idler_hinge_pos_y, rear);
  }

  difference() {
    body();
    holes();
  }
  if (show_bridges) {
    bridges();
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

module assembly() {
  // filament path
  % hole(filament_diam, motor_side*2, resolution);

  // idler screw
  /*
  % translate([idler_nut_pos_x,idler_nut_pos_y,idler_nut_pos_z]) {
    rotate([90,0,0]) {
      hole(m3_diam, motor_side, resolution);
      hole(m3_nut_diam, 3, 6);
    }
  }
  */

  if (show_drive_side) {
    translate([drive_motor_x+0.05,drive_motor_y,drive_motor_z]) {
      drive_side();
    }

    translate([0.05,0,0]) {
      position_drive_motor() {
        //% motor();

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
        //% motor();

        translate([0,0,-idler_motor_x]) {
          % hobbed_pulley();
        }
      }
    }
  }
}

module plate() {
  min_dist_between_parts = 5;
  translate([-motor_side/2-min_dist_between_parts,0,0]) {
    rotate([0,90,0]) {
      drive_side();
    }
  }
  translate([motor_side/2+min_dist_between_parts,0,0]) {
    rotate([0,-90,0]) {
      idler_side();
    }
  }
}

//assembly();
plate();

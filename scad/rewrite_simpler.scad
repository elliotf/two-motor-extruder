include <util.scad>
include <config.scad>
include <positions.scad>
use <gears.scad>

module motor() {
  translate([0,0,-motor_len/2]) {
    cube([motor_side,motor_side,motor_len],center=true);

    // shaft
    translate([0,0,motor_len/2+motor_shaft_len/2+motor_shoulder_height])
      cylinder(r=5/2,h=motor_shaft_len,center=true);

    // shoulder
    translate([0,0,motor_len/2+motor_shoulder_height/2])
      cylinder(r=motor_shoulder_diam/2,h=motor_shoulder_height,center=true); // shoulder

    // short shaft
    translate([0,0,-motor_len/2-motor_short_shaft_len/2])
      cylinder(r=5/2,h=motor_short_shaft_len,center=true);
  }
}

module position_motor() {
  translate([motor_x,motor_y,motor_z]) {
    rotate([90,0,0]) {
      children();
    }
  }
}

module assembly() {
  translate([0,0,0]) extruder_body();

  // motor
  % position_motor() motor();

  // extruder shaft
  % translate([0,ext_shaft_length/2-15,0]) rotate([90,0,0]) {
    hole(ext_shaft_diam,ext_shaft_length);
  }

  // hobbed whatnot
  % translate([0,filament_y,0]) rotate([90,0,0]) {
    hole(hobbed_diam,hobbed_width);
  }

  // idler bearing
  % translate([idler_x,filament_y,0]) rotate([90,0,0]) {
    hole(idler_bearing_outer,idler_bearing_height);
  }

  // idler bolt
  % translate([idler_x,mount_plate_thickness/2+total_depth/2,0]) rotate([90,0,0]) {
    hole(idler_bearing_inner,total_depth);
  }

  // filament
  % translate([filament_x,filament_y,0]) {
    hole(filament_diam,60);
  }

  translate([idler_x,filament_y,0.1]) {
    //idler();
  }
}

module bearing() {
  difference() {
    cylinder(r=bearing_outer/2,h=bearing_height,center=true);
    cylinder(r=bearing_inner/2,h=bearing_height+0.05,center=true);
  }
}

module gear_assembly() {
  translate([0,-2.5,0]) rotate([90,0,0]) large_gear();

  translate([-1 * gear_dist,-2,0]) {
    rotate([90,0,0]) small_gear();
  }
}

module extruder_body_base() {
  // motor plate
  rounded_diam = motor_side-motor_hole_spacing;
  hull() {
    position_motor() {
      translate([0,0,mount_plate_thickness/2]) {
        for(x=[1]) {
          for(y=[-1,1]) {
            translate([x*(motor_hole_spacing/2),y*(motor_hole_spacing/2),0]) {
              hole(rounded_diam,mount_plate_thickness);
            }
          }
        }
      }
    }
    // main block
    translate([0,mount_plate_thickness/2,0]) {
      rotate([90,0,0]) {
        hole(rounded_diam,mount_plate_thickness);
      }
    }
  }

  // bowden retainer
  hull() {
    translate([filament_x,0,main_body_z+main_body_height/2+4]) {
      translate([0,filament_y,0]) {
        hole(bowden_retainer_body_diam,8,resolution);
      }
      translate([0,1,0]) {
        rotate([90,0,0]) {
          hole(8,2,resolution);
        }

        translate([0,0,-5]) {
          cube([8,2,1],center=true);
        }
      }
    }
  }

  block_depth = total_depth - mount_plate_thickness;
  // main block
  hull() {
    translate([main_body_x,0,main_body_z]) {
      for(x=[-1,1]) {
        for(z=[-1,1]) {
          translate([x*(main_body_width/2-rounded_diam/2),total_depth/2,z*(main_body_height/2-rounded_diam/2)]) {
            rotate([90,0,0]) {
              hole(rounded_diam,total_depth);
            }
          }
        }
      }
    }

    translate([idler_x,total_depth/2,0]) {
      rotate([90,0,0]) {
        hole(m5_nut_diam+5,total_depth);
      }
      translate([0,0,main_body_z+main_body_height/2-(m5_nut_diam+5)/4]) {
        scale([1,1,.5]) {
          rotate([90,0,0]) {
            hole(m5_nut_diam+5,total_depth);
          }
        }
      }
    }
  }
}

module extruder_body() {
  //intersection() {
    union() {
      difference() {
        extruder_body_base();
        extruder_body_holes();
      }
      color("lightblue") bridges();
    }

    translate([filament_x,filament_y,main_body_z+main_body_height/2+20]) {
      //cube([16,total_depth+1,44],center=true);
    }
  //}
}

module idler_bearing() {
  difference() {
    cylinder(r=idler_bearing_outer/2,h=idler_bearing_height,center=true);
    cylinder(r=idler_bearing_inner/2,h=idler_bearing_height*2,center=true);
  }
}

module idler_bolt_holes() {
  translate([idler_x,0,0]) {
    translate([0,filament_y,0]) {
      rotate([90,0,0]) {
        // bearing
        hull() {
          hole(idler_bearing_outer + 2, idler_bearing_height + 1, resolution);

          translate([0,0,-total_depth]) {
            hole(idler_bearing_outer + 2, idler_bearing_height + 1, resolution);
          }
        }

        // shaft
        hole(idler_bearing_inner, total_depth*2, resolution);
      }
    }

    translate([0,m5_bolt_head_thickness/2-1.5,0]) {
      rotate([90,0,0]) {
        hole(m5_nut_diam,m5_bolt_head_thickness,6);
      }
    }

    translate([0,-1,0]) {
      rotate([90,0,0]) {
        hull() {
          hole(m5_nut_diam,3,6);
          hole(m5_nut_diam+1,2,24);
        }
      }
    }
  }
}

module idler_holes() {
  idler_bolt_holes();

  vertical_gap_height = main_body_hotend_side_height + ext_shaft_opening/2 - idler_hinge_height;
  vertical_gap_z      = main_body_z-main_body_height/2+idler_hinge_height+vertical_gap_height/2;

  y_pos     = total_depth/2;
  gap_depth = total_depth+1;

  translate([idler_gap_x,y_pos,0]) {
    translate([0,0,vertical_gap_z]) {
      //cube([idler_gap_width,gap_depth,vertical_gap_height],center=true);
    }
  }

  module idler_bottom() {
    translate([idler_gap_x,0,main_body_z-main_body_height/2+idler_hinge_height + idler_gap_width/2]) {
      rotate([90,0,0]) {
        hole(idler_gap_width,1,resolution);
      }
    }
  }

  module idler_middle() {
    translate([idler_gap_x,0,ext_shaft_opening/2-idler_gap_width/2]) {
      rotate([90,0,0]) {
        hole(idler_gap_width,1,resolution);
      }
    }
  }

  module idler_top() {
    translate([filament_x+bowden_retainer_body_diam/2+idler_gap_width,0,main_body_z+main_body_height/2]) {
      cube([idler_gap_width*2,1,0.05],center=true);
    }
  }

  translate([0,total_depth/2,0]) {
    scale([1,total_depth+1,1]) {
      hull() {
        idler_bottom();
        idler_middle();
      }
    }
  }

  translate([0,total_depth/2+extrusion_height,0]) {
    scale([1,total_depth,1]) {
      hull() {
        idler_middle();
        idler_top();
      }
    }
  }


  translate([0,total_depth,0]) {
    scale([1,total_depth,1]) {
      hull() {
        idler_middle();
        idler_top();

        translate([main_body_width,0,main_body_z+main_body_height/2]) {
          cube([1,1,main_body_height],center=true);
        }
      }
    }
  }

  /*
  hull() {
    translate([idler_gap_x-idler_gap_width/2,y_pos,vertical_gap_z+vertical_gap_height/2-idler_gap_width]) {
      rotate([90,0,0]) {
        # hole(idler_gap_width*2,gap_depth,resolution);
      }
    }
    translate([idler_gap_x-idler_gap_width/2,y_pos,main_body_z+main_bo]) {
      rotate([90,0,0]) {
      }
    }

    // stuffs
    translate([idler_gap_x,total_depth/2,0]) {
      translate([0,0,idler_bearing_inner]) {
        cube([1,total_depth+1,1],center=true);
      }
      translate([0,0,main_body_z+main_body_height/2]) {
        cube([1,total_depth+1,2],center=true);
      }
    }

    translate([idler_x,total_depth/2,main_body_z+main_body_height/2+.5]) {
      cube([1,total_depth+1,1],center=true);
    }
  }
  */

}

module extruder_body_holes() {
  bearing_bevel_height = bearing_opening - ext_shaft_opening;

  // shaft hole
  hull() {
    translate([0,total_depth/2+extrusion_height,0]) {
      rotate([90,0,0]) {
        hole(ext_shaft_opening,total_depth);
      }

      translate([idler_gap_x,0,0]) {
        cube([idler_gap_width,total_depth,ext_shaft_opening],center=true);
      }
    }
  }

  // idler tensioner
  translate([main_body_x-main_body_width/2,filament_y-bowden_tubing_diam/2-2,bearing_outer/2+1.5+3/2]) {
    hull() {
      rotate([0,90,0]) {
        rotate([0,0,90]) {
          hole(3,main_body_width*3+1,6);
        }
      }
      translate([0,0,1]) {
        rotate([0,90,0]) {
          rotate([0,0,90]) {
            hole(3,main_body_width*3+1,6);
          }
        }
      }
    }
    hull() {
      rotate([0,90,0]) {
        rotate([0,0,90]) {
          hole(5.5,4,6);
        }
      }
      translate([0,0,1]) {
        rotate([0,90,0]) {
          rotate([0,0,90]) {
            hole(5.5,4,6);
          }
        }
      }
    }
  }

  // idler bearing/shaft
  idler_holes();

  translate([0,total_depth/2+extrusion_height,0]) {
    intersection() {
      translate([idler_x,0,0]) {
        rotate([90,0,0]) {
          // bearing
          hull() {
            hole(idler_bearing_outer + 2, total_depth, resolution);
          }
        }
      }

      translate([idler_gap_x - main_body_width/2,0,0]) {
        cube([main_body_width,total_depth,main_body_height],center=true);
      }
    }
  }

  // filament path
  translate([filament_x,filament_y,0]) {
    hole(filament_hole_diam,50,8);

    // Bowden tubing
    translate([0,0,-main_body_hotend_side_height]) {
      hole(bowden_tubing_diam,(main_body_hotend_side_height-ext_shaft_opening/2-4)*2);
    }
    translate([0,0,main_body_idler_side_height]) {
      hole(bowden_tubing_diam,(main_body_idler_side_height-ext_shaft_opening/2-4)*2);
    }

    // bowden clamp
    translate([0,0,main_body_z+main_body_height/2]) {
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
  }

  translate([0,gear_side_bearing_y,0]) {
    // gear-side bearing
    rotate([90,0,0]) {
      hole(bearing_outer,bearing_height,16);
    }
    // bearing opening bevel
    translate([0,-1,0]) {
      hull() {
        rotate([90,0,0]) {
          hole(bearing_outer,2,16);
        }
        rotate([90,0,0]) {
          hole(bearing_outer+extrusion_width*2,1,16);
        }
      }
    }
    // bearing bevel
    hull() {
      rotate([90,0,0]) {
        hole(bearing_opening,bearing_height);
      }
      rotate([90,0,0]) {
        hole(ext_shaft_opening,bearing_height+bearing_bevel_height + 1);
      }
    }

    % translate([0,0,0]) {
      rotate([90,0,0]) {
        bearing();
      }
    }
  }

  // carriage-side filament support bearing
  translate([0,filament_y+filament_diam/2+bearing_height*2+bearing_bevel_height/2,0]) {
    rotate([90,0,0]) {
      hole(bearing_outer,bearing_height*3);
    }

    // bearing bevel
    hull() {
      rotate([90,0,0]) {
        hole(bearing_opening,bearing_height*3);
      }
      rotate([90,0,0]) {
        hole(ext_shaft_opening,bearing_height*3+bearing_bevel_height + 1);
      }
    }
  }

  // motor holes
  position_motor() {
    translate([0,0,mount_plate_thickness/2]) {
      // motor shoulder
      cylinder(r=motor_shoulder_diam/2+1,h=mount_plate_thickness*2,center=true);

      // motor mounting holes
      for (x=[-1,1]) {
        for (y=[-1,1]) {
          translate([motor_hole_spacing/2*x,motor_hole_spacing/2*y,0]) {
            hole(m3_diam,mount_plate_thickness+1,8);
          }
        }
      }
    }
  }
}

module bridges(){
  bridge_thickness = extrusion_height;
  bridge_support_height = gear_side_bearing_y + bearing_height/2;

  // gear support bearing
  difference() {
    union() {
      translate([0,gear_side_bearing_y+bearing_height/2+bridge_thickness/2,0]) {
        cube([bearing_outer+0.5,bridge_thickness,bearing_opening+0.1],center=true);
      }

      translate([0,bridge_support_height/2,0]) {
        // gear-side bearing
        rotate([90,0,0]) {
          hole(bearing_opening-0.5,bridge_support_height);
        }
      }
    }

    translate([0,gear_side_bearing_y,0]) {
      // gear-side bearing
      rotate([90,0,0]) {
        hole(bearing_opening-5,bearing_height*2);
      }
    }
  }

  translate([idler_x,m5_bolt_head_thickness-1.5+bridge_thickness/2,0]) {
    rotate([90,0,0]) {
      hole(idler_bearing_inner+1,bridge_thickness,6);
    }
  }

  /*
  difference() {
    translate([idler_x,total_depth/2,0]) {
      rotate([90,0,0]) {
        hole(m5_nut_diam+2,total_depth,6);
      }
    }
    idler_bolt_holes();
  }
  */
}

module full_assembly() {
  assembly();

  translate([motor_x,-9,motor_z]) {
    rotate([-90,0,0]) {
      //small_gear();
    }
  }

  translate([0,-3,0]) {
    rotate([-90,0,0]) {
      rotate([180,0,0]) {
        rotate([0,0,0]) {
          //large_gear();
        }
      }
    }
  }
}

full_assembly();
mirror([0,1,0]) {
  mirror([0,0,1]) {
    //full_assembly();
  }
}

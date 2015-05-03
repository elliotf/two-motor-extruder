// Get rid of hotend mount plate recess, or make it more shallow? -- This would let the mount plate screw holes be more sturdy
// hotend recess diameter too large (somehow 16*da8 comes out more like 17; but it might be a good thing -- turns out it was a human problem)
// tricky bridge near filament broken again; need to make sure lone bridge is a multiple of filament width
// provide bridging for the carriage mount holes (going from larger to smaller diameter)
// hobbed bolt is in the filament path too much (was 0.75 into the filament, going to 0.5)

include <util.scad>
include <config.scad>
use <gears.scad>
include <positions.scad>

idler_width     = idler_bearing_height+14;
idler_thickness = idler_bearing_inner+3+1;
idler_shaft_diam = idler_bearing_inner;
idler_shaft_length = idler_width*2;
idler_x = filament_x + idler_bearing_outer/2 + filament_diam/2;

idler_screw_spacing = (idler_width - idler_bearing_height - 2);

idler_lower_half = ext_shaft_hotend_dist;
idler_upper_half = idler_screw_from_shaft+idler_screw_diam/2+3;
idler_thumb_lever_thickness = 3;
idler_thumb_lever_length = 6;

filament_y = total_depth - filament_from_carriage;
filament_y = mount_plate_thickness + idler_screw_diam/2 + idler_screw_spacing/2 + extrusion_height;

total_depth = mount_plate_thickness + motor_len/2 + 1;
total_depth = filament_y + idler_screw_spacing/2 + idler_screw_nut_diam/2 + idler_bearing_height;
total_height = motor_side + bottom_thickness;

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

module assembly() {
  translate([0,0,0]) extruder_body();

  // motor
  % position_motor() motor();

  // extruder shaft
  % translate([0,ext_shaft_length/2-15,0]) rotate([90,0,0]) rotate([0,0,22.5])
    cylinder(r=ext_shaft_diam/2,h=ext_shaft_length,center=true);

  // hobbed whatnot
  % translate([0,filament_y,0]) rotate([90,0,0]) rotate([0,0,22.5])
    cylinder(r=hobbed_diam/2+0.05,h=hobbed_width,center=true);

  // filament
  % translate([filament_x,filament_y,0]) cylinder(r=3/2,h=60,$fn=8,center=true);

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
  rounded_diam = 8;
  hull() {
    position_motor() {
      translate([0,0,mount_plate_thickness/2]) {
        for(x=[-1,1]) {
          for(y=[-1,1]) {
            translate([x*(motor_side/2-rounded_diam/2),y*(motor_side/2-rounded_diam/2),0]) {
              hole(rounded_diam,mount_plate_thickness);
            }
          }
        }
      }
    }
    // main block
    translate([main_body_x,0,main_body_z]) {
      for(x=[-1,1]) {
        for(z=[-1,1]) {
          translate([x*(main_body_width/2-rounded_diam/2),mount_plate_thickness/2,z*(main_body_height/2-rounded_diam/2)]) {
            rotate([90,0,0]) {
              hole(rounded_diam,mount_plate_thickness);
            }
          }
        }
      }
    }
  }

  // hotend retainer block
  hull() {
    translate([hotend_retainer_x,filament_y,0]) {
      translate([0,0,-ext_shaft_opening/2-1]) {
        cube([hotend_retainer_width,1,2],center=true);
      }
      translate([0,0,hotend_retainer_z]) {
        # cube([hotend_retainer_width,1,hotend_retainer_height],center=true);
      }
    }
  }
  translate([filament_x,filament_y,hotend_z-20]) {
    rotate([0,0,0]) {
      % hole(hotend_diam,40,resolution);
    }
  }

  block_depth = total_depth - mount_plate_thickness;
  // main block
  translate([main_body_x,mount_plate_thickness+block_depth/2,main_body_z]) {
    //cube([main_body_width,block_depth,main_body_height],center=true);
  }
  hull() {
    translate([main_body_x,0,main_body_z]) {
      for(x=[-1,1]) {
        for(z=[-1,1]) {
          //translate([x*(main_body_width/2-rounded_diam/2),1,z*(main_body_height/2-rounded_diam/2)]) {
          translate([x*(main_body_width/2-rounded_diam/2),total_depth/2,z*(main_body_height/2-rounded_diam/2)]) {
            rotate([90,0,0]) {
              //hole(rounded_diam,2);
              hole(rounded_diam,total_depth);
            }
          }
        }
      }
    }
  }
}

module extruder_body() {
  difference() {
    extruder_body_base();
    extruder_body_holes();
  }
  color("lightblue") bridges();
}

module idler_bearing() {
  difference() {
    cylinder(r=idler_bearing_outer/2,h=idler_bearing_height,center=true);
    cylinder(r=idler_bearing_inner/2,h=idler_bearing_height*2,center=true);
  }
}

module idler() {
  difference() {
    union() {
      translate([0,0,-idler_lower_half/2])
        cube([idler_thickness,idler_width,idler_lower_half],center=true);

      translate([0,0,idler_upper_half/2])
        cube([idler_thickness,idler_width,idler_upper_half+0.05],center=true);

      translate([idler_thickness/2-idler_thumb_lever_thickness/2,0,idler_upper_half+idler_thumb_lever_length/2])
        cube([idler_thumb_lever_thickness,idler_width,idler_thumb_lever_length+0.05],center=true);
    }

    // holes for screws
    for(side=[-1,1]) {
      translate([(idler_thickness)/2,idler_screw_spacing/2*side,idler_screw_from_shaft]) {
        hull() {
          rotate([0,-85,0]) translate([0,0,(idler_thickness)/2+1]) rotate([0,0,90])
            hole(idler_screw_diam,idler_thickness+2.05,6);
          rotate([0,-95,0]) translate([0,0,(idler_thickness)/2+1]) rotate([0,0,90])
            hole(idler_screw_diam,idler_thickness+2.05,6);
        }
      }
    }

    // hole for bearing
    cube([idler_bearing_outer,idler_bearing_height+0.5,idler_bearing_outer+2],center=true);
    translate([-idler_thickness/2,0,0]) cylinder(r=(idler_bearing_height+0.5)*da8,$fn=8,h=100,center=true);

    translate([-0.5,0,0]) {
      rotate([90,0,0]) cylinder(r=da8*(idler_shaft_diam),h=idler_shaft_length,$fn=8,center=true);
      // idler bearing
      % rotate([90,0,0]) idler_bearing();
    }
  }
}

module extruder_body_holes() {
  bearing_bevel_height = bearing_opening - ext_shaft_opening;

  // shaft hole
  translate([0,total_depth/2,0]) rotate([90,0,0]) {
    hole(ext_shaft_opening,total_depth);
  }
  translate([bearing_outer/2,motor_len/2,0]) {
    cube([bearing_outer,motor_len*2,ext_shaft_opening],center=true);
  }

  // filament path
  translate([filament_x,filament_y,0]) {
    hole(filament_diam+1,50,8);
  }

  translate([0,gear_side_bearing_y,0]) {
    // gear-side bearing
    rotate([90,0,0]) {
      hole(bearing_outer,bearing_height);
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

  // idler screw holes for idler screws
  translate([filament_x,filament_y,idler_screw_from_shaft]) {
    for (side=[-1,1]) {
      translate([0,idler_screw_spacing/2*side,0]) rotate([0,90,0])
        rotate([0,0,90]) {
          hole(idler_screw_diam,45,6);
        }
    }
  }

  // captive nut recesses for idler screws
  translate([-2.5,filament_y,idler_screw_from_shaft]) {
    for (side=[-1,1]) {
      translate([0,idler_screw_spacing/2*side,0]) rotate([0,90,0])
        hole(idler_screw_nut_diam,idler_screw_nut_thickness+spacer*1.5,6);
      translate([0,idler_screw_spacing/2*side,5])
        cube([idler_screw_nut_thickness+spacer*1.5,idler_screw_nut_diam,10],center=true);
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

    translate([0,0,-motor_len/2]) {
      //cube([motor_side+0.1,motor_side+0.1,motor_len],center=true);
    }
  }

  // filament guide retainer top recess
  translate([filament_x,filament_y,main_body_z+main_body_height/2])
    hole(6.25,15,8);
}

module bridges(){
  bridge_thickness = extrusion_height;

  // gear support bearing
  translate([main_body_x,gear_side_bearing_y+bearing_height/2+bridge_thickness/2,0]) {
    cube([main_body_width,bridge_thickness,bearing_opening+0.1],center=true);
  }

  translate([0,gear_side_bearing_y,0]) {
    // gear-side bearing
    rotate([90,0,0]) {
      hole(bearing_opening-0.5,bearing_height);
    }
  }

  // hobbed support bearing bridge
  translate([main_body_x,filament_y-hobbed_width/2+bridge_thickness/2,0]) {
    //cube([main_body_width,bridge_thickness,ext_shaft_opening+0.1],center=true);
  }
}

module full_assembly() {
  assembly();

  translate([motor_x,-9,motor_z]) {
    rotate([-90,0,0]) small_gear();
  }

  translate([0,-3,0]) {
    //rotate([-90,0,0]) rotate([180,0,0]) rotate([0,0,0]) large_gear();
  }
}

full_assembly();
mirror([0,1,0]) {
  mirror([0,0,1]) {
    //full_assembly();
  }
}

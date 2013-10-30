da6 = 1 / cos(180 / 6) / 2;
da8 = 1 / cos(180 / 8) / 2;

// motor mount plate too thin for 8mm screws (thickness is 3, looks to be short by <1mm)
// Get rid of hotend mount plate recess, or make it more shallow? -- This would let the mount plate screw holes be more sturdy
// hotend recess diameter too large (somehow 16*da8 comes out more like 17; but it might be a good thing -- turns out it was a human problem)
// tricky bridge near filament broken again; need to make sure lone bridge is a multiple of filament width
// provide bridging for the carriage mount holes (going from larger to smaller diameter)
// hobbed bolt is in the filament path too much (was 0.75 into the filament, going to 0.5)

include <util.scad>
include <config.scad>
include <gears.scad>
include <positions.scad>
//include <inc/nema.scad>

extrusion_width = 0.6;
extrusion_height = 0.3;

// 626
bearing_height = 6;
bearing_outer  = 19;
bearing_inner  = 6;

// 608
bearing_height = 7;
bearing_outer  = 22;
bearing_inner  = 8;

// 625
bearing_height = 5;
bearing_outer  = 16;
bearing_inner  = 5;

filament_diam = 3;

ext_shaft_length  = 60;
ext_shaft_diam    = 6; // m6 bolt
ext_shaft_diam    = 8; // m8 bolt
ext_shaft_diam    = 5; // m5 threaded rod
hobbed_diam = 8;
hobbed_height = 7;
ext_shaft_opening = hobbed_diam + 1;

carriage_hole_spacing = 30;
carriage_hole_small_diam    = m3_diam;
carriage_hole_large_diam    = 6;
carriage_hole_support_thickness = 8;

hotend_length = 63;
hotend_diam   = 16;
hotend_mount_hole_depth = 5;
hotend_mount_screw_hole_spacing = 24;
hotend_mount_screw_diam = 4;
hotend_mount_screw_nut = 7.3;
hotend_mount_length = 37.5*2;
hotend_mount_width = 28;
hotend_mount_height = 0;

filament_from_carriage = hotend_diam / 2 + 8; // make sure the hotend can clear the carriage
filament_x = hobbed_diam/2 + filament_diam/2 - .6;

mount_plate_thickness = 3;
bottom_thickness = m3_socket_head_diam + min_material_thickness;
body_bottom_pos = -motor_side/2-bottom_thickness;
total_depth = mount_plate_thickness + motor_len + 1;
total_width = motor_side + motor_side*1.4;
total_width = motor_side/2 + gear_dist + hotend_mount_screw_hole_spacing + filament_x + hotend_mount_screw_nut/2 + min_material_thickness;
total_height = motor_side + bottom_thickness;

filament_y = total_depth - filament_from_carriage;

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
  //gear_assembly();
  translate([0,0,0]) extruder_body();

  // motor
  % translate([-gear_dist,mount_plate_thickness,0]) rotate([90,0,0]) motor();

  // extruder shaft
  % translate([0,ext_shaft_length/2-15,0]) rotate([90,0,0]) rotate([0,0,22.5])
    cylinder(r=ext_shaft_diam/2,h=ext_shaft_length,center=true);

  // hobbed whatnot
  % translate([0,filament_y,0]) rotate([90,0,0]) rotate([0,0,22.5])
    cylinder(r=hobbed_diam/2+0.05,h=hobbed_height,center=true);

  // filament
  % translate([filament_x,filament_y,0]) cylinder(r=3/2,h=60,$fn=8,center=true);

  // hotend
  //% translate([filament_x,filament_y,body_bottom_pos-hotend_length/2+hotend_mount_hole_depth]) cylinder(r=hotend_diam/2,h=hotend_length,center=true);

  //translate([idler_crevice_x,filament_y,idler_crevice_z - idler_crevice_depth/2 + idler_length/2]) {
  translate([idler_crevice_x,filament_y,0.05]) {
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

// 608
idler_bearing_height = 7;
idler_bearing_outer  = 22;
idler_bearing_inner  = 8;

//626
idler_bearing_height = 6;
idler_bearing_outer  = 19;
idler_bearing_inner  = 6;

//625
idler_bearing_height = bearing_height;
idler_bearing_outer  = bearing_outer;
idler_bearing_inner  = bearing_inner;

idler_width     = idler_bearing_height+14;
idler_thickness = idler_bearing_inner+3+1;
idler_shaft_diam = idler_bearing_inner;
idler_shaft_length = idler_width*2;
idler_x = filament_x + idler_bearing_outer/2 + filament_diam/2;

// m3
idler_screw_diam = 3.2;
idler_screw_nut_diam = 5.7;

// 4-40
idler_screw_diam = 3.2;
idler_screw_nut_diam = 6.8;

idler_screw_spacing = (idler_width - idler_bearing_height - 2);
idler_screw_from_shaft = 13;
idler_screw_from_shaft = bearing_outer/2+idler_screw_nut_diam/2+2;

idler_crevice_width = idler_thickness + .5;
idler_crevice_length = total_depth - (filament_y - idler_width/2) + 2;
idler_crevice_depth = 5;
idler_crevice_x = idler_x - 0.5;
idler_crevice_y = total_depth - idler_crevice_length / 2 + 0.5;
idler_crevice_z = body_bottom_pos + bottom_thickness + idler_crevice_depth/2 + 2.75;

idler_length    = idler_bearing_outer+16;
idler_length    = motor_side - 2.75;
idler_length    = -1*(idler_crevice_z - idler_crevice_depth/2 - motor_side/2);
idler_lower_half = -1*(idler_crevice_z - idler_crevice_depth/2);
idler_upper_half = idler_screw_from_shaft+idler_screw_diam/2+3;
idler_thumb_lever_thickness = 3;
idler_thumb_lever_length = 6;

module extruder_body_base() {
  // motor plate
  motor_plate_width = gear_dist+motor_side/2;
  //translate([-motor_side*0.3,mount_plate_thickness/2,0])
  translate([-motor_plate_width/2,mount_plate_thickness/2,0])
    cube([motor_plate_width,mount_plate_thickness,motor_side],center=true);

  // main block
  /*
  translate([motor_side*0.2,total_depth/2+mount_plate_thickness/2,0])
    cube([motor_side*1.4,total_depth-mount_plate_thickness,motor_side],center=true);
    */
  bearing_block_width = bearing_outer+3;
  translate([-spacer,total_depth/2,0])
    cube([bearing_block_width,total_depth,motor_side],center=true);

  // base thickness

  // bottom
  translate([-gear_dist-motor_side/2+total_width/2,total_depth/2,body_bottom_pos+bottom_thickness/2])
    cube([total_width,total_depth,bottom_thickness],center=true);
}

module extruder_body() {
  difference() {
    extruder_body_base();
    extruder_body_holes();
  }
  bridges();
}

module idler_bearing() {
  difference() {
    cylinder(r=idler_bearing_outer/2,h=idler_bearing_height,center=true);
    cylinder(r=idler_bearing_inner/2,h=idler_bearing_height*2,center=true);
  }
}

module idler() {
  difference() {
    //translate([0,0,0]) cube([idler_thickness,idler_width,idler_length],center=true);
    union() {
      translate([0,0,-idler_lower_half/2]) cube([idler_thickness,idler_width,idler_lower_half],center=true);
      translate([0,0,idler_upper_half/2]) cube([idler_thickness,idler_width,idler_upper_half+0.05],center=true);
      translate([idler_thickness/2-idler_thumb_lever_thickness/2,0,idler_upper_half+idler_thumb_lever_length/2])
        cube([idler_thumb_lever_thickness,idler_width,idler_thumb_lever_length+0.05],center=true);
    }

    // holes for screws
    for(side=[-1,1]) {
      translate([(idler_thickness)/2,idler_screw_spacing/2*side,idler_screw_from_shaft]) {
        hull() {
          rotate([0,-85,0]) translate([0,0,(idler_thickness)/2+1]) rotate([0,0,90])
            cylinder(r=idler_screw_diam*da6,h=idler_thickness+2.05,center=true);
          rotate([0,-95,0]) translate([0,0,(idler_thickness)/2+1]) rotate([0,0,90])
            cylinder(r=idler_screw_diam*da6,h=idler_thickness+2.05,center=true);
        }
      }
    }

    // hole for bearing
    cube([idler_bearing_outer,idler_bearing_height+0.5,idler_bearing_outer+2],center=true);
    translate([-idler_thickness/2,0,0]) rotate([0,0,22.5]) cylinder(r=(idler_bearing_height+0.5)*da8,$fn=8,h=idler_length*2,center=true);

    translate([-0.5,0,0]) {
      rotate([90,0,0]) rotate([0,0,22.5]) cylinder(r=da8*(idler_shaft_diam),h=idler_shaft_length,$fn=8,center=true);
      // idler bearing
      % rotate([90,0,0]) idler_bearing();
    }
  }
}

module extruder_body_holes() {
  // shaft hole
  translate([0,0,0]) rotate([90,0,0]) cylinder(r=ext_shaft_opening/2,h=100,$fn=36,center=true);
  translate([bearing_outer/2,motor_len/2,0]) cube([bearing_outer,motor_len*2,ext_shaft_opening],center=true);

  // filament path
  translate([filament_x,filament_y,0]) rotate([0,0,22.5]) cylinder(r=da8*(filament_diam*1.25),$fn=8,h=50,center=true);

  translate([0,gear_side_bearing_y,0]) {
    // gear-side bearing
    rotate([90,0,0]) cylinder(r=bearing_outer/2+0.1,h=bearing_height,center=true);

    % translate([0,0,0]) rotate([90,0,0]) bearing();
  }

  // hobbed area opening
  /*
  */
  hobbed_opening_len = 10;
  translate([0,filament_y-hobbed_height/2-hobbed_opening_len/2,0]) {
    rotate([90,0,0])
      hole(bearing_outer,hobbed_opening_len);
    translate([accurate_diam(bearing_outer)/2,0,0])
      cube([accurate_diam(bearing_outer),hobbed_opening_len,accurate_diam(bearing_outer)],center=true);
  }

  // gear-side filament support bearing
  /*
  translate([0,filament_y-bearing_height*1.75-1,0]) {
    rotate([90,0,0])
      cylinder(r=bearing_outer/2+0.1,h=bearing_height*2.5,center=true);

    translate([bearing_outer*.25,0,0])
      cube([bearing_outer/2+0.1,bearing_height*2.5,bearing_outer+0.2],center=true);

    % rotate([90,0,0]) bearing();
  }
  */

  // idler bearing access
  translate([bearing_outer/2+hobbed_diam/2+filament_x-4,total_depth/2,0]) rotate([90,0,0]) rotate([0,0,22.5])
    cylinder(r=bearing_outer/2+filament_diam*.8,h=total_depth+1,$fn=8,center=true);

  // carriage-side filament support bearing
  translate([0,filament_y+bearing_height*2+1,0]) rotate([90,0,0])
    cylinder(r=bearing_outer/2+0.1,h=bearing_height*3,center=true);
  //% translate([0,filament_y+bearing_height+1.2,0]) rotate([90,0,0]) bearing();

  // idler crevice
  /*
  translate([idler_crevice_x,idler_crevice_y,idler_crevice_z+idler_crevice_depth/2])
    cube([idler_crevice_width,idler_crevice_length,idler_crevice_depth*2],center=true);
    */

  // idler screw holes for idler screws
  translate([filament_x,filament_y,idler_screw_from_shaft]) {
    for (side=[-1,1]) {
      translate([0,idler_screw_spacing/2*side,0]) rotate([0,90,0]) cylinder(r=idler_screw_diam*da6,h=45,$fn=6,center=true);
    }
  }

  // captive nut recesses for idler screws
  translate([-2.5,filament_y,idler_screw_from_shaft]) {
    for (side=[-1,1]) {
      translate([0,idler_screw_spacing/2*side,0]) rotate([0,90,0]) cylinder(r=idler_screw_nut_diam*da6,h=4,$fn=6,center=true);
      translate([0,idler_screw_spacing/2*side,0]) rotate([0,90,0]) cylinder(r=idler_screw_nut_diam*da6,h=4,$fn=6,center=true);
      translate([0,idler_screw_spacing/2*side,5]) cube([4,idler_screw_nut_diam,10],center=true);
    }
  }

  // motor holes
  translate([-gear_dist,mount_plate_thickness/2,0]) rotate([90,0,0]){
    // motor shoulder
    cylinder(r=motor_shoulder_diam/2+1,h=mount_plate_thickness*2,center=true);

    // motor mounting holes
    for (x=[-1,1]) {
      for (y=[-1,1]) {
        translate([motor_hole_spacing/2*x,motor_hole_spacing/2*y,0])
          cylinder(r=m3_diam*da6,h=mount_plate_thickness+1,$fn=16,center=true);
      }
    }
  }

  // hotend
  translate([filament_x,filament_y,body_bottom_pos]) {
    // hotend mount hole
    translate([0,0,hotend_mount_height]) rotate([0,0,22.5]) cylinder(r=da8*hotend_diam+0.05,h=hotend_mount_hole_depth*2,$fn=8,center=true);

    // plate is not symmetric, skew to one side
    translate([-1.5,0,0]) {
      // hotend plate recess
      cube([hotend_mount_length,hotend_mount_width,hotend_mount_height*2],center=true);

      // hotend plate screw holes
      for (side=[-1,1]) {
        translate([side*hotend_mount_screw_hole_spacing,0,0]) {
          // screw holes
          cylinder(r=hotend_mount_screw_diam*da6+0.05,$fn=6,h=total_height,center=true);
          % cylinder(r=hotend_mount_screw_diam/2,$fn=72,h=10,center=true);

          // captive nut recesses for hotend mounting plate
          translate([0,0,bottom_thickness+49]) cylinder(r=hotend_mount_screw_nut*da6,$fn=6,h=6.4+100,center=true);
        }
      }
    }
  }

  // filament guide top recess
  translate([filament_x,filament_y,motor_side/2]) rotate([0,0,22.5])
    cylinder(r=6.25/2,$fn=8,h=10,center=true);

  // carriage mounting holes
  translate([filament_x,total_depth/2,body_bottom_pos+bottom_thickness/2]) {
    for (side=[-1,1]) {
      translate([side*carriage_hole_spacing/2,-carriage_hole_support_thickness,0]) rotate([90,0,0]) rotate([0,0,22.5])
        hole(carriage_hole_large_diam,total_depth);

      translate([side*carriage_hole_spacing/2,total_depth/2,0]) rotate([90,0,0])
        hole(carriage_hole_small_diam,total_depth);
    }
  }
}

module bridges(){
  bridge_thickness = extrusion_height;

  // gear support bearing
  translate([0,gear_side_bearing_y+bearing_height/2+bridge_thickness/2,0])
    cube([bearing_outer-2,bridge_thickness,bearing_outer+1],center=true);

  // hobbed support bearing bridge
  translate([0,filament_y-hobbed_height/2+bridge_thickness/2,0]) {
    cube([bearing_outer-2,bridge_thickness,bearing_outer+2],center=true);
  }

  // carriage mounting hole diameter drop
  translate([filament_x,total_depth-carriage_hole_support_thickness,body_bottom_pos+bottom_thickness/2]) {
    for (side=[-1,1]) {
      //translate([side*carriage_hole_spacing/2,carriage_hole_support_thickness,0])
      translate([side*carriage_hole_spacing/2,0,0])
        # cube([carriage_hole_large_diam+0.5,bridge_thickness,carriage_hole_large_diam+0.5],center=true);
    }
  }
}

module full_assembly() {
  assembly();

  translate([-gear_dist,-3.5,0]) {
    rotate([90,0,0]) small_gear();
  }

  translate([0,-10,0]) {
    rotate([-90,0,0]) large_gear();
  }
}

//rotate([90,0,0]) assembly();
//rotate([0,90,0]) idler();
//full_assembly();
assembly();
//idler();

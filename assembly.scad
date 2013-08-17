da6 = 1 / cos(180 / 6) / 2;
da8 = 1 / cos(180 / 8) / 2;

include <gears.scad>
include <inc/nema.scad>

// 626
bearing_height = 6;
bearing_outer  = 19;
bearing_inner  = 6;

// 625
bearing_height = 5;
bearing_outer  = 16;
bearing_inner  = 5;

ext_shaft_length  = 60;
ext_shaft_diam    = 6; // m6 bolt
ext_shaft_diam    = 5; // m5 threaded rod
ext_shaft_opening = bearing_outer - 3;
ext_shaft_opening = ext_shaft_diam + 3;

carriage_hole_spacing = 30;

motor_screw_spacing = 26;

hotend_length = 63;
hotend_diam   = 16;
hotend_mount_hole_depth = 5;
hotend_mount_screw_hole_spacing = 24;
hotend_mount_screw_diam = 4;
hotend_mount_length = 37.5*2;
hotend_mount_width = 28;
hotend_mount_height = 0.75;

mount_plate_thickness = 3;
bottom_thickness = 7;
body_bottom_pos = -motor_side/2-bottom_thickness;
total_depth = mount_plate_thickness + motor_height;
total_width = motor_side + motor_side*1.4;
total_height = motor_side + bottom_thickness;

filament_from_carriage = hotend_diam / 2 + 6;
filament_x = ext_shaft_diam/2 + 3/2 - .75;
filament_y = total_depth - filament_from_carriage;

module assembly() {
  gear_assembly();
  translate([0,0,0]) extruder_body();

  % translate([-gear_dist,21.25,0]) rotate([90,0,0]) nema14();
  % translate([0,ext_shaft_length/2-15,0]) rotate([90,0,0]) rotate([0,0,22.5]) cylinder(r=ext_shaft_diam/2,h=ext_shaft_length,$fn=8,center=true);

  // gear support
  % translate([0,bearing_height/2,0]) rotate([90,0,0]) bearing();

  // filament
  % translate([filament_x,filament_y,0]) cylinder(r=3/2,h=60,$fn=6,center=true);

  // hotend
  % translate([filament_x,filament_y,body_bottom_pos-hotend_length/2+hotend_mount_hole_depth])
    cylinder(r=hotend_diam/2,h=hotend_length,center=true);

  // hotend mount plate
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

module extruder_body() {
  difference() {
    extruder_body_base();
    extruder_body_holes();
  }
  extruder_bridges();
}

module extruder_body_base() {
  // motor plate
  translate([-motor_side*0.3,mount_plate_thickness/2,0])
    cube([total_width,mount_plate_thickness,motor_side],center=true);

  // main block
  translate([motor_side*0.2,motor_height/2+mount_plate_thickness,0])
    cube([motor_side*1.4,motor_height,motor_side],center=true);

  // bottom
  translate([-motor_side*0.3,total_depth/2,body_bottom_pos+bottom_thickness/2])
    cube([total_width,total_depth,bottom_thickness],center=true);
}

// 608zz
idler_bearing_height = 7;
idler_bearing_outer  = 22;
idler_bearing_inner  = 8;

//626zz
idler_bearing_height = 6;
idler_bearing_outer  = 19;
idler_bearing_inner  = 6;

//625zz
idler_bearing_height = bearing_height;
idler_bearing_outer  = bearing_outer;
idler_bearing_inner  = bearing_inner;

idler_width     = idler_bearing_height+12;
idler_thickness = idler_bearing_inner+3+1;
idler_length    = idler_bearing_outer+20;
idler_shaft_diam = idler_bearing_inner;
idler_shaft_length = idler_width*2;
idler_x = filament_x + idler_bearing_outer/2 + 2.15;

idler_crevice_width = idler_thickness + 0.5;
idler_crevice_length = total_depth - (filament_y - idler_width/2) + .25;
idler_crevice_x = idler_x - 0.25;
idler_crevice_y = total_depth - idler_crevice_length / 2;

module idler() {
  difference() {
    translate([1,0,0]) cube([idler_thickness,idler_width,idler_length],center=true);
    rotate([90,0,0]) rotate([0,0,22.5]) cylinder(r=da8*(idler_shaft_diam),h=idler_shaft_length,$fn=8,center=true);
    //translate([-idler_thickness/2,0,0]) cube([idler_thickness,idler_shaft_length,idler_shaft_diam],center=true);

    // hole for bearing
    cube([idler_bearing_outer,idler_bearing_height+1,idler_bearing_outer+2],center=true);
  }
}

module idler_bearing() {
  difference() {
    cylinder(r=idler_bearing_outer/2,h=idler_bearing_height,center=true);
    cylinder(r=idler_bearing_inner/2,h=idler_bearing_height*2,center=true);
  }
}

translate([filament_x + bearing_outer/2 + 1.15,filament_y,0]) {
  idler();
}

module extruder_body_holes() {
  // shaft hole
  translate([0,0,0]) rotate([90,0,0]) cylinder(r=ext_shaft_opening/2,h=100,$fn=36,center=true);
  translate([bearing_outer/2,motor_height/2,0]) cube([bearing_outer,motor_height*2,ext_shaft_opening],center=true);

  // large opening
  translate([motor_side/2+bearing_outer/2-1,motor_height/2,motor_side/2-ext_shaft_opening-2])
    cube([motor_side,motor_height*2,motor_side],center=true);

  // filament path
  translate([filament_x,filament_y,0]) rotate([0,0,22.5]) cylinder(r=4/2,$fn=8,h=50,center=true);

  // gear-side bearing
  translate([0,bearing_height/2-0.05,0]) rotate([90,0,0]) bearing();

  // gear-side filament support bearing
  translate([0,filament_y-bearing_height-1.125,0]) rotate([90,0,0]) cylinder(r=bearing_outer/2,h=bearing_height+0.25,center=true);
  translate([bearing_outer*.25,filament_y-bearing_height-1.125,0]) cube([bearing_outer/2,bearing_height+0.25,bearing_outer],center=true);

  // filament support bearings -- TODO: leave more room for a hobbed spacer/gear/etc?
  //% translate([0,filament_y+bearing_height+1,0]) rotate([90,0,0]) bearing();
  //% translate([0,filament_y-bearing_height-1,0]) rotate([90,0,0]) bearing();

  // idler bearing access
  translate([bearing_outer/2+2+ext_shaft_diam/2,filament_y+bearing_height-1.25,0]) rotate([90,0,0])
    cylinder(r=bearing_outer/2+1,h=bearing_height*5,$fn=36,center=true);

  // carriage-side filament support bearing
  translate([0,filament_y+bearing_height*2+1,0]) rotate([90,0,0]) cylinder(r=bearing_outer/2,h=bearing_height*3,center=true);

  // idler crevice
  translate([idler_crevice_x,idler_crevice_y,body_bottom_pos+bottom_thickness+7])
    cube([idler_crevice_width,idler_crevice_length,10],center=true);

  // idler
  translate([filament_x + idler_bearing_outer/2 + 1.15,filament_y,0]) {

    // idler bearing
    % rotate([90,0,0]) idler_bearing();

    // total_depth - (filament_y - idler_width)

    // idler crevice
    //translate([0,0,body_bottom_pos+bottom_thickness+5]) cube([idler_thickness,idler_crevice_length,10],center=true);
  }

  // motor
  translate([-gear_dist,mount_plate_thickness/2,0]) rotate([90,0,0]){
    // motor shoulder
    cylinder(r=motor_shoulder_diam/2+1,h=mount_plate_thickness*2,center=true);
    
    // motor mounting holes
    for (x=[-1,1]) {
      for (y=[-1,1]) {
        translate([motor_screw_spacing/2*x,motor_screw_spacing/2*y,0]) cylinder(r=3.1/2,h=mount_plate_thickness*2,$fn=36,center=true);
      }
    }
  }


  // hotend
  translate([filament_x,filament_y,body_bottom_pos]) {
    // hotend mount hole
    translate([0,0,hotend_mount_height]) rotate([0,0,22.5]) cylinder(r=da8*hotend_diam+0.5,h=hotend_mount_hole_depth*2,$fn=8,center=true);

    // plate is not symmetric, skew to one side
    translate([-1.5,0,0]) {
      // hotend plate recess
      cube([hotend_mount_length,hotend_mount_width,hotend_mount_height*2],center=true);

      // hotend plate screw holes
      for (side=[-1,1]) {
        translate([side*hotend_mount_screw_hole_spacing,0,0]) {
          // screw holes
          cylinder(r=hotend_mount_screw_diam/2+0.05,$fn=72,h=total_height,center=true);
          % cylinder(r=hotend_mount_screw_diam/2,$fn=72,h=10,center=true);

          // captive nuts
          translate([0,0,bottom_thickness+50]) cylinder(r=7*da6,$fn=6,h=6.4+100,center=true);
        }
      }
    }
  }

  // filament guide top recess
  translate([filament_x,filament_y,motor_side/2]) rotate([0,0,22.5]) cylinder(r=6.5/2,$fn=8,h=10,center=true);

  // carriage mounting holes
  translate([filament_x,total_depth/2,body_bottom_pos+6/2+1.5]) {
    for (side=[-1,1]) {
      translate([side*carriage_hole_spacing/2,-8,0]) rotate([90,0,0])
        cylinder(r=6/2,$fn=72,h=total_depth,center=true);

      translate([side*carriage_hole_spacing/2,total_depth/2,0]) rotate([90,0,0])
        cylinder(r=3/2,$fn=72,h=total_depth,center=true);
    }
  }
}

module extruder_bridges(){
  // gear support bearing
  translate([-0.5*(bearing_outer-bearing_outer)-1,0.1+bearing_height,0]) cube([bearing_outer,0.3,bearing_outer],center=true);

  // hobbed support bearing
  translate([-0.5*(bearing_outer-bearing_outer)-1,filament_y-bearing_height/2-1,0]) cube([bearing_outer,0.3,bearing_outer],center=true);
}

assembly();

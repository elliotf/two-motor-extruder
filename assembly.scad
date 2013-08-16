da6 = 1 / cos(180 / 6) / 2;

// Copyright 2011 Cliff L. Biffle.
// This file is licensed Creative Commons Attribution-ShareAlike 3.0.
// http://creativecommons.org/licenses/by-sa/3.0/

// You can get this file from http://www.thingiverse.com/thing:3575
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

carriage_hole_spacing = 30;

hotend_length = 63;
hotend_diam   = 16;
hotend_mount_hole_depth = 5;
hotend_mount_screw_hole_spacing = 24;
hotend_mount_depth = 0.75;


mount_plate_thickness = 3;
bottom_thickness = 5;
body_bottom_pos = -motor_side/2-bottom_thickness;
total_depth = mount_plate_thickness + motor_height;
total_width = motor_side + motor_side*1.4;
total_height = motor_side + bottom_thickness;

filament_from_carriage = hotend_diam / 2 + 6;
filament_y = total_depth - filament_from_carriage;
filament_x = ext_shaft_diam/2 + .75;

module assembly() {
  gear_assembly();
  translate([0,0,0]) extruder_body();

  % translate([-gear_dist,21.25,0]) rotate([90,0,0]) nema14();
  % translate([0,ext_shaft_length/2-15,0]) rotate([90,0,0]) rotate([0,0,22.5]) cylinder(r=6/2,h=ext_shaft_length,$fn=8,center=true);

  // gear support
  % translate([0,bearing_height/2,0]) rotate([90,0,0]) bearing();

  // filament support bearings -- TODO: leave more room for a hobbed spacer/gear/etc?
  % translate([0,filament_y+bearing_height+1,0]) rotate([90,0,0]) bearing();
  % translate([0,filament_y-bearing_height-1,0]) rotate([90,0,0]) bearing();

  // idler bearing
  % translate([filament_x + bearing_outer/2 + 1.5,filament_y,0]) rotate([90,0,0]) bearing();

  // filament
  % translate([filament_x,filament_y,0]) cylinder(r=3/2,h=60,center=true);

  // hotend
  % translate([filament_x,filament_y,body_bottom_pos-hotend_length/2]) cylinder(r=hotend_diam/2,h=hotend_length,center=true);

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

module extruder_body_holes() {
  // shaft hole
  translate([0,0,0]) rotate([90,0,0]) cylinder(r=ext_shaft_opening/2,h=100,$fn=36,center=true);
  translate([bearing_outer/2,motor_height/2,0]) cube([bearing_outer,motor_height*2,ext_shaft_opening],center=true);

  // large opening
  translate([motor_side/2+ext_shaft_opening/2,motor_height/2,motor_side/2-ext_shaft_opening/2])
    cube([motor_side,motor_height*2,motor_side],center=true);

  // filament path
  translate([filament_x,filament_y,0]) rotate([0,0,22.5]) cylinder(r=4/2,$fn=8,h=50,center=true);

  // gear-side bearing
  translate([0,bearing_height/2-0.05,0]) rotate([90,0,0]) bearing();

  // carriage-side filament support bearing
  translate([0,filament_y+bearing_height*2+1,0]) rotate([90,0,0]) cylinder(r=bearing_outer/2,h=bearing_height*3,center=true);

  // gear-side filament support bearing
  translate([0,filament_y-bearing_height-1.125,0]) rotate([90,0,0]) cylinder(r=bearing_outer/2,h=bearing_height+0.25,center=true);
  translate([bearing_outer*.25,filament_y-bearing_height-1.125,0]) cube([bearing_outer/2,bearing_height+0.25,bearing_outer],center=true);

  // idler bearing access
  translate([bearing_outer/2+2+ext_shaft_diam/2,filament_y+bearing_height-1.25,0]) rotate([90,0,0])
    cylinder(r=bearing_outer/2+1,h=bearing_height*5,$fn=36,center=true);

  // idler holder brace
  % translate([bearing_outer/2+2+ext_shaft_diam/2,filament_y,0])
    cube([bearing_inner+2,bearing_height+10,bearing_outer+10],center=true);

  // motor shoulder
  translate([-gear_dist,0,0]) rotate([90,0,0]) cylinder(r=motor_shoulder_diam/2+1,h=mount_plate_thickness*2.1,center=true);

  translate([filament_x,filament_y,body_bottom_pos]) {
    // hotend mount hole
    translate([0,0,hotend_mount_depth]) cylinder(r=hotend_diam/2,h=hotend_mount_hole_depth*2,center=true);
    // hotend plate recess
    translate([0,0,0]) cube([hotend_mount_screw_hole_spacing+13.5*2,28+1,hotend_mount_depth*2],center=true);
    // hotend plate screw holes
    for (side=[-1,1]) {
      translate([side*hotend_mount_screw_hole_spacing/2,0,0])
        cylinder(r=3.2/2,$fn=72,h=total_height,center=true);
    }
  }

  // filament guide holder
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
  translate([-0.5*(bearing_outer-ext_shaft_opening),0.1+bearing_height,0]) cube([bearing_outer,0.3,bearing_outer],center=true);

  // hobbed support bearing
  translate([-0.5*(bearing_outer-ext_shaft_opening),filament_y-bearing_height/2-1,0]) cube([bearing_outer,0.3,bearing_outer],center=true);
}

assembly();

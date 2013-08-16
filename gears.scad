da6 = 1 / cos(180 / 6) / 2;

// Copyright 2011 Cliff L. Biffle.
// This file is licensed Creative Commons Attribution-ShareAlike 3.0.
// http://creativecommons.org/licenses/by-sa/3.0/

// You can get this file from http://www.thingiverse.com/thing:3575
use <inc/parametric_involute_gear_v5.0.scad>
use <inc/nema.scad>
use <inc/spur_generator.scad>

// Here's an example.
large_tooth_num = 43;
small_tooth_num = 9;
gear_dist = 35;
// printed 51 and 9
// 7 and 41
// 9 and 41
// 11 and 49
gear_pitch = fit_spur_gears(large_tooth_num, small_tooth_num, gear_dist);

small_tooth_height = 7;
small_gear_height  = 15;

module large_gear() {
  difference() {
    // Simple Test:
    gear (circular_pitch=gear_pitch,
      //gear_thickness = 12,
      gear_thickness = 3.5,
      //rim_thickness = 15,
      rim_thickness = 5.5,
      rim_width = 1,
      //hub_thickness = 17,
      hub_thickness = 10,
      hub_diameter = 15,
      number_of_teeth = large_tooth_num,
      circles=4,
      bore_diameter = 0);
    cylinder(r=6/2,$fn=36,h=50,center=true);
    translate([0,0,10]) {
      cylinder(r=da6*10,h=10,center=true,$fn=6); // nut trap for m6 nut
    }
  }
}

module small_gear() {
  difference() {
    gear (circular_pitch=gear_pitch,
      gear_thickness = small_tooth_height,
      rim_thickness = small_tooth_height,
      hub_thickness = small_gear_height,
      circles=0,
      number_of_teeth = small_tooth_num,
      rim_width = 2,
      bore_diameter = 0,
      hub_diameter = 15);

    // flatted motor hole
    difference() {
      cylinder(r=5.1/2,$fn=36,h=90,center=true);
      translate([4.6,0,0]) cube([5,5,100],center=true);
    }

    // m3 set screw
    // m3 nut == 5.5mm * 3mm
    translate([3.05,0,small_gear_height-3.5]) {
      rotate([0,90,0]) cylinder(r=5.5*da6,h=3,$fn=6,center=true);
      translate([0,0,2.1]) cube([3,5.5,3],center=true);
      rotate([90,0,0]) rotate([0,90,0]) cylinder(r=3*da6,h=9,$fn=6,center=true);
    }
  }
}

// You can get this file from http://www.thingiverse.com/thing:3575
use <../scad/main.scad>

translate([-10,0,0]) rotate([90,0,0]) extruder_body();

translate([30,-10,4.5]) rotate([0,90,0]) idler();

% cube([150,150,1],center=true);

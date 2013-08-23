// You can get this file from http://www.thingiverse.com/thing:3575
use <../gears.scad>

module plate() {
  large_gear();

  translate([50,0,17]) {
    rotate([180,0,0]) small_gear();
  }
}

plate();

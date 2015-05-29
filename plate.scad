include <main.scad>;

show_drive_side = 1;
show_idler_side = 1;
show_bridges    = 1;
show_motors     = 0;

module plate() {
  min_dist_between_parts = 5;
  translate([-motor_side/2-min_dist_between_parts,0,0]) {
    rotate([0,0,90]) {
      rotate([0,90,0]) {
        drive_side();
      }
    }
  }
  translate([motor_side/2+min_dist_between_parts,0,0]) {
    rotate([0,0,-90]) {
      rotate([0,-90,0]) {
        idler_side();
      }
    }
  }
}

plate();

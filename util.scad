include <config.scad>;

function accurate_diam(diam,sides=16) = 1 / cos(180 / sides) * diam;

module accurate_circle(diam,sides) {
  diam = accurate_diam(diam,sides);

  rotate([0,0,180/sides]) {
    circle(r=diam/2,$fn=sides);
  }
}

module hole(diam,height,sides=32) {
  diam = accurate_diam(diam,sides);

  rotate([0,0,180/sides]) {
    cylinder(r=diam/2,h=height,center=true,$fn=sides);
  }
}

module motor() {
  module body() {
    cube([motor_side,motor_side,motor_len],center=true);

    // shaft
    translate([0,0,motor_len/2+motor_shaft_len/2+motor_shoulder_height])
      cylinder(r=5/2,h=motor_shaft_len,center=true);

    // shoulder
    translate([0,0,motor_len/2+motor_shoulder_height/2]) {
      cylinder(r=motor_shoulder_diam/2,h=motor_shoulder_height,center=true); // shoulder
    }

    // short shaft
    translate([0,0,-motor_len/2-motor_short_shaft_len/2]) {
      cylinder(r=5/2,h=motor_short_shaft_len,center=true);
    }
  }

  module holes() {
    for(x=[left,right]) {
      for(y=[front,rear]) {
        translate([motor_hole_spacing/2*x,motor_hole_spacing/2*y,0]) {
          hole(m3_diam,motor_len+1,8);
        }
      }
    }
  }

  translate([0,0,-motor_len/2]) {
    difference() {
      intersection() {
        body();
        hole(motor_diam,motor_len*2,32);
      }
      holes();
    }
  }
}

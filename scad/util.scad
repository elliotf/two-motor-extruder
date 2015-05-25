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

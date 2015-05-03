function accurate_diam(diam,sides=16) = 1 / cos(180 / sides) * diam;

module hole(diam,height,sides=32) {
  diam = accurate_diam(diam,sides);

  rotate([0,0,180/sides]) {
    cylinder(r=diam/2,h=height,center=true,$fn=sides);
  }
}

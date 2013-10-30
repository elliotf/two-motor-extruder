function accurate_diam(diam,sides=16) = 1 / cos(180 / sides) * diam;

module hole(diam,height,sides=16) {
  diam = accurate_diam(diam,sides);

  cylinder(r=diam/2,h=height,center=true,$fn=sides);
}

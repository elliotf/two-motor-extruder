da6 = 1 / cos(180 / 6) / 2;
da8 = 1 / cos(180 / 8) / 2;

// motor mount plate too thin for 8mm screws (thickness is 3, looks to be short by <1mm)
// Get rid of hotend mount plate recess, or make it more shallow? -- This would let the mount plate screw holes be more sturdy
// hotend recess diameter too large (somehow 16*da8 comes out more like 17; but it might be a good thing -- turns out it was a human problem)
// tricky bridge near filament broken again; need to make sure lone bridge is a multiple of filament width
// provide bridging for the carriage mount holes (going from larger to smaller diameter)
// hobbed bolt is in the filament path too much (was 0.75 into the filament, going to 0.5)

include <gears.scad>
include <inc/nema.scad>

extrusion_width = 0.6;
extrusion_height = 0.3;

// 608
bearing_height = 7;
bearing_outer  = 22;
bearing_inner  = 8;

// 626
bearing_height = 6;
bearing_outer  = 19;
bearing_inner  = 6;

// 625
bearing_height = 5;
bearing_outer  = 16;
bearing_inner  = 5;

filament_diam = 3;

ext_shaft_length  = 60;
ext_shaft_diam    = 6; // m6 bolt
ext_shaft_diam    = 8; // m8 bolt
ext_shaft_diam    = 5; // m5 threaded rod
hobbed_diam = ext_shaft_diam;
ext_shaft_opening = ext_shaft_diam + 2;
ext_shaft_opening = bearing_outer - 1;
hobbed_diam = 8;
ext_shaft_opening = hobbed_diam + 1.5;

carriage_hole_spacing = 30;
carriage_hole_small_diam    = 3.2;
carriage_hole_large_diam    = 6.2;
carriage_hole_support_thickness = 8;

motor_screw_spacing = 26;

hotend_length = 63;
hotend_diam   = 16;
hotend_mount_hole_depth = 5;
hotend_mount_screw_hole_spacing = 24;
hotend_mount_screw_diam = 4;
hotend_mount_screw_nut = 7.3;
hotend_mount_length = 37.5*2;
hotend_mount_width = 28;
hotend_mount_height = 0;

mount_plate_thickness = 3;
bottom_thickness = 8;
body_bottom_pos = -motor_side/2-bottom_thickness;
total_depth = mount_plate_thickness + motor_height + 1;
total_width = motor_side + motor_side*1.4;
total_height = motor_side + bottom_thickness;

filament_from_carriage = hotend_diam / 2 + 8; // make sure the hotend can clear the carriage
filament_x = hobbed_diam/2 + filament_diam/2 - .6;
filament_y = total_depth - filament_from_carriage;

module assembly() {
  //gear_assembly();
  translate([0,0,0]) extruder_body();

  // motor
  % translate([-gear_dist,21.25,0]) rotate([90,0,0]) nema14();

  // extruder shaft
  % translate([0,ext_shaft_length/2-15,0]) rotate([90,0,0]) rotate([0,0,22.5])
    cylinder(r=ext_shaft_diam/2,h=ext_shaft_length,center=true);

  // hobbed whatnot
  % translate([0,filament_y,0]) rotate([90,0,0]) rotate([0,0,22.5])
    cylinder(r=hobbed_diam/2+0.05,h=bearing_height,center=true);

  // filament
  % translate([filament_x,filament_y,0]) cylinder(r=3/2,h=60,$fn=8,center=true);

  // hotend
  //% translate([filament_x,filament_y,body_bottom_pos-hotend_length/2+hotend_mount_hole_depth]) cylinder(r=hotend_diam/2,h=hotend_length,center=true);

  //translate([idler_crevice_x,filament_y,idler_crevice_z - idler_crevice_depth/2 + idler_length/2]) {
  translate([idler_crevice_x,filament_y,0.05]) {
    idler();
  }
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
  bridges();
}

module extruder_body_base() {
  // motor plate
  translate([-motor_side*0.3,mount_plate_thickness/2,0])
    cube([total_width,mount_plate_thickness,motor_side],center=true);

  // main block
  translate([motor_side*0.2,total_depth/2+mount_plate_thickness/2,0])
    cube([motor_side*1.4,total_depth-mount_plate_thickness,motor_side],center=true);

  // bottom
  translate([-motor_side*0.3,total_depth/2,body_bottom_pos+bottom_thickness/2])
    cube([total_width,total_depth,bottom_thickness],center=true);

  // additional material for idler screw holes
  translate([filament_x,filament_y,idler_screw_from_shaft-4]) {
    for (side=[-1,1]) {
      translate([0,(idler_screw_spacing/2)*side,0]) rotate([0,90,0]) scale([1,1.5,1])
        cylinder(r=idler_screw_nut_diam+6*da6,h=45,$fn=8,center=true);
    }
  }

  // bolster hotend mounting hole
  translate([filament_x+hotend_mount_screw_hole_spacing,filament_y,-bottom_thickness/2]) {
    cylinder(r=hotend_mount_screw_nut*da6+0.5,h=total_height,$fn=6,center=true);
  }
}

// 608
idler_bearing_height = 7;
idler_bearing_outer  = 22;
idler_bearing_inner  = 8;

//626
idler_bearing_height = 6;
idler_bearing_outer  = 19;
idler_bearing_inner  = 6;

//625
idler_bearing_height = bearing_height;
idler_bearing_outer  = bearing_outer;
idler_bearing_inner  = bearing_inner;

idler_width     = idler_bearing_height+14;
idler_thickness = idler_bearing_inner+3+1;
idler_shaft_diam = idler_bearing_inner;
idler_shaft_length = idler_width*2;
idler_x = filament_x + idler_bearing_outer/2 + filament_diam/2;

// m3
idler_screw_diam = 3.2;
idler_screw_nut_diam = 5.7;

// 4-40
idler_screw_diam = 3.2;
idler_screw_nut_diam = 6.8;

idler_screw_spacing = (idler_width - idler_bearing_height - 2);
idler_screw_from_shaft = 13;
idler_screw_from_shaft = bearing_outer/2+idler_screw_nut_diam/2+2;

idler_crevice_width = idler_thickness + .5;
idler_crevice_length = total_depth - (filament_y - idler_width/2) + 2;
idler_crevice_depth = 5;
idler_crevice_x = idler_x - 0.5;
idler_crevice_y = total_depth - idler_crevice_length / 2 + 0.5;
idler_crevice_z = body_bottom_pos + bottom_thickness + idler_crevice_depth/2 + 2.75;

idler_length    = idler_bearing_outer+16;
idler_length    = motor_side - 2.75;
idler_length    = -1*(idler_crevice_z - idler_crevice_depth/2 - motor_side/2);
idler_lower_half = -1*(idler_crevice_z - idler_crevice_depth/2);
idler_upper_half = idler_screw_from_shaft+idler_screw_diam/2+3;
idler_thumb_lever_thickness = 3;
idler_thumb_lever_length = 6;

module idler_bearing() {
  difference() {
    cylinder(r=idler_bearing_outer/2,h=idler_bearing_height,center=true);
    cylinder(r=idler_bearing_inner/2,h=idler_bearing_height*2,center=true);
  }
}

module idler() {
  difference() {
    //translate([0,0,0]) cube([idler_thickness,idler_width,idler_length],center=true);
    union() {
      translate([0,0,-idler_lower_half/2]) cube([idler_thickness,idler_width,idler_lower_half],center=true);
      translate([0,0,idler_upper_half/2]) cube([idler_thickness,idler_width,idler_upper_half+0.05],center=true);
      translate([idler_thickness/2-idler_thumb_lever_thickness/2,0,idler_upper_half+idler_thumb_lever_length/2])
        cube([idler_thumb_lever_thickness,idler_width,idler_thumb_lever_length+0.05],center=true);
    }

    // holes for screws
    for(side=[-1,1]) {
      translate([(idler_thickness)/2,idler_screw_spacing/2*side,idler_screw_from_shaft]) {
        hull() {
          rotate([0,-85,0]) translate([0,0,(idler_thickness)/2+1]) rotate([0,0,90])
            cylinder(r=idler_screw_diam*da6,h=idler_thickness+2.05,center=true);
          rotate([0,-95,0]) translate([0,0,(idler_thickness)/2+1]) rotate([0,0,90])
            cylinder(r=idler_screw_diam*da6,h=idler_thickness+2.05,center=true);
        }
      }
    }

    // hole for bearing
    cube([idler_bearing_outer,idler_bearing_height+0.5,idler_bearing_outer+2],center=true);
    translate([-idler_thickness/2,0,0]) rotate([0,0,22.5]) cylinder(r=(idler_bearing_height+0.5)*da8,$fn=8,h=idler_length*2,center=true);

    translate([-0.5,0,0]) {
      rotate([90,0,0]) rotate([0,0,22.5]) cylinder(r=da8*(idler_shaft_diam),h=idler_shaft_length,$fn=8,center=true);
      // idler bearing
      % rotate([90,0,0]) idler_bearing();
    }
  }
}

module extruder_body_holes() {
  // shaft hole
  translate([0,0,0]) rotate([90,0,0]) cylinder(r=ext_shaft_opening/2,h=100,$fn=36,center=true);
  translate([bearing_outer/2,motor_height/2,0]) cube([bearing_outer,motor_height*2,ext_shaft_opening],center=true);

  // large opening
  translate([motor_side/2+bearing_outer/2,motor_height/2,idler_crevice_z+idler_crevice_depth/2+motor_side/2])
    cube([motor_side,motor_height*2,motor_side],center=true);

  // filament path
  translate([filament_x,filament_y,0]) rotate([0,0,22.5]) cylinder(r=da8*(filament_diam*1.25),$fn=8,h=50,center=true);

  translate([0,bearing_height/2,0]) {
    translate([0,-0.05,0]) {
      // gear-side bearing
      rotate([90,0,0]) cylinder(r=bearing_outer/2+0.1,h=bearing_height,center=true);

      // round the sharp corner from the gear-side bearing
      //translate([11,0,0]) rotate([90,0,0]) rotate([0,0,22.5]) cylinder(r=10.8,$fn=8,h=bearing_height,center=true);
    }

    % translate([0,0,0]) rotate([90,0,0]) bearing();
  }


  // gear-side filament support bearing
  translate([0,filament_y-bearing_height*1.75-1,0]) {
    rotate([90,0,0])
      cylinder(r=bearing_outer/2+0.1,h=bearing_height*2.5,center=true);

    translate([bearing_outer*.25,0,0])
      cube([bearing_outer/2+0.1,bearing_height*2.5,bearing_outer+0.2],center=true);

    % rotate([90,0,0]) bearing();
  }
  translate([0,bearing_height,0]) {
    rotate([90,0,0])
      cylinder(r=bearing_outer/2-1,h=20,center=true);
    translate([bearing_outer/2,0,0]) cube([bearing_outer-2,20,bearing_outer-2.5],center=true);
  }

  // idler bearing access
  translate([bearing_outer/2+hobbed_diam/2+filament_x-4,filament_y+5,0]) rotate([90,0,0]) rotate([0,0,22.5])
    cylinder(r=bearing_outer/2+1.052,h=total_depth/1.5,$fn=8,center=true);

  // carriage-side filament support bearing
  translate([0,filament_y+bearing_height*2+1,0]) rotate([90,0,0])
    cylinder(r=bearing_outer/2+0.1,h=bearing_height*3,center=true);
  //% translate([0,filament_y+bearing_height+1.2,0]) rotate([90,0,0]) bearing();

  // idler crevice
  translate([idler_crevice_x,idler_crevice_y,idler_crevice_z+idler_crevice_depth/2])
    cube([idler_crevice_width,idler_crevice_length,idler_crevice_depth*2],center=true);

  // idler screw holes for idler screws
  translate([filament_x,filament_y,idler_screw_from_shaft]) {
    for (side=[-1,1]) {
      translate([0,idler_screw_spacing/2*side,0]) rotate([0,90,0]) cylinder(r=idler_screw_diam*da6,h=45,$fn=6,center=true);
    }
  }

  // captive nut recesses for idler screws
  translate([-2.5,filament_y,idler_screw_from_shaft]) {
    for (side=[-1,1]) {
      translate([0,idler_screw_spacing/2*side,0]) rotate([0,90,0]) cylinder(r=idler_screw_nut_diam*da6,h=4,$fn=6,center=true);
      translate([0,idler_screw_spacing/2*side,0]) rotate([0,90,0]) cylinder(r=idler_screw_nut_diam*da6,h=4,$fn=6,center=true);
      translate([0,idler_screw_spacing/2*side,5]) cube([4,idler_screw_nut_diam,10],center=true);
    }
  }

  // material saving

  // top center front by large gear
  translate([10,0,motor_side/2+5.25]) {
    rotate([22,20,0]) cube([40,50,22],center=true);
  }
  translate([17.5,0,bearing_outer/2]) {
    rotate([10,0,65]) cube([10,20,10],center=true);
  }
  // bottom front
  translate([filament_x+4,-15,body_bottom_pos-7]) {
    rotate([60,0,0]) cylinder(r=20,h=100,center=true);
  }

  // center back
  translate([0,total_depth+5.5,motor_side/2+2]) {
    rotate([15,0,0]) cube([50,20,50],center=true);
  }
  translate([-motor_side/2,total_depth+6,10]) {
    rotate([10,0,10]) cube([50,20,motor_side+10],center=true);
  }

  // space between motor and extruder shaft
  translate([-gear_dist/2-6,mount_plate_thickness+motor_height/2+10,motor_side/2-12]) {
    rotate([0,10.5,0]) cube([20,motor_height+20,motor_side+8],center=true);
  }

  // right front corner
  translate([31,0,-total_height/2]) {
    rotate([0,0,-30]) cube([20,60,30],center=true);
  }
  // bottom
  translate([17.5,-8,body_bottom_pos/2]) {
    rotate([0,0,45]) cube([70,20,40],center=true);
  }
  translate([18,-7,body_bottom_pos/2]) {
    rotate([-20,0,40]) cube([60,20,40],center=true);
  }

  // right rear corner
  translate([35.75,total_depth,body_bottom_pos]) {
    rotate([0,0,30]) cube([20,40,60],center=true);
  }

  // bottom motor end
  translate([-gear_dist-motor_side/2,total_depth/2,body_bottom_pos-3.75]) {
    rotate([10,40,0]) cube([30,total_height*2,20],center=true);
  }
  translate([-gear_dist-motor_side/2+21,total_depth,body_bottom_pos]) {
    rotate([0,0,47]) cube([total_depth*3,20,20],center=true);
  }

  // top motor end
  translate([-gear_dist-motor_side/2,0,motor_side/2]) {
    rotate([0,45,0]) cube([5,10,10],center=true);
  }

  // motor
  translate([-gear_dist,mount_plate_thickness/2,0]) rotate([90,0,0]){
    // motor shoulder
    cylinder(r=motor_shoulder_diam/2+1,h=mount_plate_thickness*2,center=true);

    // motor mounting holes
    for (x=[-1,1]) {
      for (y=[-1,1]) {
        translate([motor_screw_spacing/2*x,motor_screw_spacing/2*y,0]) cylinder(r=3.2*da6,h=mount_plate_thickness*2,$fn=6,center=true);
      }
    }
  }

  // hotend
  translate([filament_x,filament_y,body_bottom_pos]) {
    // hotend mount hole
    translate([0,0,hotend_mount_height]) rotate([0,0,22.5]) cylinder(r=da8*hotend_diam+0.05,h=hotend_mount_hole_depth*2,$fn=8,center=true);

    // plate is not symmetric, skew to one side
    translate([-1.5,0,0]) {
      // hotend plate recess
      cube([hotend_mount_length,hotend_mount_width,hotend_mount_height*2],center=true);

      // hotend plate screw holes
      for (side=[-1,1]) {
        translate([side*hotend_mount_screw_hole_spacing,0,0]) {
          // screw holes
          cylinder(r=hotend_mount_screw_diam*da6+0.05,$fn=6,h=total_height,center=true);
          % cylinder(r=hotend_mount_screw_diam/2,$fn=72,h=10,center=true);

          // captive nut recesses for hotend mounting plate
          translate([0,0,bottom_thickness+49]) cylinder(r=hotend_mount_screw_nut*da6,$fn=6,h=6.4+100,center=true);
        }
      }
    }
  }

  // filament guide top recess
  translate([filament_x,filament_y,motor_side/2]) rotate([0,0,22.5])
    cylinder(r=6.25/2,$fn=8,h=10,center=true);

  // carriage mounting holes
  translate([filament_x,total_depth/2,body_bottom_pos+bottom_thickness/2+1]) {
    for (side=[-1,1]) {
      translate([side*carriage_hole_spacing/2,-carriage_hole_support_thickness,0]) rotate([90,0,0]) rotate([0,0,22.5])
        cylinder(r=carriage_hole_large_diam*da8,$fn=8,h=total_depth,center=true);

      translate([side*carriage_hole_spacing/2,total_depth/2,0]) rotate([90,0,0])
        cylinder(r=carriage_hole_small_diam*da6,$fn=6,h=total_depth,center=true);
    }
  }
}

bridge_thickness = 0.3;

module bridges(){
  // gear support bearing
  translate([-0.5*(bearing_outer-bearing_outer)-1,bearing_height+bridge_thickness/3,0])
    cube([bearing_outer+2,bridge_thickness,bearing_outer+1],center=true);

  // hobbed support bearing bridge
  translate([0,bridge_thickness/2+filament_y-bearing_height/2-1.25,0]) {
    difference() {
      translate([-0.5*(bearing_outer-bearing_outer)-1,0,0])
        cube([bearing_outer+2,bridge_thickness,bearing_outer+1],center=true);

      // force the bridging direction by having two bridges
      //translate([0+ext_shaft_diam/2+0.05-extrusion_width*2,0,0]) cube([0.1,bridge_thickness*2,bearing_outer+2],center=true);
      //translate([0+ext_shaft_diam/2+0.05-extrusion_width*0,0,0]) cube([0.1,bridge_thickness*2,bearing_outer+2],center=true);
    }
    // make sure bridge width is a multiple of the extrusion width
    //% translate([3.1-extrusion_width*2,0,0]) cube([extrusion_width*11,bridge_thickness*2,2]);
  }

  // carriage mounting hole diameter drop
  translate([filament_x,total_depth-carriage_hole_support_thickness,body_bottom_pos+bottom_thickness/2+1]) {
    for (side=[-1,1]) {
      //translate([side*carriage_hole_spacing/2,carriage_hole_support_thickness,0])
      translate([side*carriage_hole_spacing/2,0,0])
        # cube([carriage_hole_large_diam+0.5,bridge_thickness,carriage_hole_large_diam+0.5],center=true);
    }
  }
}

module full_assembly() {
  assembly();

  translate([-gear_dist,-3.5,0]) {
    rotate([90,0,0]) small_gear();
  }

  translate([0,-10,0]) {
    rotate([-90,0,0]) large_gear();
  }
}

//rotate([90,0,0]) assembly();
//rotate([0,90,0]) idler();
//full_assembly();
assembly();
//idler();

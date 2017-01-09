
module screwhole() {
  cylinder(h=5, r=1);
}

module cover_notch() {
  difference() {
    union() {
      translate([4,4, 0]) cylinder(h=5, r=4);
      translate([4, 0, 0]) cube([45, 2.5, 5]);
      translate([4+45, 4, 0]) cylinder(h=5, r=4);
    }
    translate([0, 2.5, 0]) cube([53, 10, 5]);
  }
}

module rubber_foot() {
  color("black") translate([17.5/2, 17.5/2,0])
    resize(newsize=[17.5, 17.5, 2.5]) {
    difference() {
      sphere(r=10);
      translate([-10, -10, -10]) cube([20, 20, 10]);
    }
  }
}

module bottom_corner() {
  hull() {
    translate([15*1.5, 15*1.5, 0])
      cylinder(h=5, r1=15*1.5, r2=15/2, $fn=50);
    translate([9, 9, 0])
      cylinder(h=3, r1=9, r2=1, $fn=50);
  }
}

module bottom () {
  difference() {
    // The hull
    union() {
      color("silver") hull () {
        translate([0, 0, 0]) bottom_corner();
        translate([325, 217, 0]) rotate([0, 0, 180]) bottom_corner();
        translate([325, 0, 0]) rotate([0, 0, 90]) bottom_corner();
        translate([0, 217, 0]) rotate([0, 0, 270])bottom_corner();
      }
      // The rubber feet
      translate([17.5, 17.5, 5]) rubber_foot();
      translate([325-17.5*2, 17.5, 5]) rubber_foot();
      translate([325-17.5*2, 217-17.5*2, 5]) rubber_foot();
      translate([17.5, 217-17.5*2, 5]) rubber_foot();
    }
    // The screen cover space
    translate([35, 0, 0]) cube([325-70, 7.75, 5]);
    // The 10 screws
    translate([10, 10, 0]) screwhole();
    translate([325-10, 217-10, 0]) screwhole();
    translate([325-10, 10, 0]) screwhole();
    translate([10, 217-10, 0]) screwhole();
    translate([10, 217/2, 0]) screwhole();
    translate([325-10, 217/2, 0]) screwhole();
    translate([109.5, 12, 0]) screwhole();
    translate([325-109.5, 12, 0]) screwhole();
    translate([109.5, 217-12, 0]) screwhole();
    translate([325-109.5, 217-12, 0]) screwhole();
    // Cover notch
    translate([136, 217-2.5, 0]) cover_notch();
  }
}

bottom();

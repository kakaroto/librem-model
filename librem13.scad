eta=0.1;
MAIN_COLOR="silver";
SCREW_RADIUS=1.0;
SCREW_POS=10;
SCREW_X_POS=109.5;
SCREW_Y_POS=12;
COVER_NOTCH_CURVATURE=4;
COVER_NOTCH_LENGTH=45;
COVER_NOTCH_DEPTH=2.5;
RUBBER_FOOT_DIAMETER=17.5;
RUBBER_FOOT_DEPTH=2.5;
RUBBER_FOOT_POS=17.5;
CORNER_CURVATURE=9;
CORNER_CURVATURE2=0.1;
CORNER_HEIGHT=2;
CORNER_MAX_HEIGHT=4;
CORNER_MAX_CURVATURE=15*1.5;
CORNER_MAX_CURVATURE2=15/2;
BOTTOM_WIDTH=325;
BOTTOM_DEPTH=217;
BOTTOM_THICKNESS=0.75;
MAIN_WIDTH=327;
MAIN_DEPTH=219;
SCREEN_SWIVEL_DEPTH=7.75;
SCREEN_SWIVEL_POS=35;
SCREEN_BEZEL_BORDER=1;
SCREEN_BEZEL_BOTTOM_BORDER=8.75;
SCREEN_BEZEL_DEPTH=1;
SCREEN_BEZEL_THICKNESS=0.9;

module screwhole() {
  cylinder(h=5, r=SCREW_RADIUS);
}

module cover_notch(length) {
  difference() {
    union() {
      translate([COVER_NOTCH_CURVATURE, COVER_NOTCH_CURVATURE, 0])
        cylinder(h=5, r=COVER_NOTCH_CURVATURE);
      translate([COVER_NOTCH_CURVATURE, 0, 0])
        cube([length, COVER_NOTCH_DEPTH, 5]);
      translate([COVER_NOTCH_CURVATURE + length,
                 COVER_NOTCH_CURVATURE, 0])
        cylinder(h=5, r=COVER_NOTCH_CURVATURE);
    }
    translate([0, COVER_NOTCH_DEPTH, 0])
      cube([COVER_NOTCH_CURVATURE*2+length, COVER_NOTCH_CURVATURE*2, 5]);
  }
}

module rubber_foot() {
  color("black") translate([RUBBER_FOOT_DIAMETER/2, RUBBER_FOOT_DIAMETER/2,0])
    resize(newsize=[RUBBER_FOOT_DIAMETER, RUBBER_FOOT_DIAMETER, RUBBER_FOOT_DEPTH]) {
    difference() {
      sphere(r=10);
      translate([-10, -10, -10]) cube([20, 20, 10]);
    }
  }
}

module rounded_corner() {
  hull() {
    translate([CORNER_MAX_CURVATURE, CORNER_MAX_CURVATURE, 0])
      cylinder(h=CORNER_MAX_HEIGHT, r1=CORNER_MAX_CURVATURE, r2=CORNER_MAX_CURVATURE2, $fn=50);
    translate([CORNER_CURVATURE, CORNER_CURVATURE, 0])
      cylinder(h=CORNER_HEIGHT, r1=CORNER_CURVATURE, r2=CORNER_CURVATURE2);
  }
}

module rounded_plate(width, depth, thickness) {
  union() {
    hull () {
      translate([0, 0, thickness]) rounded_corner();
      translate([width, depth, thickness]) rotate([0, 0, 180]) rounded_corner();
      translate([width, 0, thickness]) rotate([0, 0, 90]) rounded_corner();
      translate([0, depth, thickness]) rotate([0, 0, 270]) rounded_corner();
    }
    hull() {
      translate([9, 9, 0]) cylinder(h=thickness, r=9);
      translate([width-9, depth-9, 0]) cylinder(h=thickness, r=9);
      translate([width-9, 9, 0]) cylinder(h=thickness, r=9);
      translate([9, depth-9, 0]) cylinder(h=thickness, r=9);
    }
  }
}

module bottom () {
  difference() {
    // The hull
    union() {
      difference() {
        color(MAIN_COLOR) rounded_plate(BOTTOM_WIDTH, BOTTOM_DEPTH, BOTTOM_THICKNESS);
        color(MAIN_COLOR) rounded_plate(BOTTOM_WIDTH, BOTTOM_DEPTH, 0);
      }
      // The rubber feet
      translate([RUBBER_FOOT_POS,
                 RUBBER_FOOT_POS,
                 CORNER_MAX_HEIGHT + BOTTOM_THICKNESS]) rubber_foot();
      translate([BOTTOM_WIDTH-RUBBER_FOOT_POS-RUBBER_FOOT_DIAMETER,
                 RUBBER_FOOT_POS,
                 CORNER_MAX_HEIGHT + BOTTOM_THICKNESS]) rubber_foot();
      translate([BOTTOM_WIDTH-RUBBER_FOOT_POS-RUBBER_FOOT_DIAMETER,
                 BOTTOM_DEPTH-RUBBER_FOOT_POS-RUBBER_FOOT_DIAMETER,
                 CORNER_MAX_HEIGHT + BOTTOM_THICKNESS]) rubber_foot();
      translate([RUBBER_FOOT_POS,
                 BOTTOM_DEPTH-RUBBER_FOOT_POS-RUBBER_FOOT_DIAMETER,
                 CORNER_MAX_HEIGHT + BOTTOM_THICKNESS]) rubber_foot();
    }
    // The screen cover space
    translate([SCREEN_SWIVEL_POS, 0, -eta]) cube([BOTTOM_WIDTH-(SCREEN_SWIVEL_POS*2), SCREEN_SWIVEL_DEPTH, 5]);
    // The 10 screws
    translate([SCREW_POS, SCREW_POS, -eta]) screwhole();
    translate([BOTTOM_WIDTH-SCREW_POS, BOTTOM_DEPTH-SCREW_POS, -eta]) screwhole();
    translate([BOTTOM_WIDTH-SCREW_POS, SCREW_POS, -eta]) screwhole();
    translate([SCREW_POS, BOTTOM_DEPTH-SCREW_POS, -eta]) screwhole();
    translate([SCREW_POS, BOTTOM_DEPTH/2, -eta]) screwhole();
    translate([BOTTOM_WIDTH-SCREW_POS, BOTTOM_DEPTH/2, -eta]) screwhole();
    translate([SCREW_X_POS, SCREW_Y_POS, -eta]) screwhole();
    translate([BOTTOM_WIDTH-SCREW_X_POS, SCREW_Y_POS, -eta]) screwhole();
    translate([SCREW_X_POS, BOTTOM_DEPTH-SCREW_Y_POS, -eta]) screwhole();
    translate([BOTTOM_WIDTH-SCREW_X_POS, BOTTOM_DEPTH-SCREW_Y_POS, -eta]) screwhole();
    // Cover notch
    translate([(BOTTOM_WIDTH-COVER_NOTCH_LENGTH-2-COVER_NOTCH_CURVATURE*2)/2, BOTTOM_DEPTH-COVER_NOTCH_DEPTH, -eta]) cover_notch(COVER_NOTCH_LENGTH+2);
  }
}

module screen_swivel() {
  intersection() {
    hull() {
      cube([255, 7.75, 8.5]);
      translate([0, 4, 0]) cube([255, 4, 10.5]);
    }
    hull() {
      translate([0, 0, 3]) sphere(r=8.5);
      translate([255, 0, 3]) sphere(r=8.5);
    }
  }
}

module screen_bezel() {
  difference() {
    hull() {
      translate([CORNER_CURVATURE+SCREEN_BEZEL_BORDER,
                 CORNER_CURVATURE+SCREEN_BEZEL_BOTTOM_BORDER,
                 0])
        cylinder(h=SCREEN_BEZEL_THICKNESS, r=CORNER_CURVATURE);
      translate([MAIN_WIDTH-CORNER_CURVATURE-SCREEN_BEZEL_BORDER,
                 MAIN_DEPTH-CORNER_CURVATURE-SCREEN_BEZEL_BORDER,
                 0])
        cylinder(h=SCREEN_BEZEL_THICKNESS, r=CORNER_CURVATURE);
      translate([MAIN_WIDTH-CORNER_CURVATURE-SCREEN_BEZEL_BORDER,
                 CORNER_CURVATURE+SCREEN_BEZEL_BOTTOM_BORDER,
                 0])
        cylinder(h=SCREEN_BEZEL_THICKNESS, r=CORNER_CURVATURE);
      translate([CORNER_CURVATURE+SCREEN_BEZEL_BORDER,
                 MAIN_DEPTH-CORNER_CURVATURE-SCREEN_BEZEL_BORDER,
                 0])
        cylinder(h=SCREEN_BEZEL_THICKNESS, r=CORNER_CURVATURE);
    }
    hull() {
      translate([CORNER_CURVATURE+SCREEN_BEZEL_BORDER,
                 CORNER_CURVATURE+SCREEN_BEZEL_BOTTOM_BORDER,
                 -eta])
        cylinder(h=SCREEN_BEZEL_THICKNESS+2*eta, r=CORNER_CURVATURE-SCREEN_BEZEL_DEPTH);
      translate([MAIN_WIDTH-CORNER_CURVATURE-SCREEN_BEZEL_BORDER,
                 MAIN_DEPTH-CORNER_CURVATURE-SCREEN_BEZEL_BORDER,
                 -eta])
        cylinder(h=SCREEN_BEZEL_THICKNESS+2*eta, r=CORNER_CURVATURE-SCREEN_BEZEL_DEPTH);
      translate([MAIN_WIDTH-CORNER_CURVATURE-SCREEN_BEZEL_BORDER,
                 CORNER_CURVATURE+SCREEN_BEZEL_BOTTOM_BORDER,
                 -eta])
        cylinder(h=SCREEN_BEZEL_THICKNESS+2*eta, r=CORNER_CURVATURE-SCREEN_BEZEL_DEPTH);
      translate([CORNER_CURVATURE+SCREEN_BEZEL_BORDER,
                 MAIN_DEPTH-CORNER_CURVATURE-SCREEN_BEZEL_BORDER,
                 -eta])
        cylinder(h=SCREEN_BEZEL_THICKNESS+2*eta, r=CORNER_CURVATURE-SCREEN_BEZEL_DEPTH);
    }
  }
}

module screen_hole() {
  difference() {
    rounded_plate(MAIN_WIDTH, MAIN_DEPTH, 0);
    difference() {
      hull() {
        translate([CORNER_CURVATURE, CORNER_CURVATURE, 0])
          cylinder(h=CORNER_HEIGHT, r=CORNER_CURVATURE);
        translate([MAIN_WIDTH-CORNER_CURVATURE, MAIN_DEPTH-CORNER_CURVATURE, 0])
          cylinder(h=CORNER_HEIGHT, r=CORNER_CURVATURE);
        translate([MAIN_WIDTH-CORNER_CURVATURE, CORNER_CURVATURE, 0])
          cylinder(h=CORNER_HEIGHT, r=CORNER_CURVATURE);
        translate([CORNER_CURVATURE, MAIN_DEPTH-CORNER_CURVATURE, 0])
          cylinder(h=CORNER_HEIGHT, r=CORNER_CURVATURE);
      }
      hull() {
        translate([CORNER_CURVATURE, CORNER_CURVATURE, 0])
          cylinder(h=CORNER_HEIGHT, r=CORNER_CURVATURE-SCREEN_BEZEL_BORDER);
        translate([MAIN_WIDTH-CORNER_CURVATURE, MAIN_DEPTH-CORNER_CURVATURE, 0])
          cylinder(h=CORNER_HEIGHT, r=CORNER_CURVATURE-SCREEN_BEZEL_BORDER);
        translate([MAIN_WIDTH-CORNER_CURVATURE, CORNER_CURVATURE, 0])
          cylinder(h=CORNER_HEIGHT, r=CORNER_CURVATURE-SCREEN_BEZEL_BORDER);
        translate([CORNER_CURVATURE, MAIN_DEPTH-CORNER_CURVATURE, 0])
          cylinder(h=CORNER_HEIGHT, r=CORNER_CURVATURE-SCREEN_BEZEL_BORDER);
      }
    }
    hull() {
      translate([CORNER_CURVATURE+SCREEN_BEZEL_BORDER,
                 CORNER_CURVATURE+SCREEN_BEZEL_BOTTOM_BORDER, 0])
        cylinder(h=5, r=CORNER_CURVATURE);
      translate([MAIN_WIDTH-CORNER_CURVATURE-SCREEN_BEZEL_BORDER,
                 MAIN_DEPTH-CORNER_CURVATURE-SCREEN_BEZEL_BORDER, 0])
        cylinder(h=5, r=CORNER_CURVATURE);
      translate([MAIN_WIDTH-CORNER_CURVATURE-SCREEN_BEZEL_BORDER,
                 CORNER_CURVATURE+SCREEN_BEZEL_BOTTOM_BORDER, 0])
        cylinder(h=5, r=CORNER_CURVATURE);
      translate([CORNER_CURVATURE-SCREEN_BEZEL_BORDER,
                 MAIN_DEPTH-CORNER_CURVATURE-SCREEN_BEZEL_BORDER, 0])
        cylinder(h=5, r=CORNER_CURVATURE);
    }
    // The screen cover space
    translate([SCREEN_SWIVEL_POS, 0, -eta])
      cube([BOTTOM_WIDTH-(SCREEN_SWIVEL_POS*2), SCREEN_BEZEL_BOTTOM_BORDER, 5]);
  }
}

module screen () {
  difference() {
    union() {
      // The hull
      color(MAIN_COLOR) rounded_plate(MAIN_WIDTH, MAIN_DEPTH, 2.0);

      // The screen swivel
      color("black") translate([35, 0, 0]) mirror([0, 0, 1]) screen_swivel();

      // The rubber bezel
      color("black") mirror([0, 0, 1]) screen_bezel();
    }
    translate([0, 0, -eta]) screen_hole();
    // The actual screen
    translate([16, 31, -eta]) cube([MAIN_WIDTH-16*2, MAIN_DEPTH-31-21, 0.75+eta]);
    // The camera
    color("black") translate([MAIN_WIDTH/2, MAIN_DEPTH-13.5, -eta]) cylinder(h=eta+0.01, r=3.5/2);
    
  }
}

screen();
//translate([0, 0, 10]) screen_hole();

//rounded_corner();
//bottom();

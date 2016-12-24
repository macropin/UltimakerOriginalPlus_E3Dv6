module body(){
    // main block surrounding heat sink
    difference(){
        translate([0,0,46/2]) cube([30,30,46], center=true );
        translate([0,0,15]) rotate([0,90,0]) cylinder(d=28, h=31, center=true );
    }
}

module cutout_e3dv6(){
    // cutout for E3D V6 heat sink
    translate([0,0,-1]) cylinder(d=22, h=26+1);
    cylinder(d=12, h=46);
    translate([0,0,26]) cylinder(d=16, h=7);
    translate([0,0,39]) cylinder(d=16, h=7+1);
}

module cutout_inset(){
    // cutout to insert and remove E3D V6 hot end
    translate([0,-22/2,-1]) cube([16, 22, 26+1]);
    translate([0,-12/2,0]) cube([16, 12, 46]);
    translate([0,-16/2,26]) cube([16, 16, 7]);
    translate([0,-16/2,39]) cube([16, 16, 7+1]);    
}

module bush(){
    difference(){
        cylinder(d=18, h=35, center=true);
        cylinder(d=12, h=35+1, center=true);
    }
}

module mount_bush(){
    translate([35/2-4,0,0]) rotate([0,90,0])bush(); // X-axis bush
    translate([0,-35/2+2,18]) rotate([90,0,0])bush(); // Y-axis bush
}

module mount(){
    translate([-16,18,32]) mount_bush();
    difference(){
        body();
        cutout_e3dv6();
        translate([0,-16,0]) rotate([0,0,90]) cutout_inset();
//        translate([0,0,46/2]) cube([30+1,30,46+1], center=true);
    }
}

//cutout_inset();
mount();
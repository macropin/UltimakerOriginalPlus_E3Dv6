module cut_fan_hotend(){
    translate([0,0,15]) rotate([0,90,0]) cylinder(d=28, h=31, center=true, $fn=360);
    translate([15+10/2,0,15]) cube([10,30+1,30], center=true, $fn=360);
}

module cut_e3dv6(){
    // cut for E3D V6 heat sink
    translate([0,0,-1]) cylinder(d=22, h=26+1, $fn=360);
    cylinder(d=12, h=46, $fn=360);
    translate([0,0,26]) cylinder(d=16, h=7, $fn=360);
    translate([0,0,39]) cylinder(d=16, h=7+1, $fn=360);
}

module cut_inset(){
    // cut to insert and remove E3D V6 hot end
    translate([0,-22/2,-1]) cube([16, 22, 26+1]);
    translate([0,-12/2,0])  cube([16, 12, 46]);
    translate([0,-16/2,26-1]) cube([16, 16, 7+1]);
    translate([0,-16/2,39]) cube([16, 16, 7+1]);    
}

module cut_holes(){
    // left hot end and 5015 print fan top left
    //screw clearance
    translate([12,-5,42.7-6.5]) rotate([90,0,0]){
        cylinder(d=3.3, h=25, center=true, $fn=360);
        translate([0,0,-12.5]){ //nut clearance
            cylinder(d=6.4, h=2.5+1, $fn=6);
            translate([6.4/2,0,(2.5+1)/2]) cube([5,5.5,2.5+1], center=true);
        }
    }
    
    
    // right hot end
    //screw clearance
    translate([-12,-5,42.7-6.5]) rotate([90,0,0]){
        cylinder(d=3.3, h=25, center=true, $fn=360); //screw clearance
        translate([0,0,-12.5]){ //nut clearance
            cylinder(d=6.4, h=2.5+1, $fn=6);
            rotate(180,0,0) translate([6.4/2,0,(2.5+1)/2]) cube([5,5.5,2.5+1], center=true);
        }
        
    }

    // 5015 print fan bottom right
    translate([-12+42.75,-6,42.7-6.5-38.5]) rotate([90,0,0]){
        cylinder(d=3.3, h=10, $fn=360); //screw clearance
        translate([0,0,5]) rotate([0,0,30]) cylinder(d=6.4, h=2.5+1, $fn=6); //nut clearance
    }
    
    for (y=[-25/2,25/2], z=[5/2,30-5/2]){
        translate([16,y,z]) rotate([0,-90,0]) cylinder(d=2.8, h=10, $fn=360);
    }
}

module group_cut(){
    cut_e3dv6();
    cut_fan_hotend();
    cut_holes();
}
module mount(){
    difference(){
        union(){
            // main block surrounding heat sink
            translate([0,0,42.7/2]) cube([30,30,42.7], center=true);
            
            // block for Y axis mount
            translate([-23,-15,41.7]) intersection(){
                cube([15,30,12]);
                translate([12,0,12]) rotate([-90,0,0]) cylinder(d=24, h=30, $fn=360);
            }
        }
        // halfing it to make the body
        translate([0,-15/2-1/2,42.7/2]) cube( [30+1,15+1,42.7+1], center=true);
        group_cut();
        group_bush();
        cube([]);
    }
}

module cover(){
    difference(){
        union(){
            // main block surrounding heat sink
            translate([0,0,42.7/2]) cube([30,30,42.7], center=true );
            
            // mount for print fant
            translate([0,-15,-6.25]) cube([35,4,8]);
        }
        // halfing it to make the cover
        translate([0,+15/2+1/2,42.7/2]) cube( [30+1,15+1,42.7+1], center=true );
        group_cut();
    }
}

module cut_ziptie(){
    difference(){
        cylinder(d=17, h=4, center=true, $fn=360);
        cylinder(d=15, h=5, center=true, $fn=360);
    }
}

module pair_cut_ziptie(){
    pitch = 24;
    translate([0,0,pitch/2]) cut_ziptie();
    translate([0,0,-pitch/2]) cut_ziptie();
}

module bush(){
    color("orange") cylinder(d=12.2, h=35, center=true, $fn=360);
    color("yellow") cylinder(d=6.2, h=100, center=true, $fn=360);
    pair_cut_ziptie();
}

module group_bush(){
    translate([-16,17,30+6]) union(){
        translate([35/2-1.5,0,0]) rotate([0,90,0]) bush(); // X-axis bush
        translate([2,-35/2+0.5,18]) rotate([90,0,0]) bush(); // Y-axis bush
    }
}

//mount();
cover();
//group_bush();
//cut_holes();
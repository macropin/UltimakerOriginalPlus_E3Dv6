//diameter of clearance holes for M3 hardware
dia_screw_clear= 3.5;
dia_head_clear= 7;
height_head_clear= 4;

//diameter of nut traps
dia_nut_trap= 6.6;
height_nut_trap=2.7;

module cut_fan_hotend(){
    translate([0,0,15]) rotate([0,90,0]) cylinder(d=28, h=36, center=true, $fn=360);
}

module cut_e3dv6(){
    // cut for E3D V6 3.00 mm bowden heat sink
    // these diameters are from the Prusa i3 MK2
    translate([0,0,-2]) cylinder(d=22+1, h=26+2, $fn=360);
    cylinder(d=12+0.4, h=46, $fn=360);
    translate([0,0,26]) cylinder(d=16+0.4, h=7, $fn=360);
    translate([0,0,38-0.2]) cylinder(d=16+0.4, h=7+1.75, $fn=360);
}

module cut_inset(){
    // cut to insert and remove E3D V6 hot end
    translate([0,-22/2,-1]) cube([16, 22, 26+1]);
    translate([0,-12/2,0])  cube([16, 12, 46]);
    translate([0,-16/2,26-1]) cube([16, 16, 7+1]);
    translate([0,-16/2,39]) cube([16, 16, 7+1]);    
}

module cut_holes(){
    
    // cover fastening holes
    for (x=[-12,12]){
        translate([x,-5,42.7-6.5]) rotate([90,0,0]){
            cylinder(d=dia_screw_clear, h=25, center=true, $fn=360); //screw clearance
            translate([0,0,0-20]) rotate([0,0,90]) cylinder(d=dia_nut_trap, h=10, $fn=6);
            translate([0,0,8]) cylinder(d=dia_head_clear, h=height_head_clear+1, center=true, $fn=360); //screw head clearance
        }
    }

    // hot end fan holes
    for (y=[-25/2,25/2], z=[5/2,30-5/2]){
        translate([-35/2+9,y,z]) rotate([0,-90,0]) cylinder(d=2.8, h=10, $fn=360);
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
            translate([-35/2,0,-1]) cube([35,15,47.5]);
            
            // block for Y axis mount
            translate([-25,-15,43]) intersection(){
                cube([17,30,12]);
                translate([12,0,12]) rotate([-90,0,0]) cylinder(d=24, h=30, $fn=360);
            }
        }
        // halfing it to make the body
        group_cut();
        group_bush();
        cube([]);
    }
}

module cover(){
    difference(){
        union(){
            // main block surrounding heat sink
            translate([-35/2,-15,-1]) cube([35,15,43.7]);
        }
        group_cut();
    }
}

module cut_ziptie(){
    difference(){
        cylinder(d=18, h=4, center=true, $fn=360);
        cylinder(d=14, h=5, center=true, $fn=360);
    }
}

module pair_cut_ziptie(){
    pitch = 24;
    translate([0,0,pitch/2]) cut_ziptie();
    translate([0,0,-pitch/2]) cut_ziptie();
}

module bush(){
    color("orange") cylinder(d=12.4, h=35+1, center=true, $fn=360);
    color("yellow") cylinder(d=6.2, h=100, center=true, $fn=360);
    pair_cut_ziptie();
}

module group_bush(){
    translate([-16,17,30+7]) union(){
        translate([35/2-1.5,0,0]) rotate([0,90,0]) bush(); // X-axis bush
        translate([2,-35/2+0.5,18]) rotate([90,0,0]) bush(); // Y-axis bush
    }
}

module duct_print_cooling(){
    difference(){
    
        union(){
        
            // 5015 print fan mount
            translate([-30.75,1,10]){
                rotate([0,0,90]) cylinder(d=8, h=5, $fn=6);
                cube([18,4,5]);
            }
    
            // Print fan nozzle mount - right
            translate([-12.5,12,9]) cylinder(d=8, h=6, $fn=6);
        
            // hook
            translate([16.5,-2,8]) cube([1,18,7]);
            difference() {
                translate([16.5,12,8]) cube([4,5,7]);
                translate([20.5,14.3,5]) rotate([0,0,45]) cube([5,5,15]);
            }
        
            // Print cooling airway
            translate([-9.5,0,13])rotate([0,0,0]) cube([27,9,2]);
            difference(){
                translate([-9.5,7.6,13.5])rotate([-45,0,0]) cube([27,7,2]);
                translate([-10.5,13,5])rotate([0,0,0]) cube([29,7,12]);
                translate([-10.5,9,7])rotate([0,0,0]) cube([29,7,2]);
            }    
        
            translate([-14.5,0,9])rotate([0,0,0]) cube([1+5,13,6]);  
        }

        // Fan nozzle mount hole
        translate([-12.5,12,5]){
            cylinder(d=dia_screw_clear, h=12, $fn=30);
            translate([0,0,3.99]) cylinder(d=dia_nut_trap, h=height_nut_trap, $fn=6);
        }

        // 5015 print fan bottom right mount hole 
        translate([-30.75,1,0]){
            cylinder(d=dia_screw_clear, h=20, $fn=30);
            rotate([0,0,90]) translate([0,0,9]) cylinder(d=dia_nut_trap, h=height_nut_trap, $fn=6);
        }
    }
}

//translate([0,0,-1]) rotate([-90,0,180]) duct_print_cooling();
mount();
//cover();
//group_bush();
//cut_holes();
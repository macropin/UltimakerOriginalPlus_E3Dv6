// E3D V6 mount for Ultimaker Original+
// from LibreMatter
// burdickjp@protonmail.com

//XYZ dimensions of mount body
dimMount=[35,15,47.5];
//XYZ dimensions of cover body
dimCover=[dimMount[0],dimMount[1],42.7+1];

//diameter of clearance holes for M3 hardware
dia_screw_clear= 3.5;
dia_head_clear= 7;
height_head_clear= 4;

//diameter of nut traps
dia_nut_trap= 6.6;
height_nut_trap=5;

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
        translate([-dimMount[0]/2+9,y,z]) rotate([0,-90,0]) cylinder(d=2.8, h=10, $fn=360);
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
            translate([-dimMount[0]/2,0,-1]) cube(dimMount);
            
            // block for Y axis mount
            translate([-25,-15,43]) intersection(){
                cube([17,30,12]);
                translate([12,0,12]) rotate([-90,0,0]) cylinder(d=24, h=30, $fn=360);
            }
        }
        // halfing it to make the body
        group_cut();
        group_bush();
    }
}

module cover(){
    difference(){
        union(){
            // main block surrounding heat sink
            translate([-dimCover[0]/2,-dimCover[1],-1]) cube(dimCover);
            duct_print_cooling();
        }
        group_cut();
        
            
        // print fan holes
        translate([0,-15.5,0]){ 
            translate([12.5,0,-13]) rotate([-90,0,0]) {
                cylinder(d=3.5, h=7, $fn=360);
                translate([0,0,3]) cylinder(d=dia_nut_trap, h=height_nut_trap, $fn=6);
            }
            translate([30.75,0,-2]) rotate([-90,90,0]) {
                cylinder(d=3.5, h=5, $fn=360);
                translate([0,0,3]) cylinder(d=dia_nut_trap, h=height_nut_trap, $fn=6);
            }
        }
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
    translate([0,-15,0]){
        // 5051 print fan mount
        translate([8.5,0,-14]) cube([6,6,13]);
        translate([12.75,0,-6]) cube([18,5,4]);
        translate([30.75,0,-2]) rotate([-90,90,0]) cylinder(d=8, h=5, $fn=6);
        
        // print fan nozzle mount - ride side
        translate([12.5,0,-13]) rotate([-90,0,0]) cylinder(d=8, h=6, $fn=6);
        
        // print fan nozzle hook
        translate([-17.5,0,-17]) cube([1,7,18]);
        translate([-20.5,0,-18]) difference(){
            cube([4,7,5]);
            translate([-4.37,-1,0]) rotate([0,45,0]) cube([5,9,5]);
        }
        
        // print fan nozzle
        translate([-17,0,0]){
            translate([0,0,-10]) cube([27,2,9]);
            difference(){
                translate([0,5,-15]) rotate([45,0,0]) cube([27,2,7]);
                translate([0,6,-15]) cube([28,2,2]);
                translate([0,4,-16]) cube([28,2,2]);
            }
        }
    }
}

//mount();
cover();
//group_bush();
//cut_holes();
dimCube= [25,16,4];
dimHole= 3.5;
pitchHole= 10;
dimFoot= [4,dimCube[1],4];

difference(){
    translate([0,-dimCube[1]/2,0]) cube(dimCube);
    for(y=[-pitchHole/2, pitchHole/2]){
        translate([3,y,0]) cylinder(d=dimHole, h=dimCube[2]+1, $fn= 360);
    }
}
translate([dimCube[0]-dimFoot[0],-dimFoot[1]/2,dimCube[2]]) cube(dimFoot);
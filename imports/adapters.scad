use <defaults.scad>;
use <tests.scad>;
use <util.scad>;

module socket_adapter_blank( d1, h1, h2, w, h3, center=true ) {
    
    $fn=64;
    
    d2 = sqrt(pow(w,2) + pow(w,2));
    h = h1 + h2 + h3;
    
    translation = center ? [0,0,h*-0.5] : [ 0.5 * max(d1,d3), 0.5 * max(d1,d3), 0 ];

    translate(translation) union() {
        cylinder(h=h1,d=d1,$fn=32);
        reduce_moire([0,0,-1]) translate([0,0,h1]) cylinder(h=h2,d1=d1,d2=d2,$fn=32);
        reduce_moire([0,0,-2]) translate([w/-2,w/-2,h1+h2]) cube([w,w,h3]);
    }
}

module socket_extension_blank( h, d1, h1, h2, w, h3, center=true ) {

    $fn=64;
    
    d2 = sqrt(pow(w,2) + pow(w,2));
    h4 = h - h1 - h2 - h3;
    
    translation = center ? [0,0,h*-0.5] : [ 0.5 * max(d1,d3), 0.5 * max(d1,d3), 0 ];

    translate(translation) union() {
        cylinder(h=h1,d=d1);
        reduce_moire([0,0,-1]) translate([0,0,h1]) cylinder(h=h2,d1=d1,d2=d2);
        reduce_moire([0,0,-2]) translate([0,0,h1+h2]) cylinder(h=h4,d=d2);
        reduce_moire([0,0,-3]) translate([w/-2,w/-2,h1+h2+h4]) cube([w,w,h3]);
    }
}

module test_adapters() {

    socket_adapter_blank( h1=19, h2=7, h3=10, d1=22, w=9.5, center=false );
    
    translate([30,0,0]) socket_extension_blank( h=75, h1=18, h2=6, h3=10, d1=17, w=10, center=false );

}

color("blue") test_adapters();
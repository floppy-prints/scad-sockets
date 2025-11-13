use <defaults.scad>;
use <tests.scad>;
use <util.scad>;
use <sockets.scad>;

    
module make_nut( diameter = $scoped_diameter, depth = $scoped_magnet_nut_depth, fn = 6 ) {
    
    nut_diameter = subtract_tolerance( diameter, $scoped_tolerance );

    cylinder_outer( height = depth, radius = diameter / 2, fn );
}

module make_magnet( diameter, depth ) {
    color("pink") make_nut( diameter, depth, 32 );
}

module make_magnet_insert( diameter = $scoped_magnet_diameter, depth = $scoped_nut_depth, magnet_to_surface_gap = $scoped_magnet_to_surface_gap, hole_punch = $scoped_magnet_nut_hole_punch ) {

    // this is a little bit of a hack so we don't have to make a separate "make_magnet" function - make_nut subtracts the tolerance, so we increase the size of the magnet by twice the tolerance to reset it and go in the opposite direction
    tolerance = $scoped_tolerance * 2;
        
    difference() {
        make_nut( diameter, depth );
        translate([0,0,magnet_to_surface_gap])
            make_magnet( diameter + tolerance, depth );
        if ( is_num(hole_punch) ) {
            translate([x,y,-depth/2]) cylinder(magnet_to_surface_gap*2,d=hole_punch,center=true);
        }
    }
}

module make_magnet_set( sizes, space_between = 2 ) {
    for( i = [0:len(sizes)-1] ) {
        x = sum_list( sizes, limit=i ) + space_between * i;
        translate([x,0,0]) make_magnet_insert(size[i]);
    }
}


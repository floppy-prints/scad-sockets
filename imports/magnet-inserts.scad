use <defaults.scad>;
use <tests.scad>;
use <util.scad>;
    
module make_nut( diameter, depth = $scoped_magnet_nut_depth, fn = 6 ) {
    
    nut_diameter = subtract_tolerance( diameter, $scoped_tolerance );
    echo(str("DEBUG: make_nut, diameter: ", nut_diameter, "; depth: ", depth, "; fn: ", fn ));

    cylinder_outer( h = depth, d = diameter, fn=fn );
}

module make_magnet( diameter = $scoped_magnet_diameter, depth = $scoped_magnet_nut_depth - $scoped_magnet_to_surface_gap ) {
    make_nut( diameter=diameter, depth=depth, fn=32 );
}

module inner_hollow( nut_size, wall_thickness = 2, nut_thickness = $scoped_magnet_nut_depth, magnet_diameter = $scoped_magnet_diameter ) {
    difference() {
        make_nut( diameter=nut_size - wall_thickness, depth=nut_thickness - wall_thickness*2 );
        make_magnet( diameter=magnet_diameter + wall_thickness, depth=nut_size );
    }
}

module make_magnet_insert( nut_size, magnet_diameter = $scoped_magnet_diameter, depth = $scoped_magnet_nut_depth, magnet_to_surface_gap = $scoped_magnet_to_surface_gap, hole_punch = $scoped_magnet_nut_hole_punch ) {

    // this is a little bit of a hack so we don't have to make a separate "make_magnet" function - make_nut subtracts the tolerance, so we increase the size of the magnet by twice the tolerance to reset it and go in the opposite direction
    tolerance = $scoped_tolerance * 2;

    difference() {
        make_nut( subtract_tolerance( nut_size ), depth=depth );
        translate([0,0,magnet_to_surface_gap])
            make_magnet( add_tolerance( magnet_diameter ), depth=depth );
        if ( is_num(hole_punch) ) {
            cylinder(depth+2,d=hole_punch,center=true,$fn=32);
        }
        if ($scoped_for_resin && ( nut_size - magnet_diameter ) / 2 > $scoped_resin_wall_max_width) {
            // make it hollow
            inner_hollow(nut_size=nut_size,nut_thickness=depth,magnet_diameter=magnet_diameter);
            // make some drain holes
            for( i = [0:2] ) {
                rotate([0,90,i*120+30]) cylinder(nut_size+2,d=2,center=true,$fn=16);
            }
        }
    }
}

module make_magnet_set( sizes, space_between = 2, depth=$scoped_magnet_nut_depth, center=false ) {
    translation = center ? [
        (sum_list(sizes) + space_between * (len(sizes) - 1))/-2 + sizes[0]/2,
        0,
        0,
    ] : [0,max(sizes)/2,depth/2];
        
    translate(translation) {
        for( i = [0:len(sizes)-1] ) {
            size = sizes[i];
            x = sum_list( sizes, limit=i ) + space_between * i;
            translate([x,0,0]) make_magnet_insert(sizes[i],depth=depth);
        }
    }
}

module test_magnet_inserts() {
    
    use_all_defaults() use_magnet_diameter(10) use_magnet_nut_thickness(10) {
        color("green") translate([0,0,0]) make_magnet();
        color("blue") translate([20,0,0]) make_nut( 15 );
        color("pink") translate([40,0,0]) make_magnet_insert( nut_size=15 );
        
        color("purple") translate([65,0,0]) resin_print() make_magnet_insert( nut_size=20 );
    }
}

use_all_defaults() test_magnet_inserts();
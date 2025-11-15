use <defaults.scad>;
use <tests.scad>;
use <util.scad>;

module sockets( sizes=$scoped_sockets, set_width = $scoped_socket_set_width, depth=$scoped_socket_depth, centered=true ) {
    echo(str("DEBUG: ################################"));
    echo(str("DEBUG: generating sockets ", sizes));
    if ( ! is_num(depth) ) {
      assert(false,"No socket depth supplied to sockets() function");
    }
    if ( ! is_num(set_width) ) {
      assert(false,"No set width supplied to sockets() function");
    }
    if ( is_list($scoped_labels) && is_string($scoped_label_placement) ) {
      echo(str("DEBUG: using labels: ", $scoped_labels ));    
    }
    use_sockets( sizes ) use_socket_set_width( set_width ) use_socket_depth( depth ) {
        largest = max(sizes);
        smallest = min(sizes);
        for( index = [ 0: len(sizes) - 1 ] ) {
          echo(str("DEBUG: ---------------------------------"));
          echo(str("DEBUG: generating socket index ",index));
          echo(str("DEBUG: global sockets: ", $scoped_sockets ));
          echo(str("DEBUG: global set width: ", $scoped_socket_set_width ));
          echo(str("DEBUG: global depth: ", $scoped_socket_depth ));          
          echo(str("DEBUG: global tolerance: ", $scoped_tolerance ));
          
          x = get_socket_center_x( index );
          y = centered ? 0 : ( sizes[index] - largest ) / 2;
          echo(str("DEBUG: coordinates [", x, ",", y, "]"));
          translate([x,y,0]) {
            color("red") socket_cutout(sizes[index]);
            if ( is_list($scoped_labels) && is_string($scoped_label_placement) ) {
              translate( get_label_placement_offset( sizes[index] ) )
                color("red") socket_label( $scoped_labels[index] );
            }
          }
        }
    }

}

module socket_label( 
    label, 
    depth = $scoped_label_depth, 
    size = $scoped_label_font_size, 
    font = $scoped_label_font,
    halign = $scoped_label_halign, 
    valign = $scoped_label_valign, 
    spacing = $scoped_label_spacing
) {
    linear_extrude(depth) rotate($scoped_label_rotation) text( str(label), size=size, font=font, halign=halign, valign=valign, spacing=spacing );
}

module socket_labels( labels, sizes = $scoped_sockets, set_width = $scoped_socket_set_width, placement = $scoped_label_placement, depth = $scoped_label_depth ) {

    if ( is_undef( sizes ) || is_undef( set_width ) ) {
        asset(false,"Cannot use socket_label_set without supplying sizes and set width");
    }

    for( index = [0:len(labels)-1] ) {
        if ( ! is_undef(sizes[index]) ) {
            offset = get_label_placement_offset( placement, sizes[index] );
            x = get_socket_center_x(index,sizes,set_width) + offset[0];
            translate([x,offset[1],offset[2]])
            socket_label( labels[index], depth );
        } else {
            assert( false, str("Cannot generate label for socket index ",
           index));
        }
        
    }
}

module socket_cutout( size, depth=$scoped_socket_depth, drive=$scoped_socket_drive, magnet_dimensions = $scoped_socket_drive_magnet ) {
    if ( is_num(drive) ) {
       echo(str("DEBUG: adding drive to cutout: ", $scoped_socket_drive ));
    }
    difference() {
        cylinder_outer( h=depth, d=size + $scoped_tolerance, fn=64 );
        difference() {
            if ( is_num(drive) ) {
              color("blue") reduce_moire([0,0,-1]) translate([ 0, 0, -depth/2 + drive/2 ] )
                cube( drive, center=true);
            }
            
        }
    }
    if ( is_list(magnet_dimensions) ) {
      color("blue") reduce_moire([0,0,1]) translate([ 0, 0, -depth/2 + drive - magnet_dimensions[1]/2 ] )
        cylinder( d=magnet_dimensions[0], h=magnet_dimensions[1], center=true, $fn=32);
    }
}

/**
 * add_tolerance_to_set
 * 
 * applies a specified tolerance amount to each value in a list of socket diameters
 * 
 * sockets: a list of socket diameters
 * tolerance: (scoped*) the amount to add
 */
__add_tolerance_to_sockets = function ( sockets, tolerance = $scoped_tolerance ) (
    [ for ( socket_size = sockets ) add_tolerance( socket_size, tolerance ) ]
);
function add_tolerance_to_sockets( sockets, tolerance = $scoped_tolerance ) = 
    __add_tolerance_to_sockets( sockets, tolerance );
  
/**
 * get_socket_center_x
 * 
 * calculates the center X coordinate of a socket in a set
 * 
 * index: the index of a socket in a set
 * sockets: (scoped*) a list containing socket diameters
 * set_width: (scoped*) the amount of space to stretch the sockets across
 */
__get_socket_center_x = function( index, sockets = $scoped_sockets, set_width = $scoped_socket_set_width 
) let ( set_center_x = set_width / 2 ) (
    sum_list(sockets,index) + (get_space_between_sockets(sockets,set_width)*index) + (sockets[index]/2) - set_center_x
);
function get_socket_center_x( index, sockets = $scoped_sockets, set_width = $scoped_socket_set_width ) = 
    __get_socket_center_x( index, sockets, set_width );

/**
 * get_space_between_sockets
 * 
 * calculates the amount of space between each socket in a set
 * 
 * sizes: the diameter of each socket
 * set_width: the amount of space to stretch the sockets across
 */
__get_space_between_sockets = function( sizes = $scoped_sockets, set_width = $scoped_socket_set_width ) (
    ( set_width - sum_list(sizes) - ( $scoped_tolerance * len(sizes) ) ) / ( len(sizes) - 1 ) 
);
function get_space_between_sockets( sizes = $scoped_sockets, set_width = $scoped_socket_set_width ) =
    __get_space_between_sockets( sizes, set_width );

/**
 * get_label_placement_offset
 * 
 * calculates the vector location of a socket label in relation to the socket's center
 * 
 * size: the diameter of the socket
 * placement: 
 *   "above" - places the label with the bottom of the text facing the socket
 *   "below" - places the label with the top of the text facing the socket
 *   "base"  - places the label within the socket at the drive side (you should probably disable drive cutouts if this is used.)
 *   "lid"   - places the label within the socket at the nut side
 */
__get_label_placement_offset = function( size, placement = $scoped_label_placement, depth = $scoped_socket_depth ) let (
  y = placement == "above"
    ? size / 2 + $scoped_label_placement_distance
    : placement == "below"
    ? size / -2 - $scoped_label_placement_distance
    : 0,
  z = placement == "lid"
    ? $scoped_socket_depth / 2
    : placement == "base"
    ? $scoped_socket_depth / -2
    : 0
) (
    $scoped_label_offset + [0,y,z]
);
function get_label_placement_offset( size, placement = $scoped_label_placement, depth = $scoped_socket_depth ) =
    __get_label_placement_offset( size, placement, depth );
    
    
use_all_defaults() use_tolerance(0) {

    test_sockets = [ 10, 20, 30, 50, 70, 90 ];

    get_space_between_tests = [
        [6,  test_sockets, 300],
        [66, test_sockets, 600],
    ];
    sockets_with_tolerance_tests = [
        [[10,20,30,50,70,90],test_sockets,0],
        [[11,21,31,51,71,91],test_sockets,1],
        [[15,25,35,55,75,95],test_sockets,5],
    ];
    get_distance_functional_tests = [
        [ -145,0,test_sockets,300],
        [  -93,2,test_sockets,300],
        [  105,5,test_sockets,300],
        [ -115,1,test_sockets,270],
        [  -90,2,test_sockets,270],
    ];
    get_distance_modular_tests = [
        [ -145, 0],
        [-97.8, 2],
        [   93, 5],
    ];

    echo(str("TEST: get_space_between constants\nsum: ", sum_list(test_sockets), ", tolerance: ", $scoped_tolerance ));

    test_runner( __get_space_between_sockets, get_space_between_tests );
    test_runner( __add_tolerance_to_sockets, sockets_with_tolerance_tests );
    test_runner( __get_socket_center_x, get_distance_functional_tests );

    for( test = sockets_with_tolerance_tests ) {
      tolerance = is_undef(test[2]) ? 0 : test[2];
      echo(str("TEST: running add_tolerance as scoped module, tolerance is ", tolerance));
      use_tolerance(tolerance) {
        test_runner( __add_tolerance_to_sockets, [[test[0],test[1]]] );
      }
    }
    use_tolerance(2) use_socket_set_width(300) use_sockets(test_sockets) {
        echo(str("TEST: running get_socket_center_x as scoped module, tolerance is ", $scoped_tolerance, ", width is ", $scoped_socket_set_width));
        test_runner( __get_socket_center_x, get_distance_modular_tests );
    }

    echo("TEST: Successfully executed all sockets.scad tests");
    
 }
use <imports/defaults.scad>;
use <imports/util.scad>;
use <imports/sockets.scad>;
use <imports/adapters.scad>;
use <defs/all.scad>;
//use <imports/magnet-inserts.scad>;

use_all_defaults() use_tolerance(0.4) {

    difference() {
        rotate( [-90,0,0] ) {
          import("models/tstak-side[base-x2].stl", convexity = 5, center=true);
        }
        cutouts();
    }
}

module cutouts() {

    

    use_label_placement("below")
    use_label_valign("center")
    use_label_font("Bender:style=Black")
    use_socket_drive(3/8) 
    use_socket_set_width(230) {
        for( socket_set = sets ) {
            translate( socket_set.offset )
            rotate( is_undef(socket_set.flip_labels) ? [0,0,0] : [0,0,180] )
            use_labels( socket_set.labels)
            use_sockets( socket_set.sizes )
            use_socket_drive_magnet( [5,5] )
            use_label_offset( [0,1,socket_set.z] )
            sockets( depth=socket_set.depth, centered=false );
        }
    }
    
    translate( [-90,-84,30] ) rotate([90,0,90]) socket_adapter_blank( h1=adapters[0].h1, h2=adapters[0].h2, h3=adapters[0].h3, d1=adapters[0].d1, w=adapters[0].w );
    
    translate( [84,-84,7] ) {
        for( extension = extensions ) {
            offset = is_undef(extension.offset) ? [0,0,0] : extension.offset;
            translate(offset) rotate([0,180,0]) socket_extension_blank( h=extension.h, h1=extension.h1, h2=extension.h2, h3=extension.h3, d1=extension.d1, w=extension.w );
        }
    }
    
    translate( [37,15,28] ) rotate([0,90,0]) socket_extension_blank( h=150, h1=extensions[1].h1, h2=extensions[1].h2, h3=extensions[1].h3, d1=extensions[1].d1, w=extensions[1].w );
}

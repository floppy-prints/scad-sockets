use <imports/defaults.scad>;
use <imports/util.scad>;
use <imports/sockets.scad>;
use <imports/adapters.scad>;
use <defs/all.scad>;
use <defs/tstak.scad>;
//use <imports/magnet-inserts.scad>;

use_all_defaults() use_tolerance(1) {

    difference() {
        /*rotate( [-90,0,0] ) {
          import("models/tstak-side[base-x2-drawer].stl", convexity = 5, center=true);
        }*/
        use_default_module_defs() {
            use_module_height(60)
            has_corner_pocket() 
            //has_corner_tray(10) 
            has_upper_tray(20) 
            has_stackable_roof() 
            has_shallow_inner(cutout=true)
            tstak_module( mirror=false, center=true );
        }
        cutouts();
    }
}

module cutouts() {

    socket_sets = socket_sets();
    use_sets = [ 
        //socket_sets.sae_shallow_38,
        //socket_sets.sae_deep_38,
        object( set= socket_sets.mm_shallow_38, placement= [ 8, -48, 20] ),
        object( set= socket_sets.mm_deep_38, placement= [-2,-27,3.35] )
    ];
    
    extensions = extensions();
    use_extensions = [
        object( props= extensions.short_38_dewalt, offset=[10,0,0] ),
        object( props= extensions.short_38_hf, offset=[-8,0,0] )
    ];
    
    adapters = adapters();
    use_adapters = [
        object( props= adapters.inch_38.to_half_lp, offset=[-20,0,5], rotate=[-90,180,0] ),
        object( props= adapters.inch_38.to_half_neiko, offset=[10,0,0] ),
        object( props= adapters.inch_38.to_quarter_neiko, offset=[148,0,0] )
    ];

    use_label_placement("below")
    use_label_valign("center")
    use_label_font("Bender:style=Black")
    use_socket_drive(3/8) 
    use_socket_set_width(232) {
        for( props = use_sets ) {
            translate( props.placement )
            rotate( is_undef(props.set.flip_labels) ? [0,0,0] : [0,0,180] )
            use_labels( props.set.labels)
            use_sockets( props.set.sizes )
            use_socket_drive_magnet( [5,5] )
            use_label_offset( [0,1,props.set.z] )
            sockets( depth=props.set.depth, centered=false );
        }
    }
    
    /*translate( [-90,-84,30] ) rotate([90,0,90]) socket_adapter_blank( h1=adapters[0].h1, h2=adapters[0].h2, h3=adapters[0].h3, d1=adapters[0].d1, w=adapters[0].w );*/
    
    translate( [-78,-86,20] ) {
        for( adapter = use_adapters ) {
            offset = is_undef(adapter.offset) ? [0,0,0] : adapter.offset;
            rotation = is_undef(adapter.rotate) ? [0,180,0] : adapter.rotate;
            translate(offset) rotate(rotation) socket_adapter_blank( h1=adapter.props.h1, h2=adapter.props.h2, h3=adapter.props.h3, d1=adapter.props.d1, w=adapter.props.w );
        }
    }
    
    translate( [98,-86,10] ) {
        for( extension = use_extensions ) {
            offset = is_undef(extension.offset) ? [0,0,0] : extension.offset;
            translate(offset) rotate([0,180,0]) socket_extension_blank( h=extension.props.h, h1=extension.props.h1, h2=extension.props.h2, h3=extension.props.h3, d1=extension.props.d1, w=extension.props.w );
        }
    }
    
    /*
    translate( [37,15,28] ) rotate([0,90,0]) socket_extension_blank( h=150, h1=extensions[1].h1, h2=extensions[1].h2, h3=extensions[1].h3, d1=extensions[1].d1, w=extensions[1].w );
    */
}

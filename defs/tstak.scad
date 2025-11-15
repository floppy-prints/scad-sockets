use <../imports/util.scad>

module use_default_module_defs() {
    $module_height = 60;
    $module_style = "base";
    $module_size  = "half";
    $module_flip  = false;
    
    $module_wall_thickness = 3;
    $module_floor_thickness = 3;
    $module_section = object(
        x=28,
        y=0,
        width=104,
        length=244
    );
    
    $module_features = object();
    $module_dimensions = dimensions();
    
    children();
}

function dimensions() = (
    $module_style == "base"
       ? $module_size == "half"
           ? [294,208]
           : [294,104]
       : $module_size == "half"
           ? [244,208]
           : [244,104]
);

module base_half() {
    import("../models/tstak-base-half[outline].svg", center=false);
}
    
module plane() {

    if ( $module_style == "base" ) {
        difference() {
            if ( $module_size == "half" ) {
                base_half(); // 208x294
            } else {
                base_quarter();
            }
        }
    } else {
        if ( $module_size == "half" ) {
            module_half();
        } else {
            module_quarter();
        }
    }
}

module mirrored( mirrored = true ) {
    $module_flip = mirrored;
    children();
}

module use_module_height(height) {
    $module_height = height;
    children();
}

module use_module_style( style ) {
    $module_dimensions = dimensions();
    $module_style = style;
    children();
}

module use_module_size( size ) {
    $module_dimensions = dimensions();
    $module_size = size;
    children();
}

module has_corner_pocket( depth = $module_height - $module_floor_thickness ) {
    $module_features = object( $module_features,
        corner_pocket = depth
    );
    children();        
}

module has_corner_tray( depth = 10 ) {
    $module_features = object( $module_features,
        corner_tray = depth
    );
    children();        
}

module has_upper_tray( depth = 10 ) {
    $module_features = object( $module_features,
        upper_tray = depth
    );
    children();        
}

module has_stackable_roof( depth = $module_wall_thickness, tolerance = 0.2 ) {
    $module_features = object( $module_features,
        stackable_roof = object( depth=depth, tolerance=tolerance)
    );
    children();
}

module has_stackable_floor( depth = $module_wall_thickness, tolerance = 0.2 ) {
    $module_features = object( $module_features,
        stackable_floor = object( depth=depth, tolerance=tolerance)
    );
    children();
}

module has_shallow_inner( depth = $module_height / 2, cutout=false ) {
    $module_features = object( $module_features,
        shallow_inner = object( depth=depth, cutout=cutout )
    );
    children();
}
module has_shallow_outer( depth = $module_height / 2 ) {
    $module_features = object( $module_features,
        shallow_outer = depth
    );
    children();
}


module corner_pocket(depth) {
    intersection() {
        block_hollow();
        translate([0, 0, $module_height - depth])
            cube([$module_section.x+$module_wall_thickness,30-$module_wall_thickness,depth+1]);
    }
}

module corner_tray(depth) {
    intersection() {
        block_hollow();
        translate([0, 30, $module_height - depth])
            color("blue") cube([$module_section.x + $module_wall_thickness,80,depth+1]);
    }
}

module upper_tray( depth = $module_height / 2 ) {
    color("purple") intersection() {
        difference() {
            translate([0,0,$module_floor_thickness]) 
                linear_extrude($module_height - $module_floor_thickness,center=false)
                offset(delta=-1 * ( $module_wall_thickness ),chamfer=false)
                difference() {
                    plane();
                    fr_corner_shape();
                }
            wall_cutouts();
        }
        translate([$module_section.x + $module_section.length, $module_section.y, $module_height - depth])
            cube([100,$module_section.width*2,depth+1]);
    }
}

module roof_plane() {

}
    
module block_hollow() {
    linear_extrude( $module_height, center=false )
        offset( delta=-1 * ( $module_wall_thickness ), chamfer=true )
        plane();
}    
    
module section_hollow( shrink = 0 ) {
    color("red")
    translate([0,0,$module_floor_thickness])
    difference() {
    
        intersection() {
            block_hollow();
            translate([$module_section.x+$module_wall_thickness, $module_section.y+$module_wall_thickness,$module_floor_thickness])
                cube([ $module_section.length - $module_wall_thickness*2, $module_section.width*2 - $module_wall_thickness*2, $module_height],center=false); 
        }
            
        for( i = [0:1] ) {
            translate([ 
                $module_section.x + $module_section.length/2*i + $module_wall_thickness*2 , 
                $module_section.width - $module_wall_thickness, 
                -1
            ] ) cube( center=false, [
                $module_section.length/2 - $module_wall_thickness*4,
                $module_wall_thickness * 2,
                $module_height + 2
            ] );
        }
            
        /*
        translate([28+$module_section_x+$module_wall_thickness,0,-1])
            cube([100,10000,$module_height+2],center=false);
        cube([3,10000,$module_height],center=false);
        */

    }
}

module roof_cutout( depth, tolerance ) {
    intersection() {
        section_hollow(tolerance);
        translate([28 + $module_wall_thickness, 0, $module_height - depth])
            cube([10000,10000,depth]);
    }
}

module outer_cutout( depth ) {
    translate( [
        $module_section.x + $module_wall_thickness*2, 
        $module_section.y + $module_wall_thickness*2, 
        $module_height - depth
    ] ) cube( [
        $module_section.length - $module_wall_thickness*4, 
        $module_section.width - $module_wall_thickness*4,
        depth
    ], center=false );

}

module inner_cutout( depth, cutout = false ) {
    translate( [
        $module_section.x + $module_wall_thickness, 
        $module_section.y + $module_wall_thickness + $module_section.width, 
        $module_height - depth + $module_floor_thickness
    ] ) cube( [
        $module_section.length - $module_wall_thickness*2, 
        $module_section.width - $module_wall_thickness*2,
        depth
    ], center=false );
    
    translate( [
        $module_section.x + $module_wall_thickness*2, 
        $module_section.y + $module_wall_thickness*2 + $module_section.width, 
        cutout ? $module_floor_thickness : $module_height - depth + $module_floor_thickness
    ] ) cube( [
        $module_section.length - $module_wall_thickness*4, 
        $module_section.width - $module_wall_thickness*4,
        cutout ? $module_height - $module_floor_thickness : depth + $module_floor_thickness*2
    ], center=false );

}

module fr_corner_shape() {
    polygon([ [271,0], [294,0], [294,12] ]);
}

module wall_cutouts() {
    translate([97,0,0]) cube([106,30,60],center=false);
    translate([51.5,0,0]) cube([13,5,$module_height],center=false);
    translate([235.5,0,0]) cube([13,5,$module_height],center=false);
    translate([290,40,-1]) cube([5,4,$module_height+2],center=false);
    translate([290,129.5,-1]) cube([5,4,$module_height+2],center=false);
    reduce_moire([1,-1,-1])
        linear_extrude($module_height+2,center=false)
        fr_corner_shape();
}
   
module block() {

    difference() {
        linear_extrude($module_height) 
        plane();
        if ( $module_style == "base" ) {
            wall_cutouts();
        }
    }

}

module tstak_module( mirror = $module_flip, center=false ) {

    mirror_vector = mirror ? [0,1,0] : [0,0,0];
    translation = center ? [ $module_dimensions.x/-2, $module_dimensions.y/-2, $module_height/-2 ] : [0,0,0];
    
    translate(translation)
    mirror( mirror_vector )
    difference() {
        block();
        if ( ! is_undef( $module_features.corner_pocket ) ) {
            reduce_moire([1,0,1]) corner_pocket( $module_features.corner_pocket );
        }
        if ( ! is_undef( $module_features.corner_tray ) ) {
            reduce_moire([1,0,1]) corner_tray( $module_features.corner_tray );
        }
        if ( ! is_undef( $module_features.upper_tray ) ) {
            reduce_moire([0,0,1]) upper_tray( $module_features.upper_tray );
        }
        if ( ! is_undef( $module_features.stackable_roof ) ) {
            reduce_moire([0,0,1]) roof_cutout( $module_features.stackable_roof.depth, $module_features.stackable_roof.tolerance );
        }
        if ( ! is_undef( $module_features.shallow_inner ) ) {
            reduce_moire([0,0,1]) inner_cutout( $module_features.shallow_inner.depth, $module_features.shallow_inner.cutout );
        }
    }
    
}

use_default_module_defs() {
    use_module_height(60)
    has_corner_pocket() 
    //has_corner_tray(10) 
    has_upper_tray(20) 
    has_shallow_inner(cutout=true)
    has_stackable_roof() 
    tstak_module( mirror=false, center=false );
}
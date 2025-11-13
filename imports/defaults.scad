use <util.scad>

module use_all_defaults() {
  use_general_defaults() 
  use_socket_defaults() 
  use_label_defaults() 
  use_magnet_defaults()
  children();
}

module use_general_defaults() {
    $scoped_tolerance = 0;
    children();
}

module use_tolerance(value) {
    $scoped_tolerance = value;
    children();
}

// sockets.scad
module use_socket_defaults() {
    $scoped_sockets = undef;
    $scoped_socket_set_width = undef;
    $scoped_socket_depth = 10;
    $scoped_socket_drive = false;
    $scoped_socket_drive_tolerance = 0.5;
    $scoped_socket_drive_magnet = undef;
    children();
}

module use_sockets(value) {
    $scoped_sockets = value;
    children();
}

module use_socket_set_width(value) {
    $scoped_socket_set_width = value;
    children();
}

module use_socket_depth(value) {
    $scoped_socket_depth = value;
    children();
}

module use_socket_drive(value) {
    $scoped_socket_drive = sae_to_mm(value) - $scoped_socket_drive_tolerance;
    echo("DEBUG: use_socket_drive called. received ", value, ", returned ", $scoped_socket_drive );
    children();
}

module use_socket_drive_tolerance(value) {
    $scoped_socket_tolerance = value;
    children();
}

module use_socket_drive_magnet(value) {
    $scoped_socket_drive_magnet = value;
    children();
}

module use_label_defaults() {
    $scoped_labels = undef;
    $scoped_label_placement = false;
    $scoped_label_placement_distance = 5;
    $scoped_label_depth = 4;
    $scoped_label_offset = [0,0,0];
    $scoped_label_rotation = [0,0,0];
    $scoped_label_font_size = 5;
    $scoped_label_font = "Rockwell:style=Bold";
    $scoped_label_halign = "center";
    $scoped_label_valign = "baseline";
    $scoped_label_spacing = 0.9;
    children();
}

module use_labels(value) {
    $scoped_labels = value;
    children();
}

module use_label_placement(value) {
    $scoped_label_placement = value;
    children();
}

module use_label_placement_distance(value) {
    $scoped_label_placement_distance = value;
    children();
}

module use_label_depth(value) {
    $scoped_label_depth = value;
    children();
}

module use_label_offset(value) {
    $scoped_label_offset = value;
    children();
}

module use_label_rotation(value) {
    $scoped_label_rotation = value;
    children();
}

module use_label_font_size(value) {
    $scoped_label_font_size = value;
    children();
}

module use_label_font(value) {
    $scoped_label_font = value;
    children();
}

module use_label_halign(value) {
    $scoped_label_halign = value;
    children();
}

module use_label_valign(value) {
    $scoped_label_valign = value;
    children();
}

module use_label_spacing(value) {
    $scoped_label_spacing = value;
    children();
}

module use_magnet_defaults() {
    // magnet-inserts.scad
    $scoped_magnet_nut_hole_punch = false;
    $scoped_magnet_nut_depth = 10;
    $scoped_magnet_diameter = 7;
    $scoped_magnet_to_surface_gap = 0.5;
    children();
}

module use_magnet_nut_hole_punch(value) {
    $scoped_magnet_nut_hole_punch = value;
    children();
}

module use_magnet_nut_depth(value) {
    $scoped_magnet_nut_depth = value;
    children();
}

module use_magnet_diameter(value) {
    $scoped_magnet_diameter = value;
    children();
}

module use_magnet_to_surface_gap(value) {
    $scoped_magnet_to_surface_gap = value;
    children();
}

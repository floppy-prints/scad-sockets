adapters = object(
    half_inch=object(
        to_38_apauto = object( h1=22,   h2=7.0, h3=10.0, d1=19.0, w= 9.5 ),
        to_38_neiko  = object( h1=19.5, h2=5.0, h3=12.5, d1=22.0, w= 9.5 ),
        to_34_neiko  = object( h1=19.0, h2=5.0, h3=22.0, d1=26.0, w=19.5 ),
    ),
    38_inch=object(
        to_half_lp       = object( h1=3,    h2=1.0, h3=14.0, d1=31.0, w=13.0 ),
        to_half_neiko    = object( h1=17.5, h2=3.5, h3=15.2, d1=18.5, w=13.0 ),
        to_quarter_neiko = object( h1=14.0, h2=3.0, h3= 8.0, d1=17.0, w= 6.5 ),
    ),
    quarter_inch=object(
       to_38_neiko = object( h1=12.0, h2=2.0, h3=10.0, d1=13.0, w= 9.5 )
    )
];
extensions = object(
    half_med_apauto = object( h=126, h1=22, h2=5.0, h3=15, d1=23, w=13 ),
    38_short_dewalt = object( h= 75, h1=18, h2=6.0, h3=10, d1=17, w=10 ),
    38_short_hf     = object( h= 75, h1=16, h2=4.0, h3=12, d1=17, w=10 ),
    38_med_hf       = object( h= 75, h1=60, h2=2.6, h3=10, d1=17, w=10 ),
];

base_38_set = object(
    offset = [ -3, -48, 20],
    depth  = 30,
    sizes  = [   16.8,  16.8,   16.8, 17.8,   19.8,  21.8,    21.8,  23.8,    25.8,  29.8 ],
    labels = [ "5/16", "3/8", "7/16","1/2", "9/16", "5/8", "11/16", "3/4", "13/16", "7/8" ],
    z      = 4.75,
);

sets = object(
    38_shallow_sae = base_38_set,
    38_deep_sae    = object( base_38_set,
        offset      = [-6,-27,3.35],
        depth       = 63.7,
        flip_labels = true,
        z           = 21.35
    ),
    38_shallow_mm  = object( base_38_set,
        offset=[ -3, 58, 20 ],
        labels=[ "10mm","11mm","12mm", "13mm","14mm","15mm", "16mm","17mm", "19mm","22mm" ],
    ),
    38_deep_mm     = object( base_38_set,
        offset=[ -6, 77, 3.35],
        depth       = 63.7,
        z           = 21.35
        flip_labels = true,
        labels=[ "10mm","11mm","12mm", "13mm","14mm","15mm", "16mm","17mm", "19mm","21mm" ]
    )
);
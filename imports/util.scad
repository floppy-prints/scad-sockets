use <tests.scad>

module cylinder_outer( h, r=undef, d=undef, fn=$fn) {
   if ( is_undef(r) && is_undef(d) ) {
     assert(false,"must specify r or d when calling cylinder_outer");
   }
   radius = is_undef(r) ? d/2 : r;
   fudge = 1 / cos( 180 / fn );
   cylinder( h=h, r=radius*fudge, center=true, $fn=fn );
}

module reduce_moire(direction=[0,0,1]) {
    translate( 1/128 * direction )
    children();
}

__sum_list = function ( list, limit = undef, index = 0, sum = 0 ) (
    ! is_list(list) // this is essentially to prevent an infinite loop on failure
        ? 0
        : index >= ( is_num(limit) ? min( len(list), limit ) : len(list) )
        ? sum
        : is_num( list[index] ) // if the list has mixed values, don't include them
        ? __sum_list( list, limit, index + 1, sum + list[index] )
        : __sum_list( list, limit, index + 1, sum )
);
function sum_list( list, limit = undef, index = 0, sum = 0 ) =
    __sum_list(list,limit,index,sum);
    
__sae_list_to_mm = function ( list, precision = 2 ) (
  [ for( i = list ) sae_to_mm(i,precision) ]
);
function sae_list_to_mm( list, precision = 2 ) =
  __sae_list_to_mm( list, precision );

__sae_to_mm = function( inches, precision = 2 ) let (
    magnitude = pow( 10, precision )
) (
    round( magnitude * ( inches * 25.4 ) ) / magnitude
);
function sae_to_mm( inches, precision = 2 ) =
  __sae_to_mm( inches, precision );

// the following tests will be run if you preview this file directly
  
mm_list  = [1,2,3,5,7,11,13,17,19,23,29];
in_list  = [3/16,1/2,3/4,29/32];
bad_list = ["mom",2,3,"steve",4,11,undef];

sum_tests = [ 
    [130,mm_list], 
    [1,mm_list,1], 
    [11,mm_list,4],
    [20,bad_list],
    [0,"not a list",0]
];
convert_tests = [
  [ [4.76,12.7,19.05,23.02], in_list ]
];

test_runner( __sum_list, sum_tests );
test_runner( __sae_list_to_mm, convert_tests );

echo("Successfully executed all util.scad tests");
module test_runner( func, tests ) {
    for( test = tests ) {
        expected = test[0];
        if ( len( test ) > 9 ) {
            echo("WARNING: A test was performed with more than 8 parameters, all additional parameters are ignored.");
        };
        value = len( test ) == 1 ? func() 
              : len( test ) == 2 ? func(test[1])
              : len( test ) == 3 ? func(test[1],test[2])
              : len( test ) == 4 ? func(test[1],test[2],test[3])
              : len( test ) == 5 ? func(test[1],test[2],test[3],test[4])
              : len( test ) == 6 ? func(test[1],test[2],test[3],test[4],test[5])
              : len( test ) == 7 ? func(test[1],test[2],test[3],test[4],test[5],test[6])
              : len( test ) == 8 ? func(test[1],test[2],test[3],test[4],test[5],test[6],test[7])
              : func(test[1],test[2],test[3],test[4],test[5],test[6],test[7],test[8]);
        
        assert( value == expected, str("expected: ", expected, "; received: ", value ) );
    }
}
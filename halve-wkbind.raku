use Definitely;

multi infix:«>>=»(Maybe $x, &f --> Maybe) {
    my $msg = "Can't unwrap Maybe in bind (>>=) operation";
    given $x {
        when *.is-something { &f( unwrap($x, $msg) ) }
        default { $x }
    }
}

sub halve(Int $x --> Maybe[Int]) {
    given $x {
        when   * %% 2 { something( $x div 2 ) }
        when ! * %% 2 { nothing(Int) }
    }
}

say (halve 3) >>= &halve;
say (something 32) >>= &halve >>= &halve >>= &halve;
say (halve 3) ~~ None;






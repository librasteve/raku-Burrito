http://williamcotton.com/articles/a-burrito-is-a-monad

There are three approaches to Raku functional chaining here:

1. Monad::Result with custom bind

Custom Apply:
 - match F# intent
 - check burrito > meat for Some / None
 - return function if Some / None if None

```perl6
#  : List(Result M, List) -> Callable
sub infix:«>>=»($burrito, &f) {
    given $burrito {
        when *.is-ok, $ {
            -> $arg= Empty { &f(|($arg, $burrito)) }
        }
        when *.is-error, $ {
            (Monad::Result.error('None'), [])
        }
    }
}
```

2. Monad::Result module bind (or map)

Module bind:
 - checks 

```perl6
# Bind : Result T -> (f : T -> Result U) -> Result U
sub infix:«>>=:»(Monad::Result:D $result, &f --> Monad::Result) {
	return $result if $result.is-error;
	&f($result.unwrap);
}

# Map : Result T -> (f : T -> U) -> Result U
sub infix:«>>=?»(Monad::Result:D $result, &f --> Monad::Result) {
	return $result if $result.is-error;
	Monad::Result::ok(&f($result.unwrap));
}
```

won't work with Burrito types

3. Wikipedia
   https://en.wikipedia.org/wiki/Monad_(functional_programming)#An_example:_Maybe

   return :: a -> M a (often also called unit), which receives a value of type a and wraps it into a monadic value of type M a, and

   bind :: (M a) -> (a -> M b) -> (M b) (typically represented as >>=), which receives a monadic value M a and a function f that accepts values of the base type a. Bind unwraps a, applies f to it, and can process the result of f as a monadic value M b.
   
Monadic Type
   A type (Maybe)
Unit operation
   A type converter (Just(x))
Bind operation
   A combinator for monadic functions ( >>= or .flatMap())

```haskell
halve :: Int -> Maybe Int
halve x
  | even x = Just (x `div` 2)
  | odd x  = Nothing
 -- This code halves x twice. it evaluates to Nothing if x is not a multiple of 4
halve x >>= halve
```

now PR to Definitely module  https://github.com/masukomi/Definitely/pull/3

```perl6
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
```

won't work with "Burrito" types as they have custom structure 


---

In version 2 of this code, called `burrito-feed.raku`, I am inspired by Wambas comment on my post ...

by a little alchemy with function declaration:

```perl6
proto infix:«>>=»($ ,$) is prec(prec => ‘f=’) {*}
multi infix:«>>=»((None $, @), +@ ) { nothing(Meat),[] }
multi infix:«>>=»($burrito, +(&f, +@args)) {
    f( |@args, $burrito )
}

tortilla()
>>= &add-meat, Beef
>>= &add-mission-burrito-ingredients
```

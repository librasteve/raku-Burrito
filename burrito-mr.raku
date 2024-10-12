use Monad::Result;

enum Meat <Chicken Beef Pork Fish Veggie>;

enum Ingredient <Cheese Rice Beans Salsa Guacamole SourCream Lettuce
                 Tomato Onion Cilantro PicoDeGallo>;

sub returnBurrito($meat, @ingredients) {
    $meat, @ingredients
}

sub tortilla {
    returnBurrito(Monad::Result.ok(Veggie), [])
}

sub add-meat($meat, ($, @ingredients)) {
    Monad::Result.ok($meat), @ingredients
}

sub add-ingredient($ingredient, ($meat, @ingredients)) {
    $meat, [$ingredient, |@ingredients]
}

sub add-mission-burrito-ingredients(($meat, @ingredients)) {
    $meat, [Cheese, Rice, Beans, |@ingredients]
}

sub hold-the($ingredient, ($meat, @ingredients)) {
    ($meat, [@ingredients.grep(* != $ingredient)]);
}

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

my \burrito = (((((((
    tortilla()
    >>= &add-meat)(Chicken)
    >>= &add-mission-burrito-ingredients)()
    >>= &hold-the)(Cheese)
    >>= &add-ingredient)(PicoDeGallo)
    >>= &add-ingredient)(Salsa)
    >>= &add-ingredient)(Guacamole)
    >>= &add-ingredient)(SourCream);

say burrito;


#my $thing = (Monad::Result.error('None'), []);
#say ($thing >>= &add-meat);


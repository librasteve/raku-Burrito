use Definitely;

enum Meat <Chicken Beef Pork Fish Veggie>;

enum Ingredient <Cheese Rice Beans Salsa Guacamole SourCream Lettuce
                 Tomato Onion Cilantro PicoDeGallo>;

sub returnBurrito($meat, @ingredients) {
    $meat, @ingredients
}

sub tortilla {
    returnBurrito(something(Veggie), [])
}

sub add-meat($meat, ($, @ingredients)) {
    something($meat), @ingredients
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

multi infix:«>>=»($burrito, &f) {
    given $burrito {
        when   *.so, $ {
            -> $arg=Empty { &f( |($arg, $burrito) ) }
        }
        when ! *.so, $ {
            (nothing(), [])
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

#my $thing = (nothing(), []);
#say ($thing >>= &add-meat).first ~~ None;




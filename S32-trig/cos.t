# WARNING:
# This is a generated file and should not be edited directly.
# look into generate-tests.pl instead

use v6;
use Test;

sub degrees-to-radians($x) {
    $x * (312689/99532) / 180;
}

my @sines = (
    degrees-to-radians(-360) => 0,
    degrees-to-radians(135 - 360) => 1/2*sqrt(2),
    degrees-to-radians(330 - 360) => -0.5,
    degrees-to-radians(0) => 0,
    degrees-to-radians(30) => 0.5,
    degrees-to-radians(45) => 1/2*sqrt(2),
    degrees-to-radians(90) => 1,
    degrees-to-radians(135) => 1/2*sqrt(2),
    degrees-to-radians(180) => 0,
    degrees-to-radians(225) => -1/2*sqrt(2),
    degrees-to-radians(270) => -1,
    degrees-to-radians(315) => -1/2*sqrt(2),
    degrees-to-radians(360) => 0,
    degrees-to-radians(30 + 360) => 0.5,
    degrees-to-radians(225 + 360) => -1/2*sqrt(2),
    degrees-to-radians(720) => 0
);

my @cosines = @sines.map({; $_.key - degrees-to-radians(90) => $_.value });

my @sinhes = @sines.grep({ $_.key < degrees-to-radians(500) }).map({; $_.key =>
                                                (exp($_.key) - exp(-$_.key)) / 2.0 });

my @coshes = @sines.grep({ $_.key < degrees-to-radians(500) }).map({; $_.key =>
                                                (exp($_.key) + exp(-$_.key)) / 2.0 });

class NotComplex is Cool {
    has $.value;

    multi method new(Complex $value is copy) {
        self.bless(*, :$value);
    }

    multi method Numeric() {
        self.value;
    }
}

class DifferentReal is Real {
    has $.value;

    multi method new($value is copy) {
        self.bless(*, :$value);
    }

    multi method Bridge() {
        self.value;
    }
}            



# cos tests

my $iter_count = 0;
for @cosines -> $angle
{
    
    my $desired-result = $angle.value;

    # Num.cos tests -- very thorough
    is_approx($angle.key().cos, $desired-result, 
              "Num.cos - {$angle.key()}");

    # Complex.cos tests -- also very thorough
    my Complex $zp0 = $angle.key + 0.0i;
    my Complex $sz0 = $desired-result + 0i;
    my Complex $zp1 = $angle.key + 1.0i;
    my Complex $sz1 = { (exp($_ * 1i) + exp(-$_ * 1i)) / 2 }($zp1);
    my Complex $zp2 = $angle.key + 2.0i;
    my Complex $sz2 = { (exp($_ * 1i) + exp(-$_ * 1i)) / 2 }($zp2);
    
    is_approx($zp0.cos, $sz0, "Complex.cos - $zp0");
    is_approx($zp1.cos, $sz1, "Complex.cos - $zp1");
    is_approx($zp2.cos, $sz2, "Complex.cos - $zp2");
}

{
    is(cos(Inf), NaN, "cos(Inf) -");
    is(cos(-Inf), NaN, "cos(-Inf) -");
}
        
{
    # Num tests
    is_approx(cos((-7.85398163404734).Num), 0, "cos(Num) - -7.85398163404734");
    is_approx(cos(:x((-5.49778714383314).Num)), 0.707106781186548, "cos(:x(Num)) - -5.49778714383314");
}

{
    # Rat tests
    is_approx((-2.09439510241262).Rat(1e-9).cos, -0.5, "Rat.cos - -2.09439510241262");
    is_approx(cos((-1.57079632680947).Rat(1e-9)), 0, "cos(Rat) - -1.57079632680947");
    is_approx(cos(:x((-1.04719755120631).Rat(1e-9))), 0.5, "cos(:x(Rat)) - -1.04719755120631");
}

{
    # Complex tests
    is_approx(cos((-0.785398163404734 + 2i).Complex), 2.66027408529666 + 2.56457758882432i, "cos(Complex) - -0.785398163404734 + 2i");
    is_approx(cos(:x((0 + 2i).Complex)), 3.76219569108363 + -0i, "cos(:x(Complex)) - 0 + 2i");
}

{
    # Str tests
    is_approx((0.785398163404734).Str.cos, 0.707106781186548, "Str.cos - 0.785398163404734");
    is_approx(cos((1.57079632680947).Str), 0, "cos(Str) - 1.57079632680947");
    is_approx(cos(:x((2.3561944902142).Str)), -0.707106781186548, "cos(:x(Str)) - 2.3561944902142");
}

{
    # NotComplex tests
    is_approx(NotComplex.new(3.14159265361894 + 2i).cos, -3.76219569108363 + 1.05698434049896e-10i, "NotComplex.cos - 3.14159265361894 + 2i");
    is_approx(cos(NotComplex.new(3.92699081702367 + 2i)), -2.66027408521913 + 2.56457758889906i, "cos(NotComplex) - 3.92699081702367 + 2i");
    is_approx(cos(:x(NotComplex.new(4.7123889804284 + 2i))), 1.64464647771967e-10 + 3.62686040784702i, "cos(:x(NotComplex)) - 4.7123889804284 + 2i");
}

{
    # DifferentReal tests
    is_approx(DifferentReal.new(5.23598775603156).cos, 0.5, "DifferentReal.cos - 5.23598775603156");
    is_approx(cos(DifferentReal.new(8.63937979745208)), -0.707106781186548, "cos(DifferentReal) - 8.63937979745208");
    is_approx(cos(:x(DifferentReal.new(10.9955742876663))), 0, "cos(:x(DifferentReal)) - 10.9955742876663");
}


# acos tests

for @cosines -> $angle
{
    
    my $desired-result = $angle.value;

    # Num.acos tests -- thorough
    is_approx($desired-result.Num.acos.cos, $desired-result, 
              "Num.acos - {$angle.key()}");
    
    # Num.acos(Complex) tests -- thorough
    for ($desired-result + 0i, $desired-result + .5i, $desired-result + 2i) -> $z {
        is_approx(cos(acos($z)), $z, 
                  "acos(Complex) - {$angle.key()}");
        is_approx($z.acos.cos, $z, 
                  "Complex.acos - {$angle.key()}");
    }
}
        
{
    # Num tests
    is_approx(acos((0.707106781186548).Num), 0.785398163404734, "acos(Num) - 0.785398163404734");
    is_approx(acos(:x((0.707106781186548).Num)), 0.785398163404734, "acos(:x(Num)) - 0.785398163404734");
}

{
    # Rat tests
    is_approx(((0.707106781186548).Rat(1e-9)).acos, 0.785398163404734, "Rat.acos - 0.785398163404734");
    is_approx(acos((0.707106781186548).Rat(1e-9)), 0.785398163404734, "acos(Rat) - 0.785398163404734");
    is_approx(acos(:x((0.707106781186548).Rat(1e-9))), 0.785398163404734, "acos(:x(Rat)) - 0.785398163404734");
}

{
    # Complex tests
    is_approx(acos((0.785398163404734 + 2i).Complex), 1.22945740853541 - 1.49709293866352i, "acos(Complex) - 1.22945740853541 - 1.49709293866352i");
    is_approx(acos(:x((0.785398163404734 + 2i).Complex)), 1.22945740853541 - 1.49709293866352i, "acos(:x(Complex)) - 1.22945740853541 - 1.49709293866352i");
}

{
    # Str tests
    is_approx(((0.707106781186548).Str).acos, 0.785398163404734, "Str.acos - 0.785398163404734");
    is_approx(acos((0.707106781186548).Str), 0.785398163404734, "acos(Str) - 0.785398163404734");
    is_approx(acos(:x((0.707106781186548).Str)), 0.785398163404734, "acos(:x(Str)) - 0.785398163404734");
}

{
    # NotComplex tests
    is_approx((NotComplex.new(0.785398163404734 + 2i)).acos, 1.22945740853541 - 1.49709293866352i, "NotComplex.acos - 1.22945740853541 - 1.49709293866352i");
    is_approx(acos(NotComplex.new(0.785398163404734 + 2i)), 1.22945740853541 - 1.49709293866352i, "acos(NotComplex) - 1.22945740853541 - 1.49709293866352i");
    is_approx(acos(:x(NotComplex.new(0.785398163404734 + 2i))), 1.22945740853541 - 1.49709293866352i, "acos(:x(NotComplex)) - 1.22945740853541 - 1.49709293866352i");
}

{
    # DifferentReal tests
    is_approx((DifferentReal.new(0.707106781186548)).acos, 0.785398163404734, "DifferentReal.acos - 0.785398163404734");
    is_approx(acos(DifferentReal.new(0.707106781186548)), 0.785398163404734, "acos(DifferentReal) - 0.785398163404734");
    is_approx(acos(:x(DifferentReal.new(0.707106781186548))), 0.785398163404734, "acos(:x(DifferentReal)) - 0.785398163404734");
}

done;

# vim: ft=perl6 nomodifiable

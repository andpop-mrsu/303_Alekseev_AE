<?php

namespace App;

class Fraction
{
    private int $numerator;
    private int $denominator;

    public function __construct(int $numerator, int $denominator)
    {
        if ($denominator <= 0) {
            echo "Знаменатель должен быть больше нуля!";
            exit();
        }

        $this->numerator = $numerator;
        $this->denominator = $denominator;
        $this->reduce();
    }

    private function gcd(int $a, int $b): int
    {
        return $a % $b ? $this->{__FUNCTION__}($b, $a % $b) : $b;
    }

    private function reduce(): void
    {
        $common = $this->gcd($this->numerator, $this->denominator);
        $this->numerator /= abs($common);
        $this->denominator /= abs($common);
    }

    public function getNumer(): int
    {
        return $this->numerator;
    }

    public function getDenom(): int
    {
        return $this->denominator;
    }

    public function add(Fraction $frac): Fraction
    {
        $num = $this->numerator * $frac->denominator + $frac->numerator * $this->denominator;
        $den = $this->denominator * $frac->denominator;

        return new Fraction($num, $den);
    }

    public function sub(Fraction $frac): Fraction
    {
        $num = $this->numerator * $frac->denominator - $frac->numerator * $this->denominator;
        $den = $this->denominator * $frac->denominator;

        return new Fraction($num, $den);
    }

    private function convert(): string
    {
        $integerPart = (int) ($this->numerator / $this->denominator);

        $numerator = $this->numerator % $this->denominator;

        return $integerPart . "'" . abs($numerator) . "/" . $this->denominator;
    }

    public function __toString(): string
    {
        if ($this->denominator < abs($this->numerator)){
            return $this->convert();
        }

        return $this->numerator . "/" . $this->denominator;
    }
}
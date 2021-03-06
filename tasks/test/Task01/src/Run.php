<?php

namespace App\Run;

use App\Fraction;

function runTest()
{
    $m1 = new Fraction(40, 100);
    echo $m1 . "\n";     // 2/5

    $m2 = new Fraction(1, 4);
    $m3 = $m1->add($m2);
    echo $m3 . "\n";      // 13/20

    $m4 = new Fraction(-4, 2);
    $m5 = $m4->sub($m2);
    echo $m5 . "\n";     // -2'1/4

    $m6 = new Fraction(126, 130);
    $m7 = $m1->sub($m6);
    echo $m7 . "\n"; // -37/65

    $m8 = new Fraction(236, 130);
    $m9 = $m7->add($m8);
    echo $m9 . "\n";     // 1'16/65

    echo $m9->getNumer() . "\n"; //81
    echo $m9->getDenom() . "\n"; //65

}

runTest();

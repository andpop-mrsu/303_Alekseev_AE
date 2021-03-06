<?php

namespace App\Tests;

use \PHPUnit\Framework\TestCase;

class FractionTest extends TestCase
{
    public function testReduceFraction()
    {
        $m = new \App\Fraction(40, 100);
        $this->assertEquals(2, $m->getNumer());
        $this->assertEquals(5, $m->getDenom());
    }

    public function testStringRepresentation()
    {
        $m = new \App\Fraction(40, 100);
        $s = $m->__toString();
        $this->assertEquals('2/5', $m->__toString());
    }
}


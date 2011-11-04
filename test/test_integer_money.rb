require 'test_helper'

class TestIntegerMoney < Test::Unit::TestCase
  include AtLinksafe::IntegerMoney

  Pairs =
  [
    [0, "0.0"],
    [0, "0"],
    [0, 0],

    [500, "5.0"],
    [500, "5"],
    [500, 5.00],

    [540, "5.40"],
    [540, "5.40"],
    [540, 5.40],

    [545, "5.445"],

    [545, "5.45"],

    [546, "5.4555555"],
    [546, 5.45555555],

    [6499, "64.99"],

    [6499, 64.99],

    [995, "9.95"],
    [995, "9.95"],
    [995, 9.95],
  ]

  def test_truth
    Pairs.each { |e|
      assert_equal( e[0], dollars_to_cents( cents_to_dollars( dollars_to_cents( e[1] ) ) ) )
    }
  end

  def test_round_to_two
    i = round_to_two( "9.95")
    assert_equal(9.95, i)
  end

end

require 'test_helper'

class TestVariationMaps < Test::Unit::TestCase
  def setup
    states = [["Alabama", "AL"], ["Alaska", "AK"], ["American Samoa", "AS"], ["Arizona", "AZ"], ["Arkansas", "AR"], ["California", "CA"], ["Colorado", "CO"], ["Connecticut", "CT"], ["Delaware", "DE"], ["District of Columbia", "DC"], ["Federated States of Micronesia", "FM"], ["Florida", "FL"], ["Georgia", "GA"], ["Guam", "GU"], ["Hawaii", "HI"], ["Idaho", "ID"], ["Illinois", "IL"], ["Indiana", "IN"], ["Iowa", "IA"], ["Kansas", "KS"], ["Kentucky", "KY"], ["Louisiana", "LA"], ["Maine", "ME"], ["Marshall Islands", "MH"], ["Maryland", "MD"], ["Massachusetts", "MA"], ["Michigan", "MI"], ["Minnesota", "MN"], ["Mississippi", "MS"], ["Missouri", "MO"], ["Montana", "MT"], ["Nebraska", "NE"], ["Nevada", "NV"], ["New Hampshire", "NH"], ["New Jersey", "NJ"], ["New Mexico", "NM"], ["New York", "NY"], ["North Carolina", "NC"], ["North Dakota", "ND"], ["Northern Mariana Islands", "MP"], ["Ohio", "OH"], ["Oklahoma", "OK"], ["Oregon", "OR"], ["Palau", "PW"], ["Pennsylvania", "PA"], ["Puerto Rico", "PR"], ["Rhode Island", "RI"], ["South Carolina", "SC"], ["South Dakota", "SD"], ["Tennessee", "TN"], ["Texas", "TX"], ["Utah", "UT"], ["Vermont", "VT"], ["Virgin Islands", "VI"], ["Virginia", "VA"], ["Washington", "WA"], ["West Virginia", "WV"], ["Wisconsin", "WI"], ["Wyoming", "WY"], ["Armed Forces Africa", "AE"], ["Armed Forces Americas", "AA"], ["Armed Forces Canada", "AE"], ["Armed Forces Europe", "AE"], ["Armed Forces Middle East", "AE"], ["Armed Forces Pacific", "AP"]]
    @variations = AtLinksafe::VariationMaps.new
    states.each { |e|
      @variations.add( e[1], [ e[0]] )
    }
  end

  def test_truth
    state = @variations.find_by_code('MA')
    assert_kind_of( AtLinksafe::VariationMap, state )
    state_1 = @variations.find('MA')
    assert_same(state, state_1)
    assert(state.code == 'MA')
    assert(state.code != 'MO')

    state.add('Mass', 'Mass.')
    state_2 = @variations.find('Mass')
    assert(state.code == 'MA')
    assert_same(state, state_2)

    state = @variations.find('mass')
    assert(state.code == 'MA')
    state = @variations.find('MASS.')
    assert(state.code == 'MA')
    assert_equal("#{state}", 'MA')

    assert_nothing_raised { @variations.find(nil) }
  end
end

require 'test_helper'

class TestProfileElement < Test::Unit::TestCase

  def test_truth
    claims = AtLinksafe::ProfileElement.getClaims
    assert_kind_of(Array, claims)
    assert( claims.include?(:ppid) )
    assert_not_nil( AtLinksafe::ProfileElement.find_by_card(:email_address) )
    assert_equal(:email, AtLinksafe::ProfileElement.card_to_profile_element(:email_address) )
    assert_equal(:email_address, AtLinksafe::ProfileElement.profile_to_card_element(:email) )
    assert_not_nil( AtLinksafe::ProfileElement.find_by_profile(:email) )
    assert_nil(AtLinksafe::ProfileElement.card_to_profile_element(:email) )
    assert_nil(AtLinksafe::ProfileElement.profile_to_card_element(:email_address) )

    iname = AtLinksafe::ProfileElement.find_by_card(:iname)
    assert(iname.protected?)
  end

end

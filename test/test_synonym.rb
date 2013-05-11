require 'test_helper'
require 'at_linksafe/synonym'

class TestSynonym < Test::Unit::TestCase
  
  def test_equals_mary
    names = [
      '=mary',
      '=mary/',
      "#{ProxyResolver}/=mary",
      "xri://=mary",
      "xri://=mary/",
      "http://xri.net/=mary",
      "http://openid.xri.net/=mary",
    ]
    names.each { |e| assert_equal('=mary', AtLinksafe::Synonym.normalize(e)) }
  end

  def test_at_llli_star_mike
    names = [
      '@llli*mike',
      '@llli*mike/',
       "#{ProxyResolver}/@llli*mike",
      'http://xri.net/@llli*mike',
      'https://xri.net/@llli*mike',
      'xri://@llli*mike',
      'xri.net/@llli*mike',
      'openid.xri.net/@llli*mike'
    ]
    names.each { |e| assert_equal('@llli*mike', AtLinksafe::Synonym.normalize(e)) }
  end

  def test_blank
    assert_equal('', AtLinksafe::Synonym.normalize('')) 
  end

end

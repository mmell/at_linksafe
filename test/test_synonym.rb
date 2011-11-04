require 'test_helper'

class TestSynonym < Test::Unit::TestCase
  AtLinksafe::Synonym::PROXY_RESOLVER = 'http://proxy.example.com'

  def test_the_truth
    names = [
      '=mary',
      '=mary/',
      "#{AtLinksafe::Synonym::PROXY_RESOLVER}/=mary",
      "xri://=mary",
      "xri://=mary/",
      "http://xri.net/=mary",
      "http://openid.xri.net/=mary"
    ]
    names.each { |e| assert_equal('=mary', AtLinksafe::Synonym.normalize(e)) }
  end
end

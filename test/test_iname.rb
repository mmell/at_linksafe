require 'test_helper'

class TestIname < Test::Unit::TestCase

  def test_invalids
    str = '=mary.1'
    iname = AtLinksafe::Iname.new(str)
    assert( iname.valid? )

    str = '@llli*test.3'
    iname = AtLinksafe::Iname.new(str)
    assert( iname.valid? )

    str = '@llli*m.ary'
    iname = AtLinksafe::Iname.new(str)
    assert( iname.valid? )

    str = '@llli*ma._ry'
    iname = AtLinksafe::Iname.new(str)
    assert( !iname.valid? )

    str = '@llli*ma__ry'
    iname = AtLinksafe::Iname.new(str)
    assert( !iname.valid? )
  end

  def test_truth
    str = '=mary'
    iname = AtLinksafe::Iname.new(str)
    assert( iname.valid? )
    assert_equal('=', iname.parent)
    assert_equal('mary', iname.iname)
    assert_equal('mary', iname.delegated_name)
    assert_equal(str, "#{iname}")

    str = '=mary*mike'
    iname = AtLinksafe::Iname.new(str)
    assert( iname.valid? )
    assert_equal('=mary', iname.parent)
    assert_equal('mike', iname.iname)
    assert_equal('mike', iname.delegated_name)
    assert_equal(str, "#{iname}")

    assert(!AtLinksafe::Iname.valid?('mary'))
    assert(!AtLinksafe::Iname.valid?('@'))
    assert(!AtLinksafe::Iname.valid?('mary*mike'))
    assert(AtLinksafe::Iname.is_inumber?('=!mary'))
    assert(!AtLinksafe::Iname.is_inumber?('=mary'))

    str = '@llli'
    iname = AtLinksafe::Iname.new(str)
    assert( iname.valid? )
    assert_equal('@', iname.parent)
    assert_equal('llli', iname.iname)
    assert_equal('llli', iname.delegated_name)
    assert_equal(str, "#{iname}")

    str = '@llli*mary'
    iname = AtLinksafe::Iname.new(str)
    assert( iname.valid? )
    assert_equal('@llli', iname.parent)
    assert_equal('mary', iname.iname)
    assert_equal('mary', iname.delegated_name)
    assert_equal(str, "#{iname}")

    str = '@llli*ma.ry'
    iname = AtLinksafe::Iname.new(str)
    assert( iname.valid? )
  end

end

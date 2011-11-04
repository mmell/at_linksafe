module AtLinksafe
  # a standalone class
  #  for string manipulations and validation
  # For UNICODE See http://www.inames.net/lang/
  class Iname
    IllegalInameCharsRE = Regexp.escape(' !"#$%&\'()*+,/:;<=>?@[\]^`{|}~_' )
    ValidInameFragmentRE = Regexp.new( /[^A-Z#{IllegalInameCharsRE}\-\.][^A-Z#{IllegalInameCharsRE}]*[^A-Z#{IllegalInameCharsRE}\-\.]/ )
    ValidInameRE1 = Regexp.new( /^[=@]\*?#{ValidInameFragmentRE}(\*#{ValidInameFragmentRE})*$/ )
    NotValidSegmentRE1 = Regexp.new( /[-\.]{2,}/ )
    NotValidSegmentRE2 = Regexp.new( /\A[-\.]/ )
    NotValidSegmentRE3 = Regexp.new( /[-\.]\z/ )
    Sep = '*'

    attr_accessor :parent, :iname, :errors
    def initialize(parent, iname=nil)
      @errors = []
      @parent = parent.strip
      @errors << "The base part of the iname appears to be invalid." and return false unless AtLinksafe::Iname.valid?(@parent) or GCS.include?(@parent)
      if iname.nil?
        parts = Iname.split(@parent)
        if parts.size > 1 # @parent is the minimum
          @iname = parts.pop
          @parent = Iname.join( *parts )
        else
          @iname = '' # @parent is unchanged
        end
      else
        @iname = iname.strip
      end
    end
    alias_method :delegated_name, :iname
    alias_method :segment, :iname

    def sep
      Iname::Sep
    end

    def compose
      Iname.join( @parent, @iname )
    end

    def to_s
      compose
    end

    def ok?
      @errors.empty?
    end

    def valid?
      Iname.valid?(self.compose)
    end

    def segments
      arr = Iname.split(self.compose)
      gcs = arr.shift
      arr[0] = gcs + arr[0]
      arr
    end

    def self.valid?(s)
      if (s =~ ValidInameRE1)
        self.split(s).each { |e|
          return false if ( e =~ NotValidSegmentRE1 or  e =~ NotValidSegmentRE2 or e =~ NotValidSegmentRE3)
        }
        s.unpack('U*').find_all {|e|
          e > 255 or
          (0...42).include?(e) or
          (123...192).include?(e) or
          [43,44,47,58,59,60,62,63,91,92,93,94,96,215,247].include?(e)
          }.empty?
      else
        false
      end
    end

    def self.gsub_invalid_fragment_chars(s, replacement_char = 46) # 46 is '.'
      # unpack( U* ) returns UTF-8 characters as unsigned integers
      # see http://en.wikipedia.org/wiki/ASCII
      s.unpack('U*').map { |e|
        if (65..90).include?(e)
          e + 32 # downcase
        elsif (
          e > 255 or
          (0..44).include?(e) or
          (123...192).include?(e) or
          [47,58,59,60,62,63,64,91,92,93,94,96,215,247].include?(e)
          )
          replacement_char
        else
          e
        end
      }.pack('U*').gsub(NotValidSegmentRE1, '.').gsub(NotValidSegmentRE2, '').gsub(NotValidSegmentRE3, '')
    end

    def self.join( *parts )
      s = ''
      parts.delete_if { |e| e.nil? or e.empty? }
      s << parts.shift
      unless parts.empty?
        s << '*' unless GCS.include?(s)
        s << parts.join('*')
      end
      s
    end

    def self.split( composed_iname ) # FIXME this may choke on unicode chars or cause choking in callers...
      parts = composed_iname.strip.split(/\*/)
      parts.delete_if { |e| e.empty? }
      first_seg = parts.shift
      parts.insert(0, first_seg[0,1], first_seg[1, first_seg.length] ) # make the GCS character a segment whose length == 1
      parts
    end

    def self.is_inumber?(s)
      s =~ /^(xri:\/\/)?[@=]!/
    end

  end

end

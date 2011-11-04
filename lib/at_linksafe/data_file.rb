module AtLinksafe
  module DataFile
    module Helper
      def fileupload2lines( upload_sym = :file_upload ) 
        return nil unless params[upload_sym] and params[upload_sym].size > 0
        file2lines( params[upload_sym] )
      end
      def filepath2lines( path ) 
        f = File.new(path)
        return nil unless f.is_file?
        file2lines( f )
      end
      def file2lines( file_spec ) 
        lines = ''
        file_spec.read(nil, lines)
        lines.gsub("\r\n", "\n").gsub("\r", "\n").split(/\n/)
      end
      def tabs2array( line )
        line.split("\t").map { |e| e.strip.gsub(/[- ]/, '_') } # db fields use underscores
      end
      def spaces2array( line )
        line.split(" ").map { |e| e.strip.gsub(/[-]/, '_') } # db fields use underscores
      end
      def tabs2hash(keys, line)
        line = tabs2array( line ) unless line.class.to_s == 'Array'
        hsh = {}  
        for i in 0..keys.size
          hsh[keys[i]] = line[i].strip if line[i]
        end
        hsh
      end
      def read(path)
        lines = ''
        File.new( path, 'r' ).read(nil, lines)
        lines
      end
      def writer(path)
        out = File.new( path, 'a' )
        class <<out
          def append(s)
            self << s + "\n"
          end
        end
        out
      end
      module_function :read 
      module_function :writer
    end


    class Iterator
=begin
  Iterator parses a data file. 
  Iterator#next_line returns a hash of keys and line values
=end
      include Helper
      attr_reader :required_keys, :keys
      attr_accessor :ix

      def initialize(required_keys, sep, path)
        @required_keys = required_keys
        @sep = sep
        @lines = file2lines( File.new( path, 'r' ) )
        @ls = LineSplitter.new( @sep )
        @keys = @ls.line2array( @lines[0] )
        @ix = 0
      end

      def file_valid?
        @required_keys.each { |e| return false unless @keys.include?(e) }
        true
      end

      def line(ix = nil)
        ix ||= @ix
        return nil if @lines[ix].nil? or @lines[ix].strip.empty?
        @lines[ix]
      end

      def next_line
        @ix +=1
        return nil if @lines[@ix].nil? or @lines[@ix].strip.empty?
        @ls.line2hash(@keys, @lines[@ix])
      end
      alias_method :next, :next_line
      
      def reset
        @ix = 0
      end
      
      def each
        reset
        while( n = self.next_line )
          yield n
        end
      end

      def to_array
        arr = []
        self.each { |e| arr << e } 
        arr
      end
      
    end
    
    class LineSplitter
=begin
  LineSplitter splits lines on @sep
  LineSplitter#line2hash returns a hash of keys and line values
=end
      def initialize(sep = "\t" )
        @sep = sep
      end
      def line2array( line )
        line.split(@sep).map { |e| e.strip }
      end
      def line2hash(keys, line)
        line = line2array( line ) unless line.class.to_s == 'Array'
        hsh = Line.new(nil)
        for i in 0..keys.size
          hsh[keys[i]] = line[i].strip if line[i]
        end
        hsh
      end
      class Line < Hash
        def +(other)
          self.inspect + other
        end
        def join(keys, sep)
          keys.map {|e| self[e] }.join(sep)
        end
      end
    end
  end
end

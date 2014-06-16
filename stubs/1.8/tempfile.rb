
require_relative './delegate'
require_relative './tmpdir'
require 'thread'


class Tempfile < File
  include Dir::Tmpname

  def initialize(basename, *rest)
    if block_given?
      warn "Tempfile.new doesn't call the given block."
    end
    @data = []
    @clean_proc = Remover.new(@data)
    ObjectSpace.define_finalizer(self, @clean_proc)

    ::Dir::Tmpname.create(basename, *rest) do |tmpname, n, opts|
      mode = File::RDWR|File::CREAT|File::EXCL
      perm = 0600
      if opts
        mode |= opts.delete(:mode) || 0
        opts[:perm] = perm
        perm = nil
      else
        opts = perm
      end
      @data[1] = @tmpfile = File.open(tmpname, mode, opts)
      @data[0] = @tmpname = tmpname
      @mode = mode & ~(File::CREAT|File::EXCL)
      perm or opts.freeze
      @opts = opts
    end

    super(@tmpfile)
  end

  def open
    @tmpfile.close if @tmpfile
    @tmpfile = File.open(@tmpname, @mode, @opts)
    @data[1] = @tmpfile
    __setobj__(@tmpfile)
  end

  def _close    # :nodoc:
    begin
      @tmpfile.close if @tmpfile
    ensure
      @tmpfile = nil
      @data[1] = nil if @data
    end
  end
  protected :_close

  def close(unlink_now=false)
    if unlink_now
      close!
    else
      _close
    end
  end

  def close!
    _close
    unlink
  end

  def unlink
    return unless @tmpname
    begin
      File.unlink(@tmpname)
    rescue Errno::ENOENT
    rescue Errno::EACCES
      return
    end

    @data[0] = @data[1] = nil
    @tmpname = nil
    ObjectSpace.undefine_finalizer(self)
  end
  alias delete unlink

  def path
    @tmpname
  end

  def size
    if @tmpfile
      @tmpfile.flush
      @tmpfile.stat.size
    elsif @tmpname
      File.size(@tmpname)
    else
      0
    end
  end
  alias length size

  def inspect
    "#<#{self.class}:#{path}>"
  end

  class Remover
    def initialize(data)
      @pid = $$
      @data = data
    end

    def call(*args)
      return if @pid != $$

      path, tmpfile = *@data

      STDERR.print "removing ", path, "..." if $DEBUG

      tmpfile.close if tmpfile

      if path
        begin
          File.unlink(path)
        rescue Errno::ENOENT
        end
      end

      STDERR.print "done\n" if $DEBUG
    end
  end


  class << self
    def open(*args)
      tempfile = new(*args)

      if block_given?
        begin
          yield(tempfile)
        ensure
          tempfile.close
        end
      else
        tempfile
      end
    end
  end

end

def Tempfile.create(basename, *rest)
  tmpfile = nil
  Dir::Tmpname.create(basename, *rest) do |tmpname, n, opts|
    mode = File::RDWR|File::CREAT|File::EXCL
    perm = 0600
    if opts
      mode |= opts.delete(:mode) || 0
      opts[:perm] = perm
      perm = nil
    else
      opts = perm
    end
    tmpfile = File.open(tmpname, mode, opts)
  end
  if block_given?
    begin
      yield tmpfile
    ensure
      tmpfile.close if !tmpfile.closed?
      File.unlink tmpfile
    end
  else
    tmpfile
  end
end

if __FILE__ == $0
#  $DEBUG = true
  f = Tempfile.new("foo")
  f.print("foo\n")
  f.close
  f.open
  p f.gets # => "foo\n"
  f.close!
end

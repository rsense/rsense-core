
require_relative './delegate'
require_relative './tmpdir'
require 'thread'


class Tempfile
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


ALT_SEPARATOR = ''
PATH_SEPARATOR = ''
SEPARATOR = ''
Separator = ''

include File::Constants

##% self.atime(String or IO) -> Time
def self.atime(filename) Time.new end
##% self.basename(String, ?String) -> String
def self.basename(filename, suffix = '') '' end
##% self.blockdev?(String or IO) -> Boolean
def self.blockdev?(path) BOOLEAN end
##% self.chardev?(String or IO) -> Boolean
def self.chardev?(path) BOOLEAN end
##% self.chmod(Integer, *String) -> Integer
def self.chmod(mode, *filename) 0 end
##% self.chown(Integer, Integer, *String) -> Integer
def self.chown(owner, group, *filename) 0 end
##% self.ctime(String or IO) -> Time
def self.ctime(filename) Time.new end
##% self.delete(*String) -> Integer
def self.delete(*filename) 0 end
##% self.unlink(*String) -> Integer
def self.unlink(*filename) 0 end
##% self.directory?(String or IO) -> Boolean
def self.directory?(path) BOOLEAN end
##% self.dirname(String) -> String
def self.dirname(filename) '' end
##% self.executable?(String or IO) ->Boolean
def self.executable?(path) BOOLEAN end
##% self.executable_real?(String or IO) ->Boolean
def self.executable_real?(path) BOOLEAN end
##% self.exist?(String or IO) -> Boolean
def self.exist?(path) BOOLEAN end
##% self.exists?(String or IO) -> Boolean
def self.exists?(path) BOOLEAN end
##% self.expand_path(String, ?String) -> String
def self.expand_path(path, default_dir = '.') '' end
##% self.extname(String) -> String
def self.extname(filename) '' end
##% self.file?(String or IO) -> Boolean
def self.file?(path) BOOLEAN end
##% self.fnmatch(String, String, ?Integer) -> Boolean
def self.fnmatch(pattern, path, flags = 0) BOOLEAN end
##% self.fnmatch?(String, String, ?Integer) -> Boolean
def self.fnmatch?(pattern, path, flags = 0) BOOLEAN end
##% self.ftype(String) -> String
def self.ftype(filename) '' end
##% self.grpowned?(String or IO) -> Boolean
def self.grpowned?(filename) BOOLEAN end
##% self.identical?(String or IO, String or IO) -> Boolean
def self.identical?(filename1, filename2) BOOLEAN end
##% self.join(*String) -> String
def self.join(*item) '' end
##% self.lchmod(Integer, *String) -> Integer
def self.lchmod(mode, *filename) 0 end
##% self.lchown(Integer, Integer, *String) -> Integer
def self.lchown(owner, group, *filename) 0 end
##% self.link(String, String) -> Integer
def self.link(old, new) 0 end
##% self.lstat(String) -> File::Stat
def self.lstat(filename) File::Stat.new('') end
##% self.mtime(String or IO) -> Time
def self.mtime(filename) Time.new end
##% self.new(String or Integer, ?a, ?Integer) -> File
def self.new(path, mode = 'r', perm = 0666) File.new('') end
##% self.open(String or Integer, ?a, ?Integer) -> File
##% self.open(String or Integer, ?a, ?Integer) {File -> a} -> a
def self.open(path, mode = 'r', perm = 0666) File.new('') end
##% self.owned?(String or IO) -> Boolean
def self.owned?(path) BOOLEAN end
##% self.pipe?(String or IO) -> Boolean
def self.pipe?(path) BOOLEAN end
##% self.readable?(String or IO) -> Boolean
def self.readable?(path) BOOLEAN end
##% self.readable_real?(String or IO) -> Boolean
def self.readable_real?(path) BOOLEAN end
##% self.readlink(String) -> String
def self.readlink(path) '' end
##% self.rename(String, String) -> Integer
def self.rename(from, to) 0 end
##% self.setgid?(String or IO) -> Boolean
def self.setgid?(path) BOOLEAN end
##% self.setuid?(String or IO) -> Boolean
def self.setuid?(path) BOOLEAN end
##% self.size(String or IO) -> Integer
def self.size(path) 0 end
##% self.size?(String or IO) -> Boolean
def self.size?(path) BOOLEAN end
##% self.socket?(String or IO) -> Boolean
def self.socket?(path) BOOLEAN end
##% self.split(String) -> (String, String)
def self.split(pathname) ['', ''] end
##% self.stat(String) -> File::Stat
def self.stat(filename) File::Stat.new('') end
##% self.sticky?(String or IO) -> Boolean
def self.sticky?(path) BOOLEAN end
##% self.symlink(String, String) -> Integer
def self.symlink(old, new) 0 end
##% self.symlink?(String or IO) -> Boolean
def self.symlinky?(path) BOOLEAN end
##% self.truncate(String, Integer) -> Integer
def self.truncate(path, length) 0 end
##% self.umask(?Integer) -> Integer
def self.umask(umask = 0) 0 end
##% self.utime(Time or Integer, Time or Integer, *String) -> Integer
def self.utime(atime, mtime, *filename) 0 end
##% self.writable?(String or IO) -> Boolean
def self.writable?(path) BOOLEAN end
##% self.writable_real?(String or IO) -> Boolean
def self.writable_real?(path) BOOLEAN end
##% self.zero?(String or IO) -> Boolean
def self.zero?(path) BOOLEAN end

##% atime() -> Time
def atime() Time.new end
##% chmod(Integer) -> Integer
def chmod(mode) 0 end
##% chown(Integer, Integer) -> Integer
def chown(owner, group) 0 end
##% ctime() -> Time
def ctime() Time.new end
##% flock(Integer) -> Integer or FalseClass
def flock(operation) 0 || false end
##% lstat() -> File::Stat
def lstat() File::Stat.new('') end
##% mtime() -> Time
def mtime() Time.new end
##% path() -> String
def path() '' end
##% truncate(Integer) -> Integer
def truncate(length) 0 end


##% self.new(Integer, ?a) -> IO
def self.new(fd, mode = 'r') IO.new(0) end
##% self.for_fd(Integer, ?a) -> IO
def self.for_fd(fd, mode = 'r') IO.new(0) end
##% self.open(Integer, ?a) -> IO
##% self.open(Integer, ?a) {IO -> b} -> b
def self.open(fd, mode = 'r') IO.new(0) end
##% self.foreach(String, ?String) {String -> ?} -> nil
##% self.foreach(String, ?String) -> Enumerator<nil, String>
def self.foreach(path, rs = $/) yield ''; nil end
##% self.pipe() -> (IO, IO)
def self.pipe() [IO.new(0), IO.new(0)] end
##% self.popen(String, ?a) -> IO
##% self.popen(String, ?a) {IO -> b} -> b
def self.popen(command, mode = 'r') IO.new(0) end
##% self.read(String, ?Integer, ?Integer) -> String
def self.read(path, length = nil, offset = 0) '' end
##% self.readlines(String, ?String) -> Array<String>
def self.readlines(path, rs = $/) [''] end
##% self.select(Array<IO>, ?Array<IO>, ?Array<IO>, ?Integer) -> (Array<IO>, Array<IO>, Array<IO>)
def self.select(reads, writes = [], excepts = [], timeout = nil) [[IO.new(0)], [IO.new(0)], [IO.new(0)]] end
##% self.sysopen(String, ?a, ?Integer) -> Integer
def self.sysopen(path, mode = 'r', perm = 0666) 0 end

# FIXME to_s
##% "<<"(a) -> self
def <<(object) self end
##% binmode() -> self
def binmode() self end
##% bytes() -> Enumerator<self, Fixnum>
def bytes() Enumerator.new end
##% each_char() {Fixnum -> ?} -> self
##% each_char() -> Enumerator<self, Fixnum>
def each_char() yield 0; self end
alias :chars :each_char
##% clone() -> IO
def clone() self end
alias :dup :clone
##% close() -> nil
def close() end
##% close_read() -> nil
def close_read() end
##% close_write() -> nil
def close_write() end
##% closed?() -> Boolean
def closed?() BOOLEAN end
##% each(?String) {String -> ?} -> self
##% each(?String) -> Enumerator<self, String>
def each(rs = $/) yield ''; self end
alias :each_line :each
##% each_byte() {Fixnum -> ?} -> self
##% each_byte() -> Enumerator<self, Fixnum>
def each_byte() yield 0; self end
##% eof() -> Boolean
def eof() BOOLEAN end
alias :eof? :eof
##% fcntl(Integer, ?(Integer or String or Boolean)) -> Integer
def fcntl(cmd, arg = 0) 0 end
##% fileno() -> Integer
def fileno() 0 end
alias :to_i :fileno
##% flush() -> self
def flush() self end
##% fsync() -> Integer
def fsync() 0 end
##% getbyte() -> Fixnum
def getbyte() 0 end
##% getc() -> Fixnum
def getc() 0 end
##% gets(?String) -> String
def gets(rs = $/) '' end
##% ioctl(Integer, ?(Integer or String or Boolean)) -> Integer
def ioctl(cmd, arg = 0) 0 end
##% isatty() -> Boolean
def isatty() BOOLEAN end
alias :tty? :isatty
##% lineno() -> Integer
def lineno() 0 end
##% lineno=(Integer) -> nil
def lineno=(number) end
##% lines(?String) -> Enumerator<self, String>
def lines(rs = $/) Enumerator.new end
##% pid() -> Integer
def pid() 0 end
##% pos() -> Integer
alias :tell :pos
##% pos=(Integer) -> Integer
def pos=(n) end
##% print(*a) -> nil
def print(*arg) end
##% printf(String, *a) -> nil
def printf(format, *arg) end
##% putc<c | c <= Integer>(c) -> c
def putc(ch) ch end
##% puts(*a) -> nil
def puts(*obj) end
##% read(?Integer, ?String) -> String
def read(length = nil, outbuf = '') '' end
##% read_nonblock(Integer, ?String) -> String
def read_nonblock(maxlen, outbuf = '') '' end
##% readbyte() -> Fixnum
def readbyte() 0 end
##% readchar() -> Fixnum
def readchar() 0 end
##% readline(?String) -> String
def readline(rs = $/) '' end
##% readlines(?String) -> Array<String>
def readlines(rs = $/) [''] end
##% readpartial(?Integer, ?String) -> String
def readpartial(maxlen, outbuf = '') '' end
##% reopen(IO) -> self
##% reopen(String, ?a) -> self
def reopen(*) self end
##% rewind() -> Integer
def rewind() 0 end
##% seek(Integer, ?Fixnum) -> Fixnum
def seek(offset, whence = IO::SEEK_SET) 0 end
##% stat() -> File::Stat
def stat() File::Stat.new('') end
##% sync() -> Boolean
def sync() BOOLEAN end
##% sync=(Boolean) -> Boolean
def sync=(newstate) newstate end
##% sysread(Integer, ?String) -> String
def sysread(maxlen, outbuf = '') '' end
##% sysseek(Integer, ?Fixnum) -> Fixnum
def sysseek(offset, whence = IO::SEEK_SET) 0 end
# FIXME to_s
##% syswrite(a) -> Integer
def syswrite(string) 0 end
##% to_io() -> self
def to_io() self end
##% ungetc(a) -> nil
def ungetc(char) end
# FIXME to_s
##% write(a) -> Integer
def write(str) 0 end
# FIXME to_s
##% write_nonblock(a) -> Integer
def write_nonblock(str) 0 end

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

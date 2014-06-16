require_relative './etc'

module FileUtils
  def self.private_module_function(name)   #:nodoc:
    module_function name
    private_class_method name
  end

  OPT_TABLE = {}

  def cd(dir, options);Dir.chdir(dir, &block);end
  alias chdir cd
  module_function :chdir

  OPT_TABLE['cd']    =
  OPT_TABLE['chdir'] = [:verbose]

  def uptodate?(new, old_list)
    return false unless File.exist?(new)
    new_time = File.mtime(new)
    old_list.each do |old|
      if File.exist?(old)
        return false unless new_time > File.mtime(old)
      end
    end
    true
  end
  module_function :uptodate?

  def pwd();""end
  alias getwd pwd
  module_function :getwd

  def mkdir(dir, options);[""];end
  def mkdir_p(dir, options);[""];end
  alias mkpath    mkdir_p
  alias makedirs  mkdir_p
  module_function :mkpath
  module_function :makedirs

  OPT_TABLE['mkdir_p']  =
  OPT_TABLE['mkpath']   =
  OPT_TABLE['makedirs'] = [:mode, :noop, :verbose]

  def rmdir(dir, options);[""];end
  OPT_TABLE['rmdir'] = [:parents, :noop, :verbose]

  def ln(list, destdir, options);0;end
  alias link ln
  module_function :link

  OPT_TABLE['ln']   =
  OPT_TABLE['link'] = [:force, :noop, :verbose]


  def ln_s(list, destdir, options);0;end

  alias symlink ln_s
  module_function :symlink

  OPT_TABLE['ln_s']    =
  OPT_TABLE['symlink'] = [:force, :noop, :verbose]

  def ln_sf(src, dest, options);0;end
  OPT_TABLE['ln_sf'] = [:noop, :verbose]

  def cp(list, dir, options);nil;end
  def cp_r(src, dest, options);nil;end

  alias copy cp
  module_function :copy

  OPT_TABLE['cp']   =
  OPT_TABLE['copy'] = [:preserve, :noop, :verbose]

  def copy_entry(src, dest, preserve = false, dereference_root = false, remove_destination = false)
    Entry_.new(src, nil, dereference_root).wrap_traverse(proc do |ent|
      destent = Entry_.new(dest, ent.rel, false)
      File.unlink destent.path if remove_destination && File.file?(destent.path)
      ent.copy destent.path
    end, proc do |ent|
      destent = Entry_.new(dest, ent.rel, false)
      ent.copy_metadata destent.path if preserve
    end)
  end
  module_function :copy_entry

  def copy_file(src, dest, preserve = false, dereference = true)
    ent = Entry_.new(src, nil, dereference)
    ent.copy_file dest
    ent.copy_metadata dest if preserve
  end
  module_function :copy_file

  def copy_stream(src, dest)
    IO.copy_stream(src, dest)
  end
  module_function :copy_stream


  def mv(src, dest, options);0;end
  alias move mv
  module_function :move

  OPT_TABLE['mv']   =
  OPT_TABLE['move'] = [:force, :noop, :verbose, :secure]

  def rename_cannot_overwrite_file?   #:nodoc:
    /cygwin|mswin|mingw|bccwin|emx/ =~ RUBY_PLATFORM
  end
  private_module_function :rename_cannot_overwrite_file?


  def rm(list, options);[""];end
  def rm_r(list, options);[""];end
  def rm_rf(list, options);[""];end

  alias remove rm
  module_function :remove

  OPT_TABLE['rm']     =
  OPT_TABLE['remove'] = [:force, :noop, :verbose]

  alias safe_unlink rm_f
  module_function :safe_unlink

  OPT_TABLE['rm_f']        =
  OPT_TABLE['safe_unlink'] = [:noop, :verbose]

  alias rmtree rm_rf
  module_function :rmtree

  OPT_TABLE['rm_rf']  =
  OPT_TABLE['rmtree'] = [:noop, :verbose, :secure]

  def remove_entry_secure(path, force = false);[""];end

  def remove_entry(path, force = false)
    Entry_.new(path).postorder_traverse do |ent|
      begin
        ent.remove
      rescue
        raise unless force
      end
    end
  rescue
    raise unless force
  end
  module_function :remove_entry

  def remove_file(path, force = false)
    Entry_.new(path).remove_file
  rescue
    raise unless force
  end
  module_function :remove_file

  def remove_dir(path, force = false)
    remove_entry path, force   # FIXME?? check if it is a directory
  end
  module_function :remove_dir

  def install(src, dest, options = {});nil;end

  def compare_file(a, b)
    return false unless File.size(a) == File.size(b)
    File.open(a, 'rb') {|fa|
      File.open(b, 'rb') {|fb|
        return compare_stream(fa, fb)
      }
    }
  end
  module_function :compare_file

  alias identical? compare_file
  alias cmp compare_file
  module_function :identical?
  module_function :cmp

  def compare_stream(a, b)
    bsize = fu_stream_blksize(a, b)
    sa = ""
    sb = ""
    begin
      a.read(bsize, sa)
      b.read(bsize, sb)
      return true if sa.empty? && sb.empty?
    end while sa == sb
    false
  end
  module_function :compare_stream

  def chmod(mode, list, options);[""];end
  OPT_TABLE['chmod'] = [:noop, :verbose]

  def chmod_R(mode, list, options);[""];end
  OPT_TABLE['chmod_R'] = [:noop, :verbose, :force]

  def chown(user, group, list, options);[""];end
  OPT_TABLE['chown'] = [:noop, :verbose]

  def chown_R(user, group, list, options);[""];end
  OPT_TABLE['chown_R'] = [:noop, :verbose, :force]

  def touch(list, options);[""];end
  OPT_TABLE['touch'] = [:noop, :verbose, :mtime, :nocreate]

  module_function :pwd
  module_function :getwd
  module_function :cd
  module_function :mkdir
  module_function :mkdir_p
  module_function :rmdir
  module_function :ln
  module_function :ln_s
  module_function :ln_sf
  module_function :cp
  module_function :cp_r
  module_function :mv
  module_function :rm
  module_function :remove
  module_function :rm_f
  module_function :rm_r
  module_function :rm_rf
  module_function :chmod
  module_function :chmod_R
  module_function :chown
  module_function :chown_R
  module_function :touch

  def remove_tailing_slash(dir)
    dir == '/' ? dir : dir.chomp(?/)
  end

  private_module_function :remove_tailing_slash

  def fu_mkdir(path, mode)   #:nodoc:
    path = remove_tailing_slash(path)
    if mode
      Dir.mkdir path, mode
      File.chmod mode, path
    else
      Dir.mkdir path
    end
  end

  private_module_function :fu_mkdir

  def user_mask(target);1;end
  private_module_function :user_mask

  def apply_mask(mode, user_mask, op, mode_mask);1;end
  private_module_function :apply_mask

  def symbolic_modes_to_i(mode_sym, path);1;end
  private_module_function :symbolic_modes_to_i

  def fu_mode(mode, path);1;end
  private_module_function :fu_mode

  def mode_to_s(mode);"1";end
  private_module_function :mode_to_s

  def fu_get_uid(user);1;end
  private_module_function :fu_get_uid

  def fu_get_gid(group);1;end
  private_module_function :fu_get_gid

  def fu_list(arg)
    [arg].flatten.map {|path| File.path(path) }
  end

  private_module_function :fu_list

  def fu_each_src_dest(src, dest)   #:nodoc:
    fu_each_src_dest0(src, dest) do |s, d|
      raise ArgumentError, "same file: #{s} and #{d}" if fu_same?(s, d)
      yield s, d, File.stat(s)
    end
  end
  private_module_function :fu_each_src_dest

  def fu_each_src_dest0(src, dest)   #:nodoc:
    if tmp = Array.try_convert(src)
      tmp.each do |s|
        s = File.path(s)
        yield s, File.join(dest, File.basename(s))
      end
    else
      src = File.path(src)
      if File.directory?(dest)
        yield src, File.join(dest, File.basename(src))
      else
        yield src, File.path(dest)
      end
    end
  end
  private_module_function :fu_each_src_dest0

  def fu_check_options(options, optdecl)   #:nodoc:
    h = options.dup
    optdecl.each do |opt|
      h.delete opt
    end
    raise ArgumentError, "no such option: #{h.keys.join(' ')}" unless h.empty?
  end
  private_module_function :fu_check_options

  def fu_have_symlink?
    File.symlink nil, nil
  rescue NotImplementedError
    return false
  rescue TypeError
    return true
  end
  private_module_function :fu_have_symlink?

  def fu_stat_identical_entry?(a, b)
    a.dev == b.dev and a.ino == b.ino
  end
  private_module_function :fu_stat_identical_entry?


  def fu_update_option(args, new)
    if tmp = Hash.try_convert(args.last)
      args[-1] = tmp.dup.update(new)
    else
      args.push new
    end
    args
  end
  private_module_function :fu_update_option

  @fileutils_output = $stderr
  @fileutils_label  = ''

  def fu_output_message(msg)   #:nodoc:
    @fileutils_output ||= $stderr
    @fileutils_label  ||= ''
    @fileutils_output.puts @fileutils_label + msg
  end

  private_module_function :fu_output_message

    module StreamUtils_
      private

      def fu_windows?
        /mswin|mingw|bccwin|emx/ =~ RUBY_PLATFORM
      end

      def fu_copy_stream0(src, dest, blksize = nil)   #:nodoc:
        IO.copy_stream(src, dest)
      end

      def fu_stream_blksize(*streams)
        streams.each do |s|
          next unless s.respond_to?(:stat)
          size = fu_blksize(s.stat)
          return size if size
        end
        fu_default_blksize()
      end

      def fu_blksize(st)
        s = st.blksize
        return nil unless s
        return nil if s == 0
        s
      end

      def fu_default_blksize
        1024
      end
    end

    class Entry_   #:nodoc: internal use only
    include StreamUtils_

    def initialize(a, b = nil, deref = false)
      @prefix = @rel = @path = nil
      if b
        @prefix = a
        @rel = b
      else
        @path = a
      end
      @deref = deref
      @stat = nil
      @lstat = nil
    end

    def inspect
      "\#<#{self.class} #{path()}>"
    end

    def path
      if @path
        File.path(@path)
      else
        join(@prefix, @rel)
      end
    end

    def prefix
      @prefix || @path
    end

    def rel
      @rel
    end

    def dereference?
      @deref
    end

    def exist?
      lstat! ? true : false
    end

    def file?
      s = lstat!
      s and s.file?
    end

    def directory?
      s = lstat!
      s and s.directory?
    end

    def symlink?
      s = lstat!
      s and s.symlink?
    end

    def chardev?
      s = lstat!
      s and s.chardev?
    end

    def blockdev?
      s = lstat!
      s and s.blockdev?
    end

    def socket?
      s = lstat!
      s and s.socket?
    end

    def pipe?
      s = lstat!
      s and s.pipe?
    end

    S_IF_DOOR = 0xD000

    def door?
      s = lstat!
      s and (s.mode & 0xF000 == S_IF_DOOR)
    end

    def entries
      opts = {}
      opts[:encoding] = ::Encoding::UTF_8 if fu_windows?
      Dir.entries(path(), opts)\
          .reject {|n| n == '.' or n == '..' }\
          .map {|n| Entry_.new(prefix(), join(rel(), n.untaint)) }
    end

    def stat
      return @stat if @stat
      if lstat() and lstat().symlink?
        @stat = File.stat(path())
      else
        @stat = lstat()
      end
      @stat
    end

    def stat!
      return @stat if @stat
      if lstat! and lstat!.symlink?
        @stat = File.stat(path())
      else
        @stat = lstat!
      end
      @stat
    rescue SystemCallError
      nil
    end

    def lstat
      if dereference?
        @lstat ||= File.stat(path())
      else
        @lstat ||= File.lstat(path())
      end
    end

    def lstat!
      lstat()
    rescue SystemCallError
      nil
    end

    def chmod(mode)
      if symlink?
        File.lchmod mode, path() if have_lchmod?
      else
        File.chmod mode, path()
      end
    end

    def chown(uid, gid)
      if symlink?
        File.lchown uid, gid, path() if have_lchown?
      else
        File.chown uid, gid, path()
      end
    end

    def copy(dest)
      case
      when file?
        copy_file dest
      when directory?
        if !File.exist?(dest) and descendant_diretory?(dest, path)
          raise ArgumentError, "cannot copy directory %s to itself %s" % [path, dest]
        end
        begin
          Dir.mkdir dest
        rescue
          raise unless File.directory?(dest)
        end
      when symlink?
        File.symlink File.readlink(path()), dest
      when chardev?
        raise "cannot handle device file" unless File.respond_to?(:mknod)
        mknod dest, ?c, 0666, lstat().rdev
      when blockdev?
        raise "cannot handle device file" unless File.respond_to?(:mknod)
        mknod dest, ?b, 0666, lstat().rdev
      when socket?
        raise "cannot handle socket" unless File.respond_to?(:mknod)
        mknod dest, nil, lstat().mode, 0
      when pipe?
        raise "cannot handle FIFO" unless File.respond_to?(:mkfifo)
        mkfifo dest, 0666
      when door?
        raise "cannot handle door: #{path()}"
      else
        raise "unknown file type: #{path()}"
      end
    end

    def copy_file(dest)
      File.open(path()) do |s|
        File.open(dest, 'wb', s.stat.mode) do |f|
          IO.copy_stream(s, f)
        end
      end
    end

    def copy_metadata(path)
      st = lstat()
      if !st.symlink?
        File.utime st.atime, st.mtime, path
      end
      begin
        if st.symlink?
          begin
            File.lchown st.uid, st.gid, path
          rescue NotImplementedError
          end
        else
          File.chown st.uid, st.gid, path
        end
      rescue Errno::EPERM
        # clear setuid/setgid
        if st.symlink?
          begin
            File.lchmod st.mode & 01777, path
          rescue NotImplementedError
          end
        else
          File.chmod st.mode & 01777, path
        end
      else
        if st.symlink?
          begin
            File.lchmod st.mode, path
          rescue NotImplementedError
          end
        else
          File.chmod st.mode, path
        end
      end
    end

    def remove
      if directory?
        remove_dir1
      else
        remove_file
      end
    end

    def remove_dir1
      platform_support {
        Dir.rmdir path().chomp(?/)
      }
    end

    def remove_file
      platform_support {
        File.unlink path
      }
    end

    def platform_support
      return yield unless fu_windows?
      first_time_p = true
      begin
        yield
      rescue Errno::ENOENT
        raise
      rescue => err
        if first_time_p
          first_time_p = false
          begin
            File.chmod 0700, path()   # Windows does not have symlink
            retry
          rescue SystemCallError
          end
        end
        raise err
      end
    end

    def preorder_traverse
      stack = [self]
      while ent = stack.pop
        yield ent
        stack.concat ent.entries.reverse if ent.directory?
      end
    end

    alias traverse preorder_traverse

    def postorder_traverse
      if directory?
        entries().each do |ent|
          ent.postorder_traverse do |e|
            yield e
          end
        end
      end
      yield self
    end

    def wrap_traverse(pre, post)
      pre.call self
      if directory?
        entries.each do |ent|
          ent.wrap_traverse pre, post
        end
      end
      post.call self
    end

    private

    $fileutils_rb_have_lchmod = nil

    def have_lchmod?
      # This is not MT-safe, but it does not matter.
      if $fileutils_rb_have_lchmod == nil
        $fileutils_rb_have_lchmod = check_have_lchmod?
      end
      $fileutils_rb_have_lchmod
    end

    def check_have_lchmod?
      return false unless File.respond_to?(:lchmod)
      File.lchmod 0
      return true
    rescue NotImplementedError
      return false
    end

    $fileutils_rb_have_lchown = nil

    def have_lchown?
      # This is not MT-safe, but it does not matter.
      if $fileutils_rb_have_lchown == nil
        $fileutils_rb_have_lchown = check_have_lchown?
      end
      $fileutils_rb_have_lchown
    end

    def check_have_lchown?
      return false unless File.respond_to?(:lchown)
      File.lchown nil, nil
      return true
    rescue NotImplementedError
      return false
    end

    def join(dir, base)
      return File.path(dir) if not base or base == '.'
      return File.path(base) if not dir or dir == '.'
      File.join(dir, base)
    end

    if File::ALT_SEPARATOR
      DIRECTORY_TERM = "(?=[/#{Regexp.quote(File::ALT_SEPARATOR)}]|\\z)".freeze
    else
      DIRECTORY_TERM = "(?=/|\\z)".freeze
    end
    SYSCASE = File::FNM_SYSCASE.nonzero? ? "-i" : ""

    def descendant_diretory?(descendant, ascendant)
      /\A(?#{SYSCASE}:#{Regexp.quote(ascendant)})#{DIRECTORY_TERM}/ =~ File.dirname(descendant)
    end
    end   # class Entry_

    def fu_same?(a, b)   #:nodoc:
    File.identical?(a, b)
    end
    private_module_function :fu_same?

    @fileutils_output = $stderr
    @fileutils_label  = ''

    def FileUtils.commands
    OPT_TABLE.keys
    end

    def FileUtils.options
    OPT_TABLE.values.flatten.uniq.map {|sym| sym.to_s }
    end

    def FileUtils.have_option?(mid, opt)
    li = OPT_TABLE[mid.to_s] or raise ArgumentError, "no such method: #{mid}"
    li.include?(opt)
    end

    def FileUtils.options_of(mid)
    OPT_TABLE[mid.to_s].map {|sym| sym.to_s }
    end

    def FileUtils.collect_method(opt)
    OPT_TABLE.keys.select {|m| OPT_TABLE[m].include?(opt) }
    end

    LOW_METHODS = singleton_methods(false) - collect_method(:noop).map(&:intern)
    module LowMethods
    module_eval("private\n" + ::FileUtils::LOW_METHODS.map {|name| "def #{name}(*)end"}.join("\n"),
                __FILE__, __LINE__)
    end

    METHODS = singleton_methods() - [:private_module_function,
      :commands, :options, :have_option?, :options_of, :collect_method]

    module Verbose
    include FileUtils
    @fileutils_output  = $stderr
    @fileutils_label   = ''
    ::FileUtils.collect_method(:verbose).each do |name|
      module_eval(<<-EOS, __FILE__, __LINE__ + 1)
        def #{name}(*args)
          super(*fu_update_option(args, :verbose => true))
        end
        private :#{name}
      EOS
    end
    extend self
    class << self
      ::FileUtils::METHODS.each do |m|
        public m
      end
    end
    end

    module NoWrite
    include FileUtils
    include LowMethods
    @fileutils_output  = $stderr
    @fileutils_label   = ''
    ::FileUtils.collect_method(:noop).each do |name|
      module_eval(<<-EOS, __FILE__, __LINE__ + 1)
        def #{name}(*args)
          super(*fu_update_option(args, :noop => true))
        end
        private :#{name}
      EOS
    end
    extend self
      class << self
        ::FileUtils::METHODS.each do |m|
          public m
        end
      end
    end

    module DryRun
    include FileUtils
    include LowMethods
    @fileutils_output  = $stderr
    @fileutils_label   = ''
    ::FileUtils.collect_method(:noop).each do |name|
      module_eval(<<-EOS, __FILE__, __LINE__ + 1)
        def #{name}(*args)
          super(*fu_update_option(args, :noop => true, :verbose => true))
        end
        private :#{name}
      EOS
    end
    extend self
    class << self
      ::FileUtils::METHODS.each do |m|
        public m
      end
    end
  end
end


module FileUtils
  include StreamUtils_
  extend StreamUtils_
end

require "etc"
require 'fileutils'

class Dir

  @@systmpdir ||= defined?(Etc.systmpdir) ? Etc.systmpdir : '/tmp'

  def Dir::tmpdir
    if $SAFE > 0
      tmp = @@systmpdir
    else
      tmp = nil
      for dir in [ENV['TMPDIR'], ENV['TMP'], ENV['TEMP'], @@systmpdir, '/tmp', '.']
        next if !dir
        dir = File.expand_path(dir)
        if stat = File.stat(dir) and stat.directory? and stat.writable? and
            (!stat.world_writable? or stat.sticky?)
          tmp = dir
          break
        end rescue nil
      end
      raise ArgumentError, "could not find a temporary directory" if !tmp
      tmp
    end
  end

  def Dir.mktmpdir(prefix_suffix=nil, *rest)
    path = Tmpname.create(prefix_suffix || "d", *rest) {|n| mkdir(n, 0700)}
    if block_given?
      begin
        yield path
      ensure
        stat = File.stat(File.dirname(path))
        if stat.world_writable? and !stat.sticky?
          raise ArgumentError, "parent directory is world writable but not sticky"
        end
        FileUtils.remove_entry path
      end
    else
      path
    end
  end

  module Tmpname # :nodoc:
    module_function

    def tmpdir
      Dir.tmpdir
    end

    def make_tmpname(prefix_suffix, n)
      case prefix_suffix
      when String
        prefix = prefix_suffix
        suffix = ""
      when Array
        prefix = prefix_suffix[0]
        suffix = prefix_suffix[1]
      else
        raise ArgumentError, "unexpected prefix_suffix: #{prefix_suffix.inspect}"
      end
      t = Time.now.strftime("%Y%m%d")
      path = "#{prefix}#{t}-#{$$}-#{rand(0x100000000).to_s(36)}"
      path << "-#{n}" if n
      path << suffix
    end

    def create(basename, *rest)
      if opts = Hash.try_convert(rest[-1])
        opts = opts.dup if rest.pop.equal?(opts)
        max_try = opts.delete(:max_try)
        opts = [opts]
      else
        opts = []
      end
      tmpdir, = *rest
      if $SAFE > 0 and tmpdir.tainted?
        tmpdir = '/tmp'
      else
        tmpdir ||= tmpdir()
      end
      n = nil
      begin
        path = File.join(tmpdir, make_tmpname(basename, n))
        yield(path, n, *opts)
      rescue Errno::EEXIST
        n ||= 0
        n += 1
        retry if !max_try or n < max_try
        raise "cannot generate temporary name using `#{basename}' under `#{tmpdir}'"
      end
      path
    end
  end
end

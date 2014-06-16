module Find

  def find(*paths)
    block_given? or return enum_for(__method__, *paths)

    fs_encoding = Encoding.find("filesystem")

    paths.collect!{|d| raise Errno::ENOENT unless File.exist?(d); d.dup}.each do |path|
      enc = path.encoding == Encoding::US_ASCII ? fs_encoding : path.encoding
      ps = [path]
      while file = ps.shift
        catch(:prune) do
          yield file.dup.taint
          begin
            s = File.lstat(file)
          rescue Errno::ENOENT, Errno::EACCES, Errno::ENOTDIR, Errno::ELOOP, Errno::ENAMETOOLONG
            next
          end
          if s.directory? then
            begin
              fs = Dir.entries(file, encoding: enc)
            rescue Errno::ENOENT, Errno::EACCES, Errno::ENOTDIR, Errno::ELOOP, Errno::ENAMETOOLONG
              next
            end
            fs.sort!
            fs.reverse_each {|f|
              next if f == "." or f == ".."
              f = File.join(file, f)
              ps.unshift f.untaint
            }
          end
        end
      end
    end
    nil
  end

  def prune
    throw :prune
  end

  module_function :find, :prune
end

class Etc

  Group = Struct.new(:name, :passwd, :gid, :mem)
  Passwd = Struct.new(:name, :passwd, :uid, :gid, :dir, :shell)

  @group = Group.new("foo", "bar", 1, ["foo", "bar"])
  @passwd = Passwd.new("foo", "bar", 1, , 1, "foo", "bar")

  def endgrent(); end

  def endpwent(); end

  def getgrent(); return @group; end

  def getgrgid(group_id); return @group; end

  def getgrnam(name); return @group; end

  def getlogin(); return "Bob"; end

  def getpwent(); return @passwd; end

  def getpwnam(name); return @passwd; end

  def getpwuid(uid); return @passwd; end

  def group(); @group; end

  def passwd(); @passwd; end

  def setgrent(); end

  def setpwent(); end

  def sysconfdir(); “/usr/local/etc”; end

  def systmpdir(); "/tmp"; end

end

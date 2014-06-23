require "bundler/gem_tasks"
require "jruby-parser"
require "ant"
require "pathname"
#require "rsense-core"

ant_import

def parser_path
  jrp_path = ""
  $LOAD_PATH.each do |p|
   if p =~ /jruby-parser/
     jrp_path = p
   end
 end
 jrp_path = Pathname.new(jrp_path).join("jruby-parser.jar")
end

ant.path :id => "build.class.path" do
  fileset :file => "build_lib/*.jar"
  fileset :file => "lib/jars/*.jar"
  fileset :file => "#{parser_path.to_s}"
  fileset :file => "lib/rsense.jar"
  pathelement :path => "${classpath}"
end

desc "Build RSense Jar"
task :build_jar => [:antlr, :set_version] do
  ant.javac(:fork => "true", :debug =>"true", :source => "1.6",:target => "1.6", :deprecation => "true", :srcdir => "src", :destdir => "build", :classpathref => "build.class.path") do
    compilerarg :value => "-Xlint:all"
  end
  ant.jar(:jarfile => "lib/rsense.jar", :basedir => "build") do
    fileset :dir => "src/resources"
    manifest do
      attribute :name => "Main-Class", :value => "org.cx4a.rsense.Main"
    end
  end
end

desc "Update Rsense\'s Version in Java Properties File"
task :set_version do
  prop_file = Pathname.new("./src/resources/org/cx4a/rsense/rsense.properties").expand_path
  version = Rsense::Core::VERSION
  File.open(prop_file, "w") do |f|
    f.puts "rsense.version = #{version}"
  end
end

desc "Run Rsense\'s set of tests"
task :rtests => [:build_jar] do
  ant.java(fork: "true", classpathref: "build.class.path", classname: "org.cx4a.rsense.Main") do
    arg(value: "script")
    arg(file: "test/script/all.rsense")
    arg(value: "--log-level=error")
    arg(value: "--test-color")
  end
end

desc "Test, Bump, Build"
task :prepare_jar => [:set_version, :build_jar, :rtests] do
  puts "Jar Prepared!"
end

desc "Build from scratch"
task :build_scratch => [:prepare_jar, :build] do
  puts "Built gem from scratch."
end

desc "Install locally from scratch"
task :install_scratch => [:build_scratch, :install] do
  puts "Installed from scratch."
end

desc "Commit rsense.jar"
task :commit_jar do
  sh "git add src/resources/org/cx4a/rsense/rsense.properties"
  sh "git add lib/rsense.jar"
  sh "git commit -m 'Rebuilds rsense.jar'"
end

desc "Cut a release from scratch."
task :release_scratch => [:build_scratch, :commit_jar,:release] do
  puts "Release published from scratch."
end

require "java"
require "pathname"
require "jruby-parser"
require "rsense/core/version"
require "rsense.jar"
require "filetree"

jarpath = Pathname.new(__FILE__).dirname.join("jars").expand_path
jarpath.children.each do |c|
  require(c)
end

require "rsense/util"
require "rsense/typing"
require "rsense/ruby"
require "rsense/parser"

module Rsense

  def self.root_dir
    FileTree.new(File.dirname(__FILE__)).expand_path.ancestors[0]
  end

  BUILTIN = root_dir().join('stubs')

  import Java::org.cx4a.rsense::CodeAssist
  import Java::org.cx4a.rsense::CodeAssistError
  import Java::org.cx4a.rsense::CodeAssistResult
  import Java::org.cx4a.rsense::CodeCompletionResult
  import Java::org.cx4a.rsense::FindDefinitionResult
  import Java::org.cx4a.rsense::LoadResult
  import Java::org.cx4a.rsense::Options
  import Java::org.cx4a.rsense::Project
  import Java::org.cx4a.rsense::TypeInferenceResult
  import Java::org.cx4a.rsense::WhereResult
end

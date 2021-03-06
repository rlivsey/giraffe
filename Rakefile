require "rubygems"
require "rake/gempackagetask"
require "rake/rdoctask"

# This builds the actual gem. For details of what all these options
# mean, and other ones you can add, check the documentation here:
#
#   http://rubygems.org/read/chapter/20
#
spec = Gem::Specification.new do |s|

  # Change these as appropriate
  s.name              = "giraffe"
  s.version           = "0.0.1"
  s.summary           = "Rails template graphing"
  s.description       = "Generate graphs of your Rails app's partials"
  s.author            = "Richard Livsey"
  s.email             = "richard@livsey.org"
  s.homepage          = "http://github.com/rlivsey/giraffe"

  s.has_rdoc          = true
  s.extra_rdoc_files  = %w(README)
  s.rdoc_options      = %w(--main README)

  # Add any extra files to include in the gem
  s.files             = %w(README) + Dir.glob("{bin,lib/**/*}")
  s.executables       = FileList["bin/**"].map { |f| File.basename(f) }
  s.require_paths     = ["lib"]

  # If you want to depend on other gems, add them here, along with any
  # relevant versions
  s.add_dependency("ruby-graphviz")
end

# This task actually builds the gem. We also regenerate a static
# .gemspec file, which is useful if something (i.e. GitHub) will
# be automatically building a gem for this project. If you're not
# using GitHub, edit as appropriate.
Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec

  # Generate the gemspec file for github.
  file = File.dirname(__FILE__) + "/#{spec.name}.gemspec"
  File.open(file, "w") {|f| f << spec.to_ruby }
end

# Generate documentation
Rake::RDocTask.new do |rd|
  rd.main = "README"
  rd.rdoc_files.include("README", "lib/**/*.rb")
  rd.rdoc_dir = "rdoc"
end

desc 'Clear out RDoc and generated packages'
task :clean => [:clobber_rdoc, :clobber_package] do
  rm "#{spec.name}.gemspec"
end
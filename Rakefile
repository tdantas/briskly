require 'rake/extensiontask'
spec = Gem::Specification.load('briskly.gemspec')
Rake::ExtensionTask.new('briskly', spec) do |ext|
  ext.ext_dir = 'ext/briskly' 
  ext.lib_dir = 'lib/briskly'
end

require 'bundler/gem_tasks'

require 'rake/testtask'
task :default => [:spec]

desc 'Run tests (default)'
Rake::TestTask.new(:spec) do |t|
  t.test_files = FileList['spec/**/*_spec.rb']
  t.ruby_opts = ['-Ispec']
  t.ruby_opts << '-rrubygems' if defined? Gem
end

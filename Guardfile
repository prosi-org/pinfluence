guard :rspec, cmd: "bundle exec rspec" do
  require "guard/rspec/dsl"
  dsl = Guard::RSpec::Dsl.new(self)

  # RSpec files
  rspec = dsl.rspec
  watch(rspec.spec_helper) { rspec.spec_dir }
  watch(rspec.spec_support) { rspec.spec_dir }
  watch(rspec.spec_files)

  # Ruby files
  ruby = dsl.ruby
  dsl.watch_spec_files_for(ruby.lib_files)

  watch(%r{^lib/pinfluence/(.+)\.rb$}) { |m| "spec/pinfluence/#{m[1]}_spec.rb" }
  watch(%r{^apps/(.+)/controllers/(.+)/(.+)\.rb$}) { |m| "spec/requests/#{m[1]}/" }
  watch(%r{^apps/(.+)/views/(.+)/(.+)\.rb$}) { |m| "spec/requests/#{m[1]}/" }
end

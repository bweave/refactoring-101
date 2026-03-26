# frozen_string_literal: true

require "rake/testtask"

Rake::TestTask.new do |t|
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

task :default do
  Rake::Task[:test].invoke
rescue RuntimeError
  exit 1
end

rule(/\.rb:\d+$/) do |task|
  file, line = task.name.split(":")
  line = line.to_i

  test_name = nil
  File.readlines(file).each_with_index do |content, index|
    test_name = content.strip.match(/^def (test_\w+)/)[1] if content.match?(/^\s*def test_/)
    break if index + 1 >= line
  end

  abort "No test found at #{task.name}" unless test_name

  sh "bundle exec ruby -Ilib #{file} -n #{test_name}"
end

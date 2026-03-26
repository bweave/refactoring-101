# frozen_string_literal: true

require "bundler/setup"
require "debug"
require "minitest/autorun"
require "minitest/pride"
require_relative "../lib/registration_system"

# Quiet reporter: keeps Pride dots, prints failures + summary, skips the noise.
module Minitest
  def self.plugin_slim_init(options)
    self.reporter.reporters.reject! { |r| r.is_a?(SummaryReporter) }
    self.reporter << QuietSummaryReporter.new(options[:io], options)
  end

  class QuietSummaryReporter < StatisticsReporter
    def start
      self.start_time = Minitest.clock_time
    end

    def report
      self.total_time = Minitest.clock_time - start_time

      io.puts
      io.puts

      aggregate = results.reject(&:skipped?)
      aggregate.each_with_index do |result, i|
        io.puts "  #{i + 1}) #{result.failure.class.name.split("::").last}:"
        io.puts "     #{result.class}##{result.name}"
        result.failure.message.each_line { |line| io.puts "     #{line}" }
        io.puts
      end

      f = results.count { |r| r.failure && !r.skipped? && r.failure.is_a?(Minitest::Assertion) }
      e = results.count { |r| r.failure && !r.skipped? && !r.failure.is_a?(Minitest::Assertion) }
      s = results.count(&:skipped?)

      io.puts "#{count} runs, #{assertions} assertions, #{f} failures, #{e} errors, #{s} skips"
    end
  end

  extensions.delete("slim")
  extensions << "slim"
end

QUOTES = [
  "\"Make the change easy, then make the easy change.\" -- Kent Beck",
  "\"Duplication is far cheaper than the wrong abstraction.\" -- Sandi Metz",
  "\"Code needs to work today just once, but needs to be easy to change forever.\" -- Sandi Metz",
  "\"You will never know less than you know right now.\" -- Sandi Metz",
  "\"Reach for abstraction only when the code tells you to.\" -- Sandi Metz",
  "\"Depend on things that change less often than you do.\" -- Sandi Metz",
  "\"Refactoring does not change what code does, only how it does it.\" -- Martin Fowler"
].freeze

puts "\n\e[33m#{QUOTES.sample}\e[0m\n\n"

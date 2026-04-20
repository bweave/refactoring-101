# frozen_string_literal: true

require_relative "test_helper"

# =============================================================================
# Step 06: Dependency Inversion Principle (DIP)
# =============================================================================
#
# High-level modules should not depend on low-level modules; both should
# depend on abstractions.
#
# RegistrationSystem still hard-codes its dependencies: it creates its own
# EmailNotifier, SmsNotifier, SlackNotifier, and uses PriceCalculator directly.
# You can't swap in a different pricing strategy or notification channel
# without modifying the class itself.
#
# First make the change easy: accept dependencies via keyword arguments with
# sensible defaults. The pricing calculator and notifiers become constructor
# parameters. Then injecting new behavior is just passing it to the
# initializer -- no modification needed.
#
# The case statement that dispatches notifications by channel symbol? It
# becomes a simple hash lookup over the injected notifiers hash. Polymorphism
# replaces the conditional.
#
# =============================================================================

class DependencyInversionTest < Minitest::Test
  # -- Group discount kicks in after 5 registrations --------------------------

  def test_group_discount_applied_after_five_registrations
    skip "Inject a group discount calculator -- 10% off when registered_count > 5"

    group_discount_calculator = Object.new
    def group_discount_calculator.calculate(event)
      event[:registered].size > 5 ? (event[:price] * 0.9).to_i : event[:price]
    end

    system = RegistrationSystem.new(pricing_calculator: group_discount_calculator)
    system.create_event("Workshop", :workshop, 20, 100)

    6.times do |i|
      system.register("Attendee #{i + 1}", "attendee#{i + 1}@example.com", "Workshop")
    end

    report = system.attendee_report("attendee6@example.com")
    sixth_registration = report[:registrations].find { |r| r[:event_name] == "Workshop" }

    assert_equal 90, sixth_registration[:price]
  end

  # -- First five registrations get regular price -----------------------------

  def test_first_five_registrations_get_regular_price
    skip "The first 5 registrations are not discounted"

    group_discount_calculator = Object.new
    def group_discount_calculator.calculate(event)
      event[:registered].size > 5 ? (event[:price] * 0.9).to_i : event[:price]
    end

    system = RegistrationSystem.new(pricing_calculator: group_discount_calculator)
    system.create_event("Workshop", :workshop, 20, 100)

    5.times do |i|
      system.register("Attendee #{i + 1}", "attendee#{i + 1}@example.com", "Workshop")
    end

    report = system.attendee_report("attendee5@example.com")
    fifth_registration = report[:registrations].find { |r| r[:event_name] == "Workshop" }

    assert_equal 100, fifth_registration[:price]
  end

  # -- Injected notifier replaces the default ---------------------------------

  def test_injected_notifier_replaces_default
    skip "Inject notifiers -- polymorphic dispatch replaces the case statement"

    injected_email = EmailNotifier.new

    system = RegistrationSystem.new(notifiers: { email: injected_email, sms: SmsNotifier.new, slack: SlackNotifier.new })
    system.create_event("Conference", :conference, 20, 100)
    system.register("Alice", "alice@example.com", "Conference", "555-0101")

    assert_equal 1, injected_email.notifications.size
    assert_match(/EMAIL: alice@example.com/, injected_email.notifications[0])
  end

  # -- Default behavior is unchanged ------------------------------------------

  def test_default_behavior_unchanged
    skip "RegistrationSystem.new with no args still uses sensible defaults"

    system = RegistrationSystem.new
    system.create_event("Workshop", :workshop, 10, 50, 35)

    result = system.register("Alice", "alice@example.com", "Workshop")

    assert_equal true, result[:success]
    assert_equal 35, result[:price]
  end
end

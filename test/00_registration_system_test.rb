# frozen_string_literal: true

require_relative "test_helper"

# =============================================================================
# RegistrationSystem Tests
# =============================================================================
#
# These tests describe what the RegistrationSystem currently does. They are
# your safety net. If one of these tests breaks, your refactoring changed
# behavior -- back up and retry.
# =============================================================================

class RegistractionSystemTest < Minitest::Test
  def setup
    @system = RegistrationSystem.new
  end

  # -- Event Creation ---------------------------------------------------------

  def test_create_event
    result = @system.create_event("Sunday Service", :service, 100, 0)

    assert_equal "Sunday Service", result[:name]
    assert_equal :service, result[:event_type]
    assert_equal 100, result[:capacity]
  end

  def test_create_event_with_early_bird_price
    result = @system.create_event("Leadership Workshop", :workshop, 30, 50, 35)

    assert_equal 50, result[:price]
    assert_equal 35, result[:early_bird_price]
  end

  # -- Registration -----------------------------------------------------------

  def test_register_for_event
    @system.create_event("Sunday Service", :service, 100, 0)

    result = @system.register("Alice Smith", "alice@example.com", "Sunday Service")

    assert_equal true, result[:success]
    assert_equal :confirmed, result[:status]
    assert_equal 0, result[:price]
  end

  def test_register_with_phone
    @system.create_event("Youth Workshop", :workshop, 20, 25)

    result = @system.register("Bob Jones", "bob@example.com", "Youth Workshop", "555-0101")

    assert_equal true, result[:success]
    assert_equal :confirmed, result[:status]
  end

  def test_register_for_nonexistent_event
    result = @system.register("Alice Smith", "alice@example.com", "Nonexistent")

    assert_equal false, result[:success]
    assert_equal "Event not found", result[:error]
  end

  def test_duplicate_registration_rejected
    @system.create_event("Sunday Service", :service, 100, 0)
    @system.register("Alice Smith", "alice@example.com", "Sunday Service")

    result = @system.register("Alice Smith", "alice@example.com", "Sunday Service")

    assert_equal false, result[:success]
    assert_equal "Already registered", result[:error]
  end

  # -- Waitlist ---------------------------------------------------------------

  def test_waitlist_when_full
    @system.create_event("Small Group", :service, 2, 0)
    @system.register("Alice", "alice@example.com", "Small Group")
    @system.register("Bob", "bob@example.com", "Small Group")

    result = @system.register("Charlie", "charlie@example.com", "Small Group")

    assert_equal true, result[:success]
    assert_equal :waitlisted, result[:status]
  end

  def test_duplicate_registration_rejected_when_on_waitlist
    @system.create_event("Small Group", :service, 1, 0)
    @system.register("Alice", "alice@example.com", "Small Group")
    @system.register("Bob", "bob@example.com", "Small Group")

    result = @system.register("Bob", "bob@example.com", "Small Group")

    assert_equal false, result[:success]
    assert_equal "Already registered", result[:error]
  end

  # -- Pricing ----------------------------------------------------------------

  def test_service_event_pricing
    @system.create_event("Sunday Service", :service, 100, 0)

    result = @system.register("Alice", "alice@example.com", "Sunday Service")

    assert_equal 0, result[:price]
  end

  def test_workshop_early_bird_pricing
    @system.create_event("Workshop", :workshop, 10, 50, 35)

    result = @system.register("Alice", "alice@example.com", "Workshop")

    assert_equal 35, result[:price]
  end

  def test_workshop_regular_pricing_after_half_full
    @system.create_event("Workshop", :workshop, 4, 50, 35)
    @system.register("A1", "a1@example.com", "Workshop")
    @system.register("A2", "a2@example.com", "Workshop")

    result = @system.register("A3", "a3@example.com", "Workshop")

    assert_equal 50, result[:price]
  end

  def test_retreat_early_bird_pricing
    @system.create_event("Retreat", :retreat, 9, 200, 150)

    result = @system.register("Alice", "alice@example.com", "Retreat")

    assert_equal 150, result[:price]
  end

  def test_retreat_regular_pricing_after_third_full
    @system.create_event("Retreat", :retreat, 6, 200, 150)
    @system.register("A1", "a1@example.com", "Retreat")
    @system.register("A2", "a2@example.com", "Retreat")

    result = @system.register("A3", "a3@example.com", "Retreat")

    assert_equal 200, result[:price]
  end

  # -- Notifications ----------------------------------------------------------

  def test_service_sends_email_only
    @system.create_event("Sunday Service", :service, 100, 0)

    @system.register("Alice", "alice@example.com", "Sunday Service", "555-0101")

    assert_equal 1, @system.notifications_sent.size
    assert_match(/^EMAIL: alice@example.com/, @system.notifications_sent[0])
  end

  def test_workshop_sends_email_and_sms
    @system.create_event("Workshop", :workshop, 20, 50)

    @system.register("Alice", "alice@example.com", "Workshop", "555-0101")

    assert_equal 2, @system.notifications_sent.size
    assert_match(/^EMAIL: alice@example.com/, @system.notifications_sent[0])
    assert_match(/^SMS: 555-0101/, @system.notifications_sent[1])
  end

  def test_workshop_skips_sms_without_phone
    @system.create_event("Workshop", :workshop, 20, 50)

    @system.register("Alice", "alice@example.com", "Workshop")

    assert_equal 1, @system.notifications_sent.size
    assert_match(/^EMAIL:/, @system.notifications_sent[0])
  end

  def test_retreat_sends_email_and_sms
    @system.create_event("Retreat", :retreat, 20, 200)

    @system.register("Alice", "alice@example.com", "Retreat", "555-0101")

    assert_equal 2, @system.notifications_sent.size
    assert_match(/^EMAIL: alice@example.com/, @system.notifications_sent[0])
    assert_match(/^SMS: 555-0101/, @system.notifications_sent[1])
  end

  def test_waitlist_notification
    @system.create_event("Workshop", :workshop, 1, 50)
    @system.register("Alice", "alice@example.com", "Workshop")

    @system.register("Bob", "bob@example.com", "Workshop", "555-0102")

    waitlist_email = @system.notifications_sent.find { |n| n.start_with?("EMAIL:") && n.include?("bob@example.com") }
    waitlist_sms = @system.notifications_sent.find { |n| n.start_with?("SMS:") && n.include?("555-0102") }
    assert waitlist_email, "Expected waitlist email notification"
    assert waitlist_sms, "Expected waitlist SMS notification"
  end

  # -- Cancellation -----------------------------------------------------------

  def test_cancel_registration
    @system.create_event("Workshop", :workshop, 20, 50)
    @system.register("Alice", "alice@example.com", "Workshop")
    event = @system.events["Workshop"]
    attendee = event[:registered].find { |r| r[:email] == "alice@example.com" }

    result = @system.cancel_registration(attendee, event)

    assert_equal true, result[:success]
    assert_equal :cancelled, result[:status]
  end

  def test_cancel_nonexistent_registration
    @system.create_event("Workshop", :workshop, 20, 50)
    event = @system.events["Workshop"]
    attendee = { name: "Nobody", email: "nobody@example.com", phone: nil }

    result = @system.cancel_registration(attendee, event)

    assert_equal false, result[:success]
    assert_equal "Registration not found", result[:error]
  end

  def test_cancel_promotes_from_waitlist
    @system.create_event("Workshop", :workshop, 1, 50)
    @system.register("Alice", "alice@example.com", "Workshop")
    @system.register("Bob", "bob@example.com", "Workshop", "555-0102")
    event = @system.events["Workshop"]
    attendee = event[:registered].find { |r| r[:email] == "alice@example.com" }

    @system.cancel_registration(attendee, event)

    promotion_email = @system.notifications_sent.find { |n| n.include?("bob@example.com") && n.include?("promoted") }
    assert promotion_email, "Expected promotion notification for Bob"
  end

  def test_cancel_waitlisted_attendee
    @system.create_event("Workshop", :workshop, 1, 50)
    @system.register("Alice", "alice@example.com", "Workshop")
    @system.register("Bob", "bob@example.com", "Workshop")
    event = @system.events["Workshop"]
    attendee = event[:waitlist].find { |r| r[:email] == "bob@example.com" }

    result = @system.cancel_registration(attendee, event)

    assert_equal true, result[:success]
    assert_equal :cancelled, result[:status]
  end

  def test_retreat_cancellation_includes_refund_info
    @system.create_event("Retreat", :retreat, 20, 200)
    @system.register("Alice", "alice@example.com", "Retreat")
    event = @system.events["Retreat"]
    attendee = event[:registered].find { |r| r[:email] == "alice@example.com" }

    @system.cancel_registration(attendee, event)

    cancel_email = @system.notifications_sent.find { |n| n.include?("alice@example.com") && n.include?("cancelled") }
    assert cancel_email, "Expected cancellation email"
    assert_match(/refund/i, cancel_email)
  end

  # -- Reports ----------------------------------------------------------------

  def test_event_report
    @system.create_event("Workshop", :workshop, 10, 50)
    @system.register("Alice", "alice@example.com", "Workshop")
    @system.register("Bob", "bob@example.com", "Workshop")

    report = @system.event_report("Workshop")

    assert_equal "Workshop", report[:event_name]
    assert_equal :workshop, report[:event_type]
    assert_equal 10, report[:capacity]
    assert_equal 2, report[:registered_count]
    assert_equal 0, report[:waitlist_count]
    assert_equal 8, report[:available_spots]
    assert_equal 2, report[:registrations].size
  end

  def test_event_report_with_revenue
    @system.create_event("Workshop", :workshop, 10, 50, 35)
    @system.register("Alice", "alice@example.com", "Workshop")
    @system.register("Bob", "bob@example.com", "Workshop")

    report = @system.event_report("Workshop")

    assert_equal 70, report[:total_revenue]
  end

  def test_event_report_for_nonexistent_event
    assert_nil @system.event_report("Nonexistent")
  end

  def test_event_report_with_waitlist
    @system.create_event("Small", :service, 1, 0)
    @system.register("Alice", "alice@example.com", "Small")
    @system.register("Bob", "bob@example.com", "Small")

    report = @system.event_report("Small")

    assert_equal 1, report[:registered_count]
    assert_equal 1, report[:waitlist_count]
    assert_equal 0, report[:available_spots]
  end

  def test_attendee_report
    @system.create_event("Workshop", :workshop, 10, 50)
    @system.create_event("Retreat", :retreat, 10, 200)
    @system.register("Alice", "alice@example.com", "Workshop")
    @system.register("Alice", "alice@example.com", "Retreat")

    report = @system.attendee_report("alice@example.com")

    assert_equal "alice@example.com", report[:email]
    assert_equal 2, report[:registrations].size
    assert_equal 250, report[:total_spent]
  end

  def test_attendee_report_for_unknown_attendee
    assert_nil @system.attendee_report("nobody@example.com")
  end

  def test_attendee_report_excludes_cancelled_from_total
    @system.create_event("Workshop", :workshop, 10, 50)
    @system.create_event("Retreat", :retreat, 10, 200)
    @system.register("Alice", "alice@example.com", "Workshop")
    @system.register("Alice", "alice@example.com", "Retreat")
    event = @system.events["Workshop"]
    attendee = event[:registered].find { |r| r[:email] == "alice@example.com" }
    @system.cancel_registration(attendee, event)

    report = @system.attendee_report("alice@example.com")

    assert_equal 200, report[:total_spent]
  end
end

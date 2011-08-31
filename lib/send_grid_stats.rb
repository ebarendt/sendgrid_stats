require 'sendgrid_toolkit'

# Uses the Sendgrid Toolkit: https://github.com/freerobby/sendgrid_toolkit

class SendGridStats

  def initialize
    @api_user = ENV["SENDGRID_USER"]
    @api_key = ENV["SENDGRID_PASS"]
  end

  def load_bounces
    bounces = SendgridToolkit::Bounces.new(@api_user, @api_key)
    bounces.retrieve_with_timestamps
  end

  def load_stats
    stats = SendgridToolkit::Statistics.new(@api_user, @api_key)
    stats.retrieve
  end

end

sendgrid = SendGridStats.new
stats = sendgrid.load_stats
#print "stats: #{stats[0]}\n"
print "Today:\n"
deliveries = stats[0]["delivered"]
print "#{deliveries} delivered\n"
if stats[0]["bounces"]
  num_bounces = stats[0]["bounces"]
  print "#{num_bounces} bounces\n"
  bounces = sendgrid.load_bounces
  bounces.each do |bounce|
    email = bounces["email"]
    status = bounces["status"]
    reason = bounces["reason"]
    created = bounces["created"]
    print """
--------------------
Bounced at: #{created}
Email: #{email}
Status: #{status}
Reason: #{reason}
--------------------
"""
  end
end

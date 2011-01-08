module LogStats
module Helpers
  # NOTE: Because of the way I'm calling this (as the HAML context) these all need to be class methods

  # Turns a number of seconds into a pretty HTML string
  def self.time_to_html(seconds, options={})
    hrs=(seconds / 3600).floor
    min=(seconds % 3600).floor / 60
    o=[]
    o << "<span class=\"hour\">#{hrs}</span> hr" if hrs.to_i > 0
    o << "<span class=\"minute\">#{min}</span> min" if min.to_i > 0
    if o.size == 0 then
      o << "<span class=\"none\">NONE :(</span>"
    end
    o.join(' ')
  end

  # Options:
  #   :class : The CSS class to apply to the top element (default: duration)
  def self.duration_tag(seconds, options={})
    options[:class]='duration' if options[:class].nil?
    "<span class=\"#{options[:class]}\">#{self.time_to_html(seconds)}</span>"
  end

  def self.threshold_met?(seconds, period)
    (self.threshold_for_period(period) - seconds) < 0
  end

  def self.remaining_tag(seconds_so_far, period)
    seconds=self.threshold_for_period(period) - seconds_so_far

    css_class=[ 'remaining ']
    if seconds < 0 then
      content=self.time_to_html(seconds.abs) + ' over!'
      css_class << 'met'
    else
      content=self.time_to_html(seconds) + ' remaining'
    end
    "<div class=\"#{css_class.join(' ')}\">#{content}</div>"
  end

  # Outputs some basic productivity statistics
  def self.productivity_tag(data)
    o=[]
    css_classes=[ 'productivity' ]

    if data[:total] > 0 then
      o << self.time_to_html(data[:total]) if data[:total] > 0
      percent=((data[:billable] / data[:total]) * 100).ceil
      o << "#{percent}% billable"
    end

    "<div class=\"#{css_classes.join(' ')}\">#{o.join(' | ')}</div>"
  end

  # Returns the threshold number of seconds that need to be attained each period
  def self.threshold_for_period(period)
    case period
      when :day
        # 5 hrs per day
        5 * 3600
      when :week
        # 5 hrs per day, 5 days per week
        5 * 5 * 3600
      else
        raise "Unknown period: #{period}"
    end
  end
end
end

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
    o.join(' ')
  end

  # Options:
  #   :class : The CSS class to apply to the top element (default: duration)
  def self.duration_tag(seconds, options={})
    options[:class]='duration' if options[:class].nil?
    "<span class=\"#{options[:class]}\">#{self.time_to_html(seconds)}</span>"
  end

  def self.remaining_tag(seconds_so_far, period)
    seconds_required=case period
      when :day
        # 5 hrs per day
        5 * 3600
      when :week
        # 5 hrs per day, 5 days per week
        5 * 5 * 3600
      else
        raise "Unknown period: #{period}"
    end

    seconds=seconds_required - seconds_so_far

    css_class=[ 'remaining ']
    if seconds.nil? || seconds < 0 then
      content=self.time_to_html(seconds.abs) + ' over!'
      css_class << 'met'
    else
      content=self.time_to_html(seconds) + ' remaining'
    end
    "<div class=\"#{css_class.join(' ')}\">(#{content})</div>"
  end
end
end

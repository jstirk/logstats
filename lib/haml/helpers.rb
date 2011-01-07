module LogStats
module Helpers
  # NOTE: Because of the way I'm calling this (as the HAML context) these all need to be class methods

  # Turns a [ hr, min ] time array into a pretty HTML string
  def self.time_to_html(time_ary, options={})
    hrs=time_ary[0]
    min=time_ary[1]
    o=[]
    o << "<span class=\"hour\">#{hrs}</span> hr" if hrs.to_i > 0
    o << "<span class=\"minute\">#{min}</span> hr" if min.to_i > 0
    o.join(' ')
  end

  # Options:
  #   :class : The CSS class to apply to the top element (default: duration)
  def self.duration_tag(time_ary, options={})
    options[:class]='duration' if options[:class].nil?
    "<span class=\"#{options[:class]}\">#{self.time_to_html(time_ary)}</span>"
  end

  def self.remaining_tag(time_ary)
    css_class=[ 'remaining ']
    if time_ary.nil? then
      content='Target met!'
      css_class << 'met'
    else
      content=self.time_to_html(time_ary) + ' remaining'
    end
    "<div class=\"#{css_class.join(' ')}\">(#{content})</div>"
  end
end
end
#Haml::Helpers.module_eval('include LogStats::Helpers')

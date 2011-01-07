#!/usr/bin/env ruby
#
#
#

require 'rubygems'
require "bundler/setup"
require 'haml'
require 'lib/haml/helpers'

# TODO: Load the last couple of hundred rows from ~/worklog-active.txt
# TODO: Get the data from the rows
# TODO: Generate statistics for :
#         * Current open task
#         * Today's projects
#         * Today's total
#         * This Week's total
#         * This Month's total
#         * Relevant averages
data={ :current => [ 0, 45 ],
       :today => { :total => [ 4, 57 ],
                   :average => [ 5, 0 ],
                   :remaining => [ 0, 3 ],
                   :projects => { 'MB1' => [ 3, 5 ], 'MY1' => [ 1, 52 ]}
                 },
       :week => { :total => [ 20, 0],
                  :average => [ 5, 0 ],
                  :remaining => nil,
                  :projects => { 'MB1' => [ 15, 0 ], 'MY1' => [ 5, 00 ]}
                },
       :month => { :total => [ 20, 0],
                   :average => [ 5, 0 ],
                   :remaining => nil,
                   :projects => { 'MB1' => [ 15, 0 ], 'MY1' => [ 5, 00 ]}
                }
     }

# Inject them into the HAML layout
haml=nil
File.open('template.haml', 'r') do |f|
  haml=f.read
end
engine = Haml::Engine.new(haml)
locals={}
data.keys.each { |key| locals[key]=data[key] }
html=engine.render(LogStats::Helpers, locals)

# Save the HAML to a file
File.open('logstats.html', 'w') do |f|
  f << html
end

require 'haml'
require 'logstats/haml/helpers'
require 'logstats/worklog'
module LogStats
class Base
  attr_reader :worklog

  def initialize(source_file, output_path)
    @worklog=WorkLog.new(source_file)
    @output_path=output_path
    @base_path=File.dirname(__FILE__)
  end

  def generate!
    # Calculate the stats from the file
    locals={}
    @worklog.stats.each { |key, data| locals[key]=data }
    process_haml(locals)
    return true
  end

private

  def process_haml(locals)
    # Inject them into the HAML layout
    haml=nil
    File.open(File.join(@base_path, 'logstats', 'template.haml'), 'r') do |f|
      haml=f.read
    end
    engine = Haml::Engine.new(haml)
    html=engine.render(LogStats::Helpers, locals)

    # Save the HAML to a file
    File.open(@output_path, 'w') do |f|
      f << html
    end
    return true
  end
end
end

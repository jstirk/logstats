require 'lib/tail_from_sentinel'
require 'time'

# Parses my own WorkLog file format and extracts the stats for the past month
class WorkLog < TailFromSentinel::Base
  DATE_SENTINEL_REGEX=/(\d+)([A-Z]+)(\d{4})?$/i
  WORKLOG_RECORD_REGEX=/(\d{2})(\d{2}) (.*) (\d{2})(\d{2})$/i
  OPEN_WORKLOG_RECORD_REGEX=/(\d{2})(\d{2}) (.*)$/i

  DATE_SENTINEL_PROC=Proc.new do |line|
    if line =~ DATE_SENTINEL_REGEX then
      # It's a date marker - parse it to see whether it's close enough to when we want
      day,month,year=self.parse_sentinel($1, $2, $3)
      (month.downcase == self.now.strftime('%b').downcase) && (year.to_i == self.now.year)
    end
  end

  def self.now
    @@now ||= Time.now
  end

  def self.last_seen_year
    @@last_seen_year
  end

  def self.last_seen_year=(year)
    @@last_seen_year=year
  end

  def self.parse_sentinel(d,m,y)
    year=y || self.last_seen_year
    self.last_seen_year=year
    [ d, m, year ]
  end

  def initialize(filename)
    @last_seen_year=nil
    @stas=nil
    super(File.open('/Users/j_stirk/worklog-active.txt', 'r'), &DATE_SENTINEL_PROC)
  end

  # TODO: Document this
  def stats
    return @stats unless @stats.nil?

    days={}
    now=WorkLog.now
    current_time=nil

    data.each do |line|
      line=line.strip
      case line
        when DATE_SENTINEL_REGEX
          # It's a date marker - set current_time
          current_time=Time.parse(WorkLog.parse_sentinel($1,$2,$3).reverse.join('-'))
          days[current_time]={ :total => 0, :projects => {} }

        when WORKLOG_RECORD_REGEX
          # It's a worklog record - parse it, and add it to the relevant buckets
          duration, project=parse_worklog_record(current_time, $1, $2, $3, $4, $5)

          days[current_time][:total] += duration
          days[current_time][:projects][project] ||= 0
          days[current_time][:projects][project] += duration

        when OPEN_WORKLOG_RECORD_REGEX
          duration, project=parse_worklog_record(current_time, $1, $2, $3)
          days[:current]=duration
          
        when /^\s*$/
          # Blank line - ignore
        else
         puts "Warning: Unknown format of \"#{line}\""
      end
    end
    @stats=compile_day_data(days)
  end

  def parse_worklog_record(current_time, sh,sm,msg,eh=nil,em=nil)
    start_time=current_time + (sh.to_i * 3600) + (sm.to_i * 60)

    if eh && em then
      end_time=current_time + (eh.to_i * 3600) + (em.to_i * 60)
      end_time += (24 * 3600) if end_time < start_time
    else
      end_time=Time.now
    end
    duration=end_time - start_time

    if msg.match(/^([A-Z0-9]{3})/) then
      project=$1
    else
      project='MISC'
    end
    [ duration, project ]
  end

  def compile_day_data(days)
    stats={ :current => days[:current],
            :today  => { :total => 0,
                         :projects => { }
                       },
            :week   => { :total => 0,
                         :average => 0,
                         :projects => { }
                       },
            :month  => { :total => 0,
                         :average => 0,
                         :days_logged => 0,
                         :projects => { }
                       }
          }

    now=WorkLog.now
    today=Date.today

    days.each do |time, data|
      next if time == :current

      # It's data for today - use it
      stats[:today]=data if time.day == now.day

      if time.to_date.cweek == today.cweek then
        stats[:week][:total] += data[:total]
        stats[:week][:average] = (stats[:week][:total] / time.to_date.wday.to_f)
        data[:projects].each do |project, duration|
          stats[:week][:projects][project] ||= 0
          stats[:week][:projects][project] += duration
        end
      end

      # Everything is included in this month
      stats[:month][:total] += data[:total]
      stats[:month][:days_logged] += 1
      stats[:month][:average] = (stats[:month][:total] / stats[:month][:days_logged])
      data[:projects].each do |project, duration|
        stats[:month][:projects][project] ||= 0
        stats[:month][:projects][project] += duration
      end
    end

    stats[:today][:total] += days[:current]
    #stats[:today][:projects]['WIP'] = days[:current]

    return stats
  end
end

class Time
  def to_date
    Date.new(self.year, self.month, self.day)
  end
end

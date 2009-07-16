require 'yaml'

require 'rubygems'
require 'curb'

require 'hcl/day_entry'

class HCl
  class UnknownCommand < RuntimeError; end

  def self.command *args
    command = args.shift
    unless command
      help
      return
    end
    hcl = new.process_args *args
    if hcl.respond_to? command
      hcl.send command
    else
      raise UknownCommand, "unrecognized command `#{command}'"
    end
  end

  def initialize
    config = YAML::load(File.read('hcl_conf.yml'))
    TimesheetResource.configure config
  end

  def self.help
    puts <<-EOM
    Usage:

    hcl [opts] add <project> <task> <duration> [msg]
    hcl [opts] rm [entry_id]
    hcl [opts] start <project> <task> [msg]
    hcl [opts] stop [msg]
    hcl [opts] show [date]
    EOM
  end
  def help; self.class.help; end

  def process_args *args
    # TODO process command-line args
    self
  end

  def show
    total_hours = 0.0
    DayEntry.all.each do |day|
      # TODO more information and formatting options
      puts "#{day.task} / #{day.hours}"
      total_hours = total_hours + day.hours.to_f
    end
    puts "Total #{total_hours} hours"
  end

  def not_implemented
    puts "not yet implemented"
  end

  # TODO implement the following commands
  alias start not_implemented
  alias stop not_implemented
  alias add not_implemented
  alias rm not_implemented

end

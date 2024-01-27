require "reline"

module Riu
  class CLI
    attr_accessor :argv
    attr_accessor :prompt
    attr_accessor :use_history

    def initialize(argv)
      @argv = argv
      @prompt = "riu> "
      @use_history = true
    end

    def run
      loop do
        text = Reline.readline(prompt, use_history)
        case text
        when nil
          break
        when ""
          puts "Use C-d to exit"
        end

        p text
      end
    rescue Interrupt
      puts "^C"
      exit
    end
  end
end

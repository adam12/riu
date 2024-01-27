require "reline"
require "rdoc"

# @ri.list_methods_matching("parse")
module Riu
  class Visitor
    def accept_heading(v)
      puts "= #{v.text}"
    end

    def accept_blank_line(v)
      puts
    end

    def accept_paragraph(v)
      puts v.text
    end

    def accept_rule(v)
      puts "=" * 80
    end

    def accept_verbatim(v)
      puts v.text
    end
  end

  class CLI
    attr_accessor :argv
    attr_accessor :prompt
    attr_accessor :use_history

    def initialize(argv)
      @argv = argv
      @prompt = "riu> "
      @use_history = true
      @ri = RDoc::RI::Driver.new
    end

    def run
      # require "debug"; debugger
      loop do
        text = Reline.readline(prompt, use_history)
        case text
        when nil
          break
        when ""
          puts "Use C-d to exit"
        else
          name = @ri.expand_name(text)
          filtered = @ri.lookup_method(name)

          method_out = @ri.method_document(name, filtered)
          visitor = Visitor.new
          method_out.parts.each { |part| part.accept(visitor) }
          # @ri.find_methods(name) do |store, klass, ancestor, types, method|
          #   p "Klass: #{klass} #{method}"
          #   p TYPES: types
          # end
        end
      rescue RDoc::RI::Driver::NotFoundError
        puts "Not found"
      end
    rescue Interrupt
      puts "^C"
      exit
    end
  end
end

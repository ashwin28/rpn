# type ruby rpn.rb, to start the script in interactive mode
# other uses:
##  ruby rpn.rb -h
##  ruby rpn.rb test_cases/test_case_1.txt
##  ruby rpn.rb test_cases/test_case_*
##  ruby rpn.rb --D=#,# test_cases/test_cases_for_delimiter.txt
##  ruby rpn.rb < test_cases/test_case_1.txt
##  cat test_cases/test_case_1.txt | ruby rpn.rb 
##  ruby rpn.rb --D=#,# < test_cases/test_cases_for_delimiter.txt
##  ruby rpn.rb --MF=true test_cases/test_cases.txt

##Specifications
##  The calculator should use standard input and standard output, unless the language makes that impossible.
##  It should implement the four standard arithmetic operators.
##  It should support negative and decimal numbers, and should not have arbitrary limits on the number of operations.
##  The calculator should not allow invalid or undefined behavior.
##  The calculator should exit when it receives a q command or an end of input indicator (EOF).

# added to parse options given to script
require 'optparse'

# added some custom methods to ruby classes
require_relative 'string_improvements_ad'
require_relative 'numeric_improvements_ad'

# add methods to help read from file
require_relative 'read_from_file_ad'

# add some errors
require_relative 'custom_errors'

# add to this array to expand functionality
ALLOWED_OPERATIONS = %w(+ - * / % ** /% c5)

# add to this array to protect division from 0 on operators
PROTECT_FROM_ZERO = %w(/ % /%)

# add to this array to allow operations on single values
ALLOW_SINGLE_OPERATIONS = %w(c5)

# current user promt
PROMPT = "> "

# round to 2 decimal
ROUND_TO = 2

class RPNCalculator
  include CustomErrors

  attr_reader :input_stack, :decimal_mode

  def initialize
    # array to hold input
    @input_stack = []

    # prints output with decimal point when true
    @decimal_mode = false
  end

  def prompt(output="")
    print "#{output}\n#{PROMPT}"
  end

  def exit_condition(input="")
    input.downcase == "q"
  end

  def zero_condition(token)
    @input_stack.last == 0 && PROTECT_FROM_ZERO.include?(token)
  end

  def single_value_operation(token)
    @input_stack.size >= 1 && ALLOW_SINGLE_OPERATIONS.include?(token)
  end

  def reset_condition(token)
    token.downcase == "reset"
  end

  def show_stack_condition(token)
    token.downcase == "stack"
  end

  def show_help_condition(token)
    token.downcase == "help"
  end

  def reset_calculator
    @input_stack = []
    @decimal_mode = false
    # alerts user in interactive mode
    if $0 == __FILE__ && ARGV.empty? && STDIN.tty?
      7.times { print "."*Random.rand(5..8); sleep(0.1) }
      prompt("Calculator is reset!")
    end
  end

  def intro_text
    puts "Welcome to Reverse Polish Notation calculator version 0.1!\n"\
    "This version currently supports these operators +, -, *, /, % (modulo)"\
    ", ** (power), /% (absolute percentage) and c5 (cube it and add 5).\n"\
    "Enter q or EOF(produced by pressing Ctrl+D on Unix and Ctrl+Z on Windows) to quit\n"\
    "Enter reset to wipe memory, stack to display all values, help for info:"
  end

  def exit_text
    puts "\nThank you for using Reverse Polish Notation calculator!"
  end

  def calculate(token)
    result = validate_token(token)
    # prevents output in unit test
    prompt(result) if $0 == __FILE__
  end

  def perform_operation(token)
    # call single value operation method when needed
    return perform_single_operation(token) if ALLOW_SINGLE_OPERATIONS.include?(token)

    # get last value in stack
    last = @input_stack.pop

    result = @input_stack.pop.send(token, last)
    format_result(result)
  end

  def perform_single_operation(token)
    result = @input_stack.pop.send(token)
    format_result(result)
  end

  # formats the result to integer if possible when decimal mode is not explicitly set
  def format_result(result)
    result.true_integer? && !@decimal_mode ? result.to_i : result.round(ROUND_TO)
  end

  def validate_token(token)
    # adds valid number to stack
    if token.numeric?
      # track if user inputs a float
      @decimal_mode = true if token.has_decimal_point?

      @input_stack << token.to_numeric
      return token
    end

    # check to see if token is one of our allowed operators
    if !ALLOWED_OPERATIONS.include?(token)
      raise TokenError, "value is not a supported numeric operator"
    end

    # added to support my custom c5 operation
    if single_value_operation(token)
      # add the result to stack
      @input_stack << perform_single_operation(token)
      return @input_stack.last
    end

    # calculate only when there is enough numbers in the stack
    if @input_stack.size >= 2
      raise ZeroDivisionError if zero_condition(token)

      # add the result to stack
      @input_stack << perform_operation(token)

      return @input_stack.last
    else
      raise CountError, "additional numeric values required to perform arithmetic operation"
    end
  end

  def interactive
    intro_text
    prompt

    # this block will exit when eof is recieved
    STDIN.each do |line|
      # remove newline
      line.chomp!

      # exit condition
      break if exit_condition(line)

      # reset stored values
      if reset_condition(line)
        reset_calculator
        next
      end

      # show stored values
      if show_stack_condition(line)
        prompt(@input_stack)
        next
      end

      # show info message again
      if show_help_condition(line)
        prompt(intro_text)
        next
      end

      begin
        calculate(line)
      rescue ZeroDivisionError
        prompt("Dividing by 0 is invalid!")
      rescue CountError
        prompt("Remember that you require some numeric values to perform arithmetic operations!")
      rescue TokenError
        prompt("Please enter numeric values, supported operators or commands!"\
               "\nEnter help for info")
      end
    end
    exit_text
  end

  # uses input from pipe or file(s) provided to calculate
  def input_from_file(line)
    line.chomp!
    puts line

    calculate(line)
    rescue ZeroDivisionError
      prompt("Dividing by 0 is invalid!")
    rescue CountError
      prompt("Remember that you require some numeric values to perform arithmetic operations!")
    rescue TokenError
      prompt("Please enter numeric values, supported operators or commands!"\
             "\nEnter help for info")
  end
end

# if the first argument is this file, then run as a script
if $0 == __FILE__
  calculator = RPNCalculator.new()

  # parse any options included
  options = Hash.new(" ")
  OptionParser.new do |opt|
    opt.on('-m','--MF=TRUE', 'Using a file containing a list of files(in same dir).') { options[:multiple_file] = true }
    opt.on('--D=DELIMITER', 'Using specified delimiter.') { |o| options[:delimiter] = o }
    opt.on("\nExtended Usage:\n",
           "\tcat filename | ruby rpn.rb   For a unix pipe.\n"\
           "\truby rpn.rb < filename       For a redirect.\n"\
           "\truby rpn.rb filename(s)      For giving filenames as arguments.")
  end.parse!

  # run interactive version if there are no other arguments or text from pipe
  calculator.interactive if ARGV.empty? && options.empty? && STDIN.tty?

  # check for stdin via pipe
  if !STDIN.tty? && pipe = $stdin.read
    puts "Processing input from stdin ..."
    print PROMPT
    pipe.split("\n").each do |line|
      # process each line from stdin
      ReadFromFileAd::process_line(line ,calculator, options) if options[:multiple_file] != true
    end
    puts "Finished Processing...\n\n"
  else
    # read input from files
    ReadFromFileAd::parse_input_file(calculator, options) if ARGV.any? && options[:multiple_file] != true

    # read files from files
    ReadFromFileAd::parse_files_from_files(calculator, options) if ARGV.any? && options[:multiple_file] == true
  end
end

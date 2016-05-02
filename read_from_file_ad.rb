module ReadFromFileAd
  # process file(s) given via cmd line arguments
  def self.parse_input_file(calculator, opt)
    ARGV.each { |file_name| process_file(file_name, calculator, opt) }
  end

  # process a list of files in the same directory
  def self.parse_files_from_files(calculator, opt)
    # get current dir
    dir = File.dirname(ARGV[0]) + '/'
    IO.foreach(ARGV[0]) do |file_name|
      process_file((dir+file_name).chomp, calculator, opt)
    end
  end

  # process a single file
  def self.process_file(file_name, calculator, opt)
    puts "Processing #{file_name} ..."
    print PROMPT
    IO.foreach(file_name) { |line| process_line(line ,calculator, opt) }
    puts "Finished Processing #{file_name} ...\n\n"
  end

  # process a single line of text
  def self.process_line(line ,calculator, opt)
    # check for any delimiters, default is " "
    if line.include?(opt[:delimiter])
      line.chomp!
      puts "Processing input: [#{line}] with delimiter: #{opt[:delimiter].inspect} ..."
      print PROMPT
      line.split(opt[:delimiter]).each { |value| calculator.input_from_file(value) }
      puts "Finished Processing input: [#{line}] ...\n"
      calculator.reset_calculator
    else
      calculator.input_from_file(line)
    end
  end
end
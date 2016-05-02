require_relative "rpn.rb"
require "test/unit"

class TestRpn < Test::Unit::TestCase

  def setup
    @calculator = RPNCalculator.new()
  end

  # String.numeric?
  def test_numeric?
    assert_equal true, "23".numeric?
    assert_equal true, "23.5".numeric?
    assert_equal true, "-3.5".numeric?

    assert_equal false, "boat".numeric?
    assert_equal false, "+".numeric?
    assert_equal false, "..".numeric?
  end

  # String.has_decimal_point?
  def test_has_decimal_point?
    assert_equal true, "42.2".has_decimal_point?
    assert_equal false, "0001".has_decimal_point?
  end

  # String.to_numeric
  def test_to_numeric
    int = "22".to_numeric
    assert_equal 22.0, int
    assert_equal Float, int.class

    float = "23.5".to_numeric
    assert_equal 23.5, float
    assert_equal Float, float.class
  end

  # Numeric.true_integer?
  def test_true_integer?
    assert_equal true, 4.true_integer?
    assert_equal true, 4.0.true_integer?
    assert_equal false, 4.4.true_integer?
  end

  # check new instance variables
  def test_new_calculator
    assert_equal false, @calculator.decimal_mode
    assert_equal true, @calculator.input_stack.empty?
  end

  def test_exit_condition
    assert_equal true, @calculator.exit_condition("Q")
    assert_equal true, @calculator.exit_condition("q")

    assert_equal false, @calculator.exit_condition("asdf")
  end

  def test_zero_condition
    @calculator.calculate("1")
    @calculator.calculate("0")

    assert_equal [1.0, 0.0], @calculator.input_stack

    assert_raise( CustomErrors::ZeroDivisionError ) { @calculator.calculate("/") }
    assert_raise( CustomErrors::ZeroDivisionError ) { @calculator.calculate("%") }
    assert_raise( CustomErrors::ZeroDivisionError ) { @calculator.calculate("/%") }
  end

  def test_reset_condition
    @calculator.calculate("1.0")

    assert_equal true, @calculator.reset_condition("reset")
    assert_equal false, @calculator.reset_condition("asdf")

    assert_equal [1.0], @calculator.input_stack
    assert_equal true, @calculator.decimal_mode

    @calculator.reset_calculator

    assert_equal true, @calculator.input_stack.empty?
    assert_equal false, @calculator.decimal_mode
  end

  def test_decimal_mode
    perform(["10.0", "4", "-"], Float, 6.0)
    assert_equal [6.0], @calculator.input_stack

    @calculator.reset_calculator
    perform(["10", "4", "+"], Fixnum, 14)
    assert_equal [14], @calculator.input_stack
  end

  def test_show_stack_condition
    assert_equal true, @calculator.show_stack_condition("stack")
    assert_equal false, @calculator.show_stack_condition("asdf")

    assert_equal [], @calculator.input_stack
    perform(["3", "2", "1"], Float, 1)
    assert_equal [3.0, 2.0, 1.0], @calculator.input_stack
  end

  def test_show_help_condition
    assert_equal true, @calculator.show_help_condition("help")
    assert_equal false, @calculator.show_help_condition("asdf")
  end

  def test_errors
    assert_raise( CustomErrors::TokenError ) { @calculator.calculate("boat") }
    @calculator.calculate("1.0")
    assert_raise( CustomErrors::CountError ) { @calculator.calculate("+") }
  end

  def test_addition
    perform(["1", "10", "+"], Fixnum, 11)
    perform(["-28", "4", "+"], Fixnum, -24)
    perform(["-9", "-4", "+"], Fixnum, -13)
    perform(["2.3", "4", "+"], Float, 6.3)
  end

  def test_subtraction
    perform(["28", "4", "-"], Fixnum, 24)
    perform(["-30", "4", "-"], Fixnum, -34)
    perform(["-30", "-4", "-"], Fixnum, -26)
    perform(["1.3", ".4", "-"], Float, 0.9)
  end

  def test_multiplication
    perform(["3", "4", "*"], Fixnum, 12)
    perform(["-10", "4", "*"], Fixnum, -40)
    perform(["-10", "-33", "*"], Fixnum, 330)
    perform(["3.2", "4", "*"], Float, 12.8)
  end

  def test_division
    perform(["28", "4", "/"], Fixnum, 7)
    perform(["32", "-8", "/"], Fixnum, -4)
    perform(["-62", "-2", "/"], Fixnum, 31)
    perform(["10.3", "2", "/"], Float, 5.15)
  end

  def test_modulo
    perform(["28", "4", "%"], Fixnum, 0)
    perform(["-30", "4", "%"], Fixnum, 2)
    perform(["-55", "-8", "%"], Fixnum, -7)
    perform(["32.5", "8", "%"], Float, 0.5)
    perform(["32.5", ".3", "%"], Float, 0.1)
    perform(["32.5", "-.3", "%"], Float, -0.2)
  end

  def test_power
    perform(["2", "4", "**"], Fixnum, 16)
    perform(["-3", "3", "**"], Fixnum, -27)
    perform(["-3", "4", "**"], Fixnum, 81)
    perform(["-1", "-8", "**"], Fixnum, 1)
    perform(["0", "7", "**"], Fixnum, 0)
    perform(["11", "0", "**"], Fixnum, 1)
    perform(["25", ".5", "**"], Float, 5.0)
  end

  def test_cube_and_add_5
    perform(["1", "c5"], Fixnum, 6)
    perform(["-2", "c5"], Fixnum, -3)
    perform(["0.0", "c5"], Float, 5.0)
    perform(["1.4", "c5"], Float, 7.74)
  end

  def test_percentage
    perform(["2", "4", "/%"], Fixnum, 50)
    perform(["1.3", "4", "/%"], Float, 32.5)
    perform(["-1.3", "4.9", "/%"], Float, 26.53)
  end

  def test_given_case_1
    perform(["5", "8", "+"], Fixnum, 13)
  end

  def test_given_case_2
    perform(["-3", "-2", "*", "5", "+"], Fixnum, 11)
  end

  def test_given_case_3
    perform(["2", "9", "3", "+", "*"], Fixnum, 24)
  end

  def test_given_case_4
    perform(["20", "13", "-", "2", "/"], Float, 3.5)
  end

  # perform takes an array of input, result.class, result
  def perform(array, *args)

    array.each { |i| @calculator.calculate(i) }

    assert_equal args[0], @calculator.input_stack.last.class
    assert_equal args[1], @calculator.input_stack.last
  end
end

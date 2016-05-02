# playing around with minitest specs
require_relative "rpn.rb"
require "minitest/autorun"


describe "RPNSpecs" do
  before { @calculator = RPNCalculator.new() }

  describe "String" do
    it "must respond to numeric?" do
      "23".numeric?.must_equal(true)
      "23.5".numeric?.must_equal(true)
    
      "boat".numeric?.must_equal(false)
      "+".numeric?.must_equal(false)
    end
  end
end
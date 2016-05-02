class Numeric
  # checks if the float can be represented as an integer without any data loss
  def true_integer?
    self % 1 == 0
  end

  # returns self as a percentage of the value
  def percentage(value)
    self.abs.fdiv(value) * 100
  end

  # returns (self ^ 3) + 5, custom addition
  def cube_and_add_five
    self.send("**", 3) + 5
  end

  alias_method "/%", :percentage
  alias_method "c5", :cube_and_add_five
end

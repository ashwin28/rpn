class String
  # check if string can be converted into a numeric representation
  def numeric?
    return true if self =~ (/^[-]?[0-9]*\.?[0-9]+$/)
    false
  end

  # returns true for a string with a decimal point
  def has_decimal_point?
    self.include?('.')
  end

  # returns the numeric representation of a string as a float
  def to_numeric
    Float(self)
  end
end
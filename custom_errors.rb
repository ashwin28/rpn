module CustomErrors
  class ZeroDivisionError < ZeroDivisionError
  end

  # custom error to handle invalid input
  class TokenError < TypeError
  end

  class CountError < TokenError
  end
end
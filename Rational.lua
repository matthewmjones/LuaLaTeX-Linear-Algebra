Rational = {
    numerator = 0,
    denominator = 1
}

function Rational:new(t, numerator, denominator)
    t = t or {}
    setmetatable(t, self)
    self.__index = self
    self.numerator = numerator or 0
    self.denominator = denominator or 1
    t = lowest_form(t)
    return t
end

function Rational.ONE()
    return Rational:new(nil, 1, 1)
end

function Rational.ZERO()
    return Rational:new(nil, 0, 1)
end

function lowest_form(t)
    -- Put into lowest form using Euclid's algorithm
    local a = t.numerator
    local b = t.denominator
    while b ~= 0 do
        a, b = b, a % b
    end
    -- a now contains the gcd
    t.numerator = t.numerator // a
    t.denominator = t.denominator // a
    return t
end

function Rational:multiply(R)
    local result = Rational:new()

    if type(R) == "number" then
        result.numerator = self.numerator * R
        result.denominator = self.denominator
    else
        result.numerator = self.numerator * R.numerator
        result.denominator = self.denominator * R.denominator
    end
    result = lowest_form(result)
    return result
end

function Rational:divide(R)
    local result = Rational:new()

    if type(R) == "number" then
        result.numerator = self.numerator
        result.denominator = self.denominator * R
    else
        result.numerator = self.numerator * R.denominator
        result.denominator = self.denominator * R.numerator
    end
    result = lowest_form(result)
    return result
end

function Rational:add(R)
    local result = Rational:new()

    if type(R) == "number" then
        R = Rational:new({numerator = R, denominator = 1})
    end
    result.numerator = self.numerator * R.denominator + R.numerator * self.denominator
    result.denominator = self.denominator * R.denominator
    result = lowest_form(result)
    return result
end

function Rational:subtract(R)
    local result = Rational:new()

    if type(R) == "number" then
        R = Rational:new({numerator = R, denominator = 1})
    end
    result.numerator = self.numerator * R.denominator - R.numerator * self.denominator
    result.denominator = self.denominator * R.denominator
    result = lowest_form(result)
    return result
end

function Rational:abs()
    local result = Rational:new()
    if self.numerator < 0 then
        result.numerator = -self.numerator
    else
        result.numerator = self.numerator
    end
    result.denominator = self.denominator
    return result
end

function Rational:reciprocal()
    local result = Rational:new()
    result.numerator = self.denominator
    result.denominator = self.numerator
    return result    
end

function Rational:isequal(R)
    if type(R) == "number" then
        R = Rational:new({numerator = R, denominator = 1})
    end
    return (self.numerator == R.numerator and self.denominator == R.denominator)
end

function Rational:islessthan(R)
    if type(R) == "number" then
        R = Rational:new({numerator = R, denominator = 1})
    end
    return (self.numerator * R.denominator < self.denominator * R.numerator)
end

function Rational:isgreaterthan(R)
    if type(R) == "number" then
        R = Rational:new({numerator = R, denominator = 1})
    end
    return (self.numerator * R.denominator > self.denominator * R.numerator)
end

function Rational:islessthanorequal(R)
    if type(R) == "number" then
        R = Rational:new({numerator = R, denominator = 1})
    end
    return (self.numerator * R.denominator <= self.denominator * R.numerator)
end

function Rational:isgreaterthanorequal(R)
    if type(R) == "number" then
        R = Rational:new({numerator = R, denominator = 1})
    end
    return (self.numerator * R.denominator >= self.denominator * R.numerator)
end

function Rational:tostring()
    if self.denominator == 1 then
        return tostring(self.numerator)
    else
        return tostring(self.numerator).."/"..tostring(self.denominator)
    end
end

function Rational:totexstring(xfrac)
    xfrac = xfrac or false
    local fraccommand = xfrac and "\\sfrac" or "\\frac"
    if self.denominator == 1 then
        return tostring(self.numerator)
    else
        if self.numerator < 0 then
            return "-" .. fraccommand.."{" .. tostring(-self.numerator).."}{"..tostring(self.denominator).."}"
        else
            return fraccommand.."{" .. tostring(self.numerator).."}{"..tostring(self.denominator).."}"
        end
    end
end
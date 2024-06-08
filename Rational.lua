Rational = {
    numerator = 0,
    denominator = 1
}

function Rational:new(t, numerator, denominator)
    t = t or {}
    setmetatable(t, self)
    self.__index = self
    self.__type = "Rational"
    self.numerator = numerator or 0
    self.denominator = denominator or 1
    t = lowest_form(t)
    return t
end

function Rational.ONE()
    return Rational:new({numerator = 1, denominator = 1})
end

function Rational.ZERO()
    return Rational:new({numerator = 0, denominator = 1})
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

function Rational.__mul(r,s)
    local result = Rational:new()

    if type(r) == "number" then
        r = Rational:new(nil, r, 1)
    end
    if type(s) == "number" then
        s = Rational:new(nil, s, 1)
    end
    
    result.numerator = s.numerator * r.numerator
    result.denominator = s.denominator * r.denominator

    result = lowest_form(result)
    return result
end

function Rational.__div(r,s)
    local result = Rational:new()

    if type(r) == "number" then
        r = Rational:new(nil, r, 1)
    end
    if type(s) == "number" then
        s = Rational:new(nil, s, 1)
    end
    
    result.numerator = r.numerator * s.denominator
    result.denominator = r.denominator * s.numerator
    
    result = lowest_form(result)
    return result
end

function Rational.__add(r, s)
    local result = Rational:new()

    if type(r) == "number" then
        r = Rational:new(nil, r, 1)
    end
    if type(s) == "number" then
        s = Rational:new(nil, s, 1)
    end

    result.numerator = r.numerator * s.denominator + s.numerator * r.denominator
    result.denominator = r.denominator * s.denominator
    result = lowest_form(result)
    return result
end

function Rational.__sub(r,s)
    local result = Rational:new()

    if type(r) == "number" then
        r = Rational:new(nil, r, 1)
    end
    if type(s) == "number" then
        s = Rational:new(nil, s, 1)
    end

    result.numerator = r.numerator * s.denominator - s.numerator * r.denominator
    result.denominator = r.denominator * s.denominator
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
    return 1/self
end

function Rational.__eq(r,s)
    return (r.numerator == s.numerator and r.denominator == s.denominator)
end

function Rational.__lt(r,s)
    return (r.numerator * s.denominator < r.denominator * s.numerator)
end

function Rational.__le(r,s)
    return (r.numerator * s.denominator <= r.denominator * s.numerator)
end

function Rational.__tostring(r)
    if r.denominator == 1 then
        return tostring(r.numerator)
    else
        return tostring(r.numerator).."/"..tostring(r.denominator)
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
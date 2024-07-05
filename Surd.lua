require "Rational"

Surd = {
    first = Rational:ZERO(),
    second = Rational:ZERO(),
    base = 2
}

function Surd:new(t, first, second, base)
    t = t or {}
    setmetatable(t, self)
    self.__index = self

    if type(first) == "number" then
        first = Rational:new(nil, first)
    end
    if type(second) == "number" then
        second = Rational:new(nil, second)
    end

    t.first = first or Rational:ZERO()
    t.second = second or Rational:ZERO()
    t.base = base or 2
    findlowestbase(t)
    return t
end


-- Smallest terms

local primes = {
    2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97
}

function findlowestbase(r)
    local N = r.base
    local prod = 1
    for i = 1, #primes do
        local psq = primes[i] * primes[i]
        if N % psq == 0 then
            while N % psq == 0 and N ~= 0 do
                prod = prod * psq
                N = N // psq
            end
        end
    end
    if N == 1 then
        error("Surd: cannot convert integer to surd")
    end
    r.base = N
    r.second = r.second * prod
end

function Surd:hasSameBase(s)
    return (s.base == self.base)
end

function Surd:isComplex()
    return self.base < 0
end

function Surd.__add(r,s)
    if r:hasSameBase(s) then
        local result = Surd:new()
        result.base = r.base
        result.first = r.first + s.first
        result.second = r.second + s.second 
        return result
    else
        error("Surd: Cannot do arithmetic with different bases")
    end
end

function Surd.__sub(r,s)
    if r:hasSameBase(s) then
        local result = Surd:new()
        result.base = r.base
        result.first = r.first - s.first
        result.second = r.second - s.second
        return result
    else
        error("Surd: Cannot do arithmetic with different bases")
    end
end

function Surd.__mul(r,s)
    if r:hasSameBase(s) then
        local result = Surd:new()
        result.base = r.base
        result.first = r.first * s.first + Rational:new(nil,r.base) * s.second * r.second
        result.second = r.first * s.second + r.second * s.first
        return result
    else
        error("Surd: Cannot do arithmetic with different bases")
    end
end

function Surd.__div(r,s)
    if r:hasSameBase(s) then
        local denom = s.first * s.first - Rational:new(nil, s.base) * s.second * s.second

        local result = Surd:new()
        result.base = r.base
        result.first = (r.first * s.first - Rational:new(nil,r.base) * s.second * r.second) / denom
        result.second = (r.second * s.first - r.first * s.second) / denom
        return result
    else
        error("Surd: Cannot do arithmetic with different bases")
    end
end

function Surd.__tostring(r)
    local basestr = ""
    if r.base == -1 then
        basestr = "i"
    elseif r.base <0  then
        basestr = "i√" .. (-r.base)
    else
        basestr = "√" .. r.base
    end

    if r.second >= Rational:ZERO() then
        if r.second == Rational:ONE() then
            return tostring(r.first) .. " + " .. basestr
        else
            return tostring(r.first) .. " + " .. tostring(r.second) .. basestr
        end
    else
        if r.second == Rational:new(nil,-1) then
            return tostring(r.first) .. "-" .. basestr
        else
            return tostring(first) .. tostring(r.second) .. basestr
        end
    end
end

function Surd:totexstring(xfrac)
    xfrac = xfrac or false

    if self.base == -1 then
        basestr = "i"
    elseif self.base <0  then
        basestr = "i\\sqrt{" .. (-self.base) .. "}"
    else
        basestr = "\\sqrt{" .. self.base .."}"
    end

    if self.second >= Rational:ZERO() then
        if self.second == Rational:ONE() then
            return self.first:totexstring(xfrac) .. " + " .. basestr
        else
            return self.first:totexstring(xfrac) .. " + " .. self.second:totexstring(xfrac) .. basestr
        end
    else
        if self.second == Rational:new(nil,-1) then
            return self.first:totexstring() .. "-" ..basestr
        else
            return self.first:totexstring() .. self.second:totexstring() .. basestr
        end
    end
end

-- Return the solution to the quadratic ax^2 + bx + c = 0 whose
-- second value is positive. a,b,c are assumed to be integers
function Surd:solvequadratic(a, b, c)
    local f = Rational:new(nil, -b, 2*a)
    local s = Rational:new(nil, 1, 2*a)
    local bs = b * b - 4 * a * c

    if bs == 0 then
        return f
    else 
        return Surd:new(nil, f, s, bs)
    end
end

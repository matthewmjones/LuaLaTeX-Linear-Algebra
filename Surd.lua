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
    t.first = first or Rational:ZERO()
    t.second = second or Rational:ZERO()
    t.base = base or 2
    return t
end

function Surd:hasSameBase(s)
    return (s.base == self.base)
end

function Surd:isComples()
    return self.base < 0
end

function Surd:add(s)
    if self:hasSameBase(s) then
        local result = Surd:new()
        result.base = self.base
        result.first = self.first:add(s.first)
        result.second = self.second:add(s.second)
        return result
    else
        error("Surd: Cannot do arithmetic with different bases")
    end
end

function Surd:subtract(s)
    if self:hasSameBase(s) then
        local result = Surd:new()
        result.base = self.base
        result.first = self.first:subtract(s.first)
        result.second = self.second:subtract(s.second)
        return result
    else
        error("Surd: Cannot do arithmetic with different bases")
    end
end

function Surd:multiply(s)
    if self:hasSameBase(s) then
        local result = Surd:new()
        result.base = self.base
        result.first = self.first:multiply(s.first):add(Rational:new(nil,self.base):multiply(s.second):multiply(self.second))
        result.second = self.first:multiply(s.second):add(self.second:multiply(s.first))
        return result
    else
        error("Surd: Cannot do arithmetic with different bases")
    end
end

function Surd:divide(s)
    if self:hasSameBase(s) then
        local denom = (s.first:multiply(s.first)):subtract(
            (Rational:new(nil, s.base)):multiply(s.second):multiply(s.second)
        )

        local result = Surd:new()
        result.base = self.base
        result.first = (self.first:multiply(s.first):subtract(Rational:new(nil,self.base):multiply(s.second):multiply(self.second))):divide(denom)
        result.second = (self.second:multiply(s.first):subtract(self.first:multiply(s.second))):divide(denom)
        return result
    else
        error("Surd: Cannot do arithmetic with different bases")
    end
end

function Surd:tostring()
    local basestr = ""
    if self.base < 0 then
        basestr = "i√" .. (-self.base)
    else
        basestr = "√" .. self.base
    end

    if self.second:isgreaterthanorequal(Rational:ZERO()) then
        if self.second:isequal(Rational:ONE()) then
            return self.first:tostring() .. " + " .. basestr
        else
            return self.first:tostring() .. " + " .. self.second:tostring() .. basestr
        end
    else
        if self.second:isequal(Rational:new(nil,-1)) then
            return self.first:tostring() .. "-" .. basestr
        else
            return self.first:tostring() .. self.second:tostring() .. basestr
        end
    end
end

function Surd:totexstring(xfrac)
    xfrac = xfrac or false

    if self.base < 0 then
        basestr = "i\\sqrt{" .. (-self.base) .. "}"
    else
        basestr = "\\sqrt{" .. self.base .. "}"
    end

    if self.second:isgreaterthanorequal(Rational:ZERO()) then
        if self.second:isequal(Rational:ONE()) then
            return self.first:totexstring(xfrac) .. " + " .. basestr
        else
            return self.first:totexstring(xfrac) .. " + " .. self.second:totexstring(xfrac) .. basestr
        end
    else
        if self.second:isequal(Rational:new(nil,-1)) then
            return self.first:totexstring() .. "-" ..basestr
        else
            return self.first:totexstring() .. self.second:totexstring() .. basestr
        end
    end
end
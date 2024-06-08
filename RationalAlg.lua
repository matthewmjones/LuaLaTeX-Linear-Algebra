RationalAlg = {}

require "Rational"

function RationalAlg.MatrixToTeX(m,xfrac)
    xfrac = xfrac or false
    local result = "\\begin{pmatrix}"
        for a = 1, #m do
            for b = 1, #m[a] do
                result = result .. m[a][b]:totexstring(xfrac)
                if b < #m[a] then
                    result = result .. "&"
                else 
                    result = result .. "\\\\"
                end
            end
        end
    result = result .. "\\end{pmatrix}"
    return result
end

function RationalAlg.MatrixToString(m)
    local result = ""
        for a = 1, #m do
            result = result .. "( "
            for b = 1, #m[a] do
                result = result .. tostring(m[a][b])
                if b < #m[a] then
                    result = result .. "  "
                else 
                    result = result .. " )\n"
                end
            end
        end
    return result
end

function RationalAlg.RandomMatrix(rows, cols, integer)
    integer = integer or false
    local M = {}
    for a = 1, rows do
        M[a] = {}
        for b = 1, cols do
            if integer then
                M[a][b] = Rational:new({
                    numerator = math.random(-5,5),1})
            else
                M[a][b] = Rational:new({
                    numerator = math.random(-5,5),
                    denominator = math.random(1,10)})
            end            
        end
    end
    return M
end

function RationalAlg.ZeroMatrix(rows, cols)
    local M = {}
    for a = 1, rows do
        M[a] = {}
        for b = 1, cols do
            M[a][b] = Rational.ZERO()
        end
    end
    return M
end

function RationalAlg.IdentityMatrix(n)
    local M = {}
    for a = 1, n do
        M[a] = {}
        for b = 1, n do
            if a == b then
                M[a][b] = Rational.ONE()
            else
                M[a][b] = Rational.ZERO()
            end
        end
    end
    return M
end

function RationalAlg.GetNumberOfRows(m)
    return #m
end

function RationalAlg.GetNumberOfCols(m)
    return #m[1]
end

function RationalAlg.EqualSize(m,n)
    return (RationalAlg.GetNumberOfRows(m) == RationalAlg.GetNumberOfRows(n)) and (RationalAlg.GetNumberOfCols(m) == RationalAlg.GetNumberOfCols(n))
end

function RationalAlg.GetColumn(m, col1)
    local col = RationalAlg.ZeroMatrix(RationalAlg.GetNumberOfRows(m), 1)
    for i = 1, RationalAlg.GetNumberOfRows(m) do
        col[i][1] = m[i][col1]
    end
    return col
end

function RationalAlg.GetRow(m, row1)
    local row = RationalAlg.ZeroMatrix(RationalAlg.GetNumberOfCols(m), 1)
    for i = 1, RationalAlg.GetNumberOfCols(m) do
        row[i][1] = m[row1][i]
    end
    return row
end

-- converts a columns vector to an array for easier processing
function RationalAlg.ToArray(m)
    local arr = {}
    for i = 1, RationalAlg.GetNumberOfRows(m) do
        arr[i] = m[i][1]
    end
    return arr
end

function RationalAlg.DotProduct(m,n)
    if RationalAlg.EqualSize(m,n) and RationalAlg.GetNumberOfCols(m) == 1 then
        local result = Rational.ZERO()
        for i = 1, RationalAlg.GetNumberOfRows(m) do
            result = result + m[i][1] * n[i][1]
        end
        return result
    else 
        print("Error: attempting to find the dot product of different sized matrices")
        return nil
    end
end

function RationalAlg.Add(m,n)
    if RationalAlg.EqualSize(m, n) then
        for i = 1, RationalAlg.GetNumberOfRows(m) do
            for j = 1, RationalAlg.GetNumberOfCols(m) do
                m[i][j] = m[i][j] + n[i][j]
            end
        end
        return m
    else 
        print("Error: attempting to add two different sized matrices")
        return m
    end
end

function RationalAlg.Multiply(m,n)
    if RationalAlg.GetNumberOfCols(m) == RationalAlg.GetNumberOfRows(n) then
        local result = RationalAlg.ZeroMatrix(RationalAlg.GetNumberOfRows(m), RationalAlg.GetNumberOfCols(n))
        for i = 1, RationalAlg.GetNumberOfRows(m) do
            for j = 1, RationalAlg.GetNumberOfCols(n) do
                result[i][j] = RationalAlg.DotProduct(
                    RationalAlg.GetRow(m,i),
                    RationalAlg.GetColumn(n,j)
                )
            end
        end
        return result
    else
        print("Error: attempting to multiply two incompatible matrices")
        return m
    end
end

function RationalAlg.IsSquare(m)
    return (RationalAlg.GetNumberOfRows(m) == RationalAlg.GetNumberOfCols(m))
end

-- Row operations will all start with RO
function RationalAlg.ROSwap(m, row1, row2)
    if row1 ~= row2 then
        local row = m[row1]
        m[row1] = m[row2]
        m[row2] = row
    end
    return m
end

function RationalAlg.ROAdd(m, row1, row2)
    for i = 1, RationalAlg.GetNumberOfCols(m) do
        m[row1][i] = m[row1][i] + m[row2][i]
    end
    return m
end

function RationalAlg.ROMult(m, row1, const)
    if type(const) == "number" then
        const = Rational:new({numerator = const, denominator = 1})
    end

    if const ~= Rational.ONE() then
        for i = 1, RationalAlg.GetNumberOfCols(m) do
            m[row1][i] = m[row1][i] * const
        end
    end
    return m
end

function RationalAlg.CopyMatrix(t)
    local u = { }
    for k, v in pairs(t) do
        u[k] = {table.unpack(v)}
    end
    return  setmetatable(u, getmetatable(t))
end

-- Gaussian elimination

function RationalAlg.Augment(m, n)
    if RationalAlg.GetNumberOfRows(m) ~= RationalAlg.GetNumberOfRows(n) then
        print("Error: cannot produce augmented matrix")
        return
    end

    local p = {}
    for i = 1, #m do
        p[i] = {}
        for j = 1, #m[1] + #n[1] + 1 do
            if j <= #n then
                p[i][j] = m[i][j]
            else
                p[i][j] = n[i][j - #m]
            end
        end
    end
    setmetatable(p, getmetatable(m))
    return p
end

-- returns the two matrices formed by splitting the matrix
function RationalAlg.Split(m, c)
    local cols = RationalAlg.GetNumberOfCols(m)
    local rows = RationalAlg.GetNumberOfRows(m)

    if cols == c then
        return m
    end

    if cols < c then
        return nil, nil
    end

    if cols > c then
        local leftmat = {}
        local rightmat = {}

        for i = 1, rows do
            leftmat[i] = {}
            rightmat[i] = {}

            for j = 1, cols do
                if j <= c then
                    leftmat[i][j] = m[i][j]
                else
                    rightmat[i][j - c] = m[i][j]
                end
            end
        end
        return leftmat, rightmat
    end
end

function RationalAlg.GaussianRowReduce(m)
    local result = {}
    -- the result will be a table {row operation = matrix }
    local h = 1
    local k = 1

    while (h <= RationalAlg.GetNumberOfRows(m)) and (k <= RationalAlg.GetNumberOfCols(m)) do
        local i_max = 0
        local v_max = Rational:ZERO()
        for i = h, RationalAlg.GetNumberOfRows(m) do
            if m[i][k]:abs():isgreaterthan(v_max) then
                i_max = i
                v_max = m[i][k]:abs()
            end
        end

        if v_max == Rational:ZERO() then 
            k = k + 1
        else
            m = RationalAlg.ROSwap(m,h, i_max)
            for i = h + 1, RationalAlg.GetNumberOfRows(m) do
                local f = m[i][k] / m[h][k]
                m[i][k] = Rational:ZERO()
                for j = k + 1, RationalAlg.GetNumberOfCols(m) do
                    m[i][j] = m[i][j] - m[h][j] * f
                end
            end
            h = h + 1
            k = k + 1
        end
    end
    return m
end

function RationalAlg.GaussJordanRowReduce(mat)
    local m = mat
    local result = {{"",RationalAlg.CopyMatrix(m)}}

    -- the result will be a table {row operation = matrix }
    local h = 1
    local k = 1

    while (h <= RationalAlg.GetNumberOfRows(m)) and (k <= RationalAlg.GetNumberOfCols(m)) do
        local indx = 0
        local val = Rational:ZERO()
        for i = h, RationalAlg.GetNumberOfRows(m) do
            if m[i][k] ~= Rational:ZERO() then
                indx = i
                val = m[i][k]
                break
            end
        end

        if val == Rational:ZERO() then
            k = k + 1
        else
            if indx ~= h then
                m = RationalAlg.ROSwap(m,h, indx)
                table.insert(result, {"R_" .. h .. " ↔︎ R_" .. indx, RationalAlg.CopyMatrix(m)})
            end
            if val ~= Rational:ONE() then
                m = RationalAlg.ROMult(m,h, val:reciprocal())
                if val > Rational:ZERO() then
                    table.insert(result, {"R_" .. h .. " ← " .. tostring(val:reciprocal()) .." R_" .. h, RationalAlg.CopyMatrix(m)})
                else
                    table.insert(result, {"R_" .. h .. " ← -" .. tostring(val:abs():reciprocal()) .." R_" .. h, RationalAlg.CopyMatrix(m)})
                end
            end
            m[h][k] = Rational:ONE()

            for i = 1, RationalAlg.GetNumberOfRows(m) do
                if i ~= h then
                    local mult = m[i][k]
                    m[i][k] = Rational:ZERO()
                    for j = k + 1, RationalAlg.GetNumberOfCols(m) do
                        m[i][j] = m[i][j] - m[h][j] * mult
                    end
                    if mult > Rational:ZERO() then
                        table.insert(result, {"R_".. i .. " ← R_" .. i .. " - " .. tostring(mult) .. " R_" .. h, RationalAlg.CopyMatrix(m)})
                    else
                        table.insert(result, {"R_".. i .. " ← R_" .. i .. " + " .. tostring(mult:abs()) .. " R_" .. h, RationalAlg.CopyMatrix(m)})
                    end
                end
            end

            h = h + 1
            k = k + 1
        end
    end
    return m, result
end

function RationalAlg.RowOpListToString(r)
    local str = ""
    for i = 1, #r do
        str = str .. r[i][1] .. "\n" .. RationalAlg.MatrixToString(r[i][2]) .. "\n"
    end
    return str
end

function RationalAlg.RowOpListToTeX(result, cols, xfrac)
    cols = cols or 2
    xfrac = xfrac or false
    local str = "\\begin{alignat*}{"..(2*cols-1).."}"
    str = str .. "&"..RationalAlg.MatrixToTeX(result[1][2],xfrac)
    for i = 2, #result do
        local rop = string.gsub(result[i][1],"←","\\leftarrow")
        local mat = RationalAlg.MatrixToTeX(result[i][2],xfrac)
        if i % cols == 1 then
            str = str .. "\\\\\\xrightarrow{\\mbox{\\small $".. rop .. "$}}&" .. mat
        else
            str = str .. "&&\\xrightarrow{\\mbox{\\small $"..rop .. "$}}&&" .. mat
        end
    end

    return str .. "\\end{alignat*}"
end
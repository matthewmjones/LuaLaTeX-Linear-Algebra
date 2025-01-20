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

function RationalAlg.StringToMatrix(str)
    -- Remove whitespace and validate basic structure
    str = str:gsub("%s+", "")
    if not str:match("^{.*}$") then
        if tex then
            tex.error("Error: Invalid matrix format. Must be enclosed in curly braces")
        else 
            error("Error: Invalid matrix format. Must be enclosed in curly braces")
        end        
        return nil
    end
    
    -- Remove outer braces
    str = str:sub(2, -2)
    
    local matrix = {}
    local row = 1
    local currentRow = {}
    
    -- Process the string character by character
    local i = 1
    while i <= #str do
        if str:sub(i,i) == "{" then
            currentRow = {}
            i = i + 1
            local numStr = ""
            
            while i <= #str and str:sub(i,i) ~= "}" do
                local char = str:sub(i,i)
                if char == "," then
                    -- Convert the accumulated number string to Rational
                    if numStr ~= "" then
                        local num, denom = 1, 1
                        if numStr:find("/") then
                            -- Ensure we convert to integers for LuaTeX
                            local numPart = numStr:match("(.+)/")
                            local denomPart = numStr:match("/(.+)")
                            num = math.floor(tonumber(numPart) or 1)
                            denom = math.floor(tonumber(denomPart) or 1)
                        else
                            num = math.floor(tonumber(numStr) or 1)
                            denom = 1
                        end
                        table.insert(currentRow, Rational:new(nil, num, denom))
                        numStr = ""
                    end
                else
                    numStr = numStr .. char
                end
                i = i + 1
            end
            
            -- Handle the last number in the row
            if numStr ~= "" then
                local num, denom = 1, 1
                if numStr:find("/") then
                    -- Ensure we convert to integers for LuaTeX
                    local numPart = numStr:match("(.+)/")
                    local denomPart = numStr:match("/(.+)")
                    num = math.floor(tonumber(numPart) or 1)
                    denom = math.floor(tonumber(denomPart) or 1)
                else
                    num = math.floor(tonumber(numStr) or 1)
                    denom = 1
                end
                table.insert(currentRow, Rational:new(nil, num, denom))
            end
            
            matrix[row] = currentRow
            row = row + 1
        end
        i = i + 1
    end
    
    return matrix
end


function RationalAlg.RandomMatrix(rows, cols, integer)

    if rows <=0 or cols <= 0 then
        if tex then
            tex.error("Error: (RandomMatrix) Attempting to create a matrix with non-positive numbers of rows or columns")
        else 
            error("Error: (RandomMatrix) Attempting to create a matrix with non-positive numbers of rows or columns")
        end
    end

    integer = integer or false
    local M = {}
    for a = 1, rows do
        M[a] = {}
        for b = 1, cols do
            if integer then
                M[a][b] = Rational:new({
                    numerator = math.random(-3,5),1})
            else
                M[a][b] = Rational:new({
                    numerator = math.random(-3,5),
                    denominator = math.random(1,10)})
            end            
        end
    end
    return M
end

function RationalAlg.ZeroMatrix(rows, cols)

    if rows <=0 or cols <= 0 then
        if tex then
            tex.error("Error: (ZeroMatrix) Attempting to create a matrix with non-positive numbers of rows or columns")
        else 
            error("Error: (ZeroMatrix) Attempting to create a matrix with non-positive numbers of rows or columns")
        end
    end

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

    if n <=0  then
        if tex then
            tex.error("Error: (IdentityMatrix) Attempting to create a matrix with non-positive numbers of rows or columns")
        else 
            error("Error: (IdentityMatrix) Attempting to create a matrix with non-positive numbers of rows or columns")
        end
    end

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

function RationalAlg.SetColumn(m, col1, newcolumn)
    -- check size of matrix includes column
    if RationalAlg.GetNumberOfCols(m) < col1 or RationalAlg.GetNumberOfRows(m) ~= RationalAlg.GetNumberOfRows(newcolumn) then
        if tex then
            tex.error("Error: (SetColumn) Incompatible sizes")
        else 
            error("Error: (SetColumn) Incompatible sizes")
        end
    end

    for i = 1, RationalAlg.GetNumberOfRows(m) do
        m[i][col1] = newcolumn[i][1]
    end
    return m
end

function RationalAlg.GetRow(m, row1)
    local row = RationalAlg.ZeroMatrix(RationalAlg.GetNumberOfCols(m), 1)
    for i = 1, RationalAlg.GetNumberOfCols(m) do
        row[i][1] = m[row1][i]
    end
    return row
end

function RationalAlg.SetRow(m, row1, newrow)
    -- check size of matrix includes row
    if RationalAlg.GetNumberOfRows(m) < row1 or RationalAlg.GetNumberOfCols(m) ~= RationalAlg.GetNumberOfCols(newrow) then
        if tex then
            tex.error("Error: (SetRow) Incompatible sizes")
        else 
            error("Error: (SetRow) Incompatible sizes")
        end
    end

    for i = 1, RationalAlg.GetNumberOfCols(m) do
        m[row1][i] = newrow[1][i]
    end
    return m
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
    if  not RationalAlg.EqualSize(m,n) or RationalAlg.GetNumberOfCols(m) > 1 then
        if tex then
            tex.error("Error: (DotProduct) Incompatible sizes")
        else 
            error("Error: (DotProduct) Incompatible sizes")
        end
    end

    local result = Rational.ZERO()
    for i = 1, RationalAlg.GetNumberOfRows(m) do
        result = result + m[i][1] * n[i][1]
    end
    return result
end

function RationalAlg.Add(m,n)
    if  not RationalAlg.EqualSize(m, n) then
        if tex then
            tex.error("Error: (Add) Incompatible sizes")
        else 
            error("Error: (Add) Incompatible sizes")
        end
    end
    local a = RationalAlg.CopyMatrix(m)
    for i = 1, RationalAlg.GetNumberOfRows(m) do
        for j = 1, RationalAlg.GetNumberOfCols(m) do
            a[i][j] = m[i][j] + n[i][j]
        end
    end
    return a
end

function RationalAlg.Subtract(m,n)
    if not RationalAlg.EqualSize(m, n) then
        if tex then
            tex.error("Error: (Add) Incompatible sizes")
        else 
            error("Error: (Add) Incompatible sizes")
        end
    end

    for i = 1, RationalAlg.GetNumberOfRows(m) do
        for j = 1, RationalAlg.GetNumberOfCols(m) do
            m[i][j] = m[i][j] - n[i][j]
        end
    end
    return m
end

function RationalAlg.Multiply(m,n)
    if RationalAlg.GetNumberOfCols(m) ~= RationalAlg.GetNumberOfRows(n) then
        if tex then
            tex.error("Error: (Multiply) Incompatible sizes")
        else 
            error("Error: (Multiply) Incompatible sizes")
        end
    end

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
end

function RationalAlg.MultiplyByScalar(m,s)
    if type(s) == "number" then
        s = Rational:new(nil, s)
    end
    local result = RationalAlg.ZeroMatrix(RationalAlg.GetNumberOfRows(m), RationalAlg.GetNumberOfCols(m))
        for i = 1, RationalAlg.GetNumberOfRows(m) do
            for j = 1, RationalAlg.GetNumberOfCols(m) do
                result[i][j] = s * m[i][j]
            end
        end
    return result
end

function RationalAlg.Transpose(m)
    local tr = RationalAlg.RandomMatrix(
        RationalAlg.GetNumberOfCols(m), RationalAlg.GetNumberOfRows(m)
    )
    for i = 1, RationalAlg.GetNumberOfCols(m) do
        for j = 1, RationalAlg.GetNumberOfRows(m) do
            tr[i][j] = m[j][i]
        end
    end
    return tr
end

function RationalAlg.IsSquare(m)
    return (RationalAlg.GetNumberOfRows(m) == RationalAlg.GetNumberOfCols(m))
end

-- Row operations will all start with RO
function RationalAlg.ROSwap(m, row1, row2)
    local a = RationalAlg.CopyMatrix(m)
    if row1 ~= row2 then
        local row = a[row1]
        a[row1] = a[row2]
        a[row2] = row
    end
    return a
end

function RationalAlg.ROAdd(m, row1, row2)
    local a = RationalAlg.CopyMatrix(m)
    for i = 1, RationalAlg.GetNumberOfCols(m) do
        a[row1][i] = a[row1][i] + a[row2][i]
    end
    return a
end

function RationalAlg.ROMult(m, row1, const)
    local a = RationalAlg.CopyMatrix(m)
    if type(const) == "number" then
        const = Rational:new({numerator = const, denominator = 1})
    end

    if const ~= Rational.ONE() then
        for i = 1, RationalAlg.GetNumberOfCols(m) do
            a[row1][i] = a[row1][i] * const
        end
    end
    return a
end

function RationalAlg.ROMultAndAdd(m,row1, row2, const)
    local a = RationalAlg.CopyMatrix(m)
    if type(const) == "number" then
        const = Rational:new({numerator = const, denominator = 1})
    end

    for i = 1, RationalAlg.GetNumberOfCols(a) do
        a[row1][i] = a[row1][i] + a[row2][i] * const
    end
    return a
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
        if tex then
            tex.error("Error: (Augment) Attempting to augment two incompatible matrices")
        else 
            error("Error: (Augment) Attempting to augment two incompatible matrices")
        end
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
    local m = RationalAlg.CopyMatrix(mat)
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
                    elseif mult < Rational:ZERO() then
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
    local rop = string.gsub(
        string.gsub(result[i][1], "←", "\\leftarrow"),
        "↔︎", "\\longleftrightarrow"
    )
        local mat = RationalAlg.MatrixToTeX(result[i][2],xfrac)
        if i % cols == 1 then
            str = str .. "\\\\\\xrightarrow{\\mbox{\\small $".. rop .. "$}}&" .. mat
        else
            str = str .. "&&\\xrightarrow{\\mbox{\\small $"..rop .. "$}}&&" .. mat
        end
    end

    return str .. "\\end{alignat*}"
end
RationalAlg = {}

require "Rational"

--[[
List of functions in RationalAlg.lua

1) RationalAlg.MatrixToTeX(m, xfrac)
   Inputs:
     - m: A matrix
     - xfrac (optional): Boolean (default false), controlling fraction display
   Output:
     - A string containing the matrix using AMSLaTeX pmatrix environment

2) RationalAlg.MatrixToString(m)
   Inputs:
     - m: A matrix
   Output:
     - A string representation of the matrix in curly brace format

3) RationalAlg.StringToMatrix(str)
   Inputs:
     - str: A string in a curly-braced format representing a matrix
   Output:
     - A matrix

4) RationalAlg.RandomMatrix(rows, cols, integer)
   Inputs:
     - rows: Integer, number of rows
     - cols: Integer, number of columns
     - integer (optional): Boolean; if true, uses integer-only entries
   Output:
     - A matrix of random numbers

5) RationalAlg.ZeroMatrix(rows, cols)
   Inputs:
     - rows: Integer, number of rows
     - cols: Integer, number of columns
   Output:
     - A zero matrix of given size

6) RationalAlg.IdentityMatrix(n)
   Inputs:
     - n: Integer, size of the identity matrix
   Output:
     - An n×n identity matrix of Rational objects

7) RationalAlg.GetNumberOfRows(m)
   Inputs:
     - m: A matrix
   Output:
     - Integer count of rows in m

8) RationalAlg.GetNumberOfCols(m)
   Inputs:
     - m: A matrix
   Output:
     - Integer count of columns in m

9) RationalAlg.EqualSize(m, n)
   Inputs:
     - m, n: Two 2D tables (matrices)
   Output:
     - Boolean indicating if m and n have the same dimensions

10) RationalAlg.GetColumn(m, col1)
    Inputs:
      - m: A matrix
      - col1: Integer, column index
    Output:
      - The column number col1 of m as a single-column matrix

11) RationalAlg.SetColumn(m, col1, newcolumn)
    Inputs:
      - m: A matrix
      - col1: Integer, column index
      - newcolumn: Single-column matrix to insert at col1
    Output:
      - The modified matrix m with the specified column replaced

12) RationalAlg.GetRow(m, row1)
    Inputs:
      - m: A matrix
      - row1: Integer, row index
    Output:
      - A single-column matrix representing that row

13) RationalAlg.SetRow(m, row1, newrow)
    Inputs:
      - m: A matrix
      - row1: Integer, row index
      - newrow: Single-row matrix to assign at row1
    Output:
      - The modified matrix m with that row replaced

14) RationalAlg.ToArray(m)
    Inputs:
      - m: A matrix
    Output:
      - An array

15) RationalAlg.DotProduct(m, n)
    Inputs:
      - m, n: Single-column matrices of the same size
    Output:
      - The dot product of m and n

16) RationalAlg.Add(m, n)
    Inputs:
      - m, n: Two matrices of the same dimensions
    Output:
      - A new matrix that is the element-wise sum of m and n

17) RationalAlg.Subtract(m, n)
    Inputs:
      - m, n: Two matrices of the same dimensions
    Output:
      - The matrix m after subtracting n from it element-wise

18) RationalAlg.Multiply(m, n)
    Inputs:
      - m: A×B matrix
      - n: B×C matrix
    Output:
      - An A×C matrix (the product m × n)

19) RationalAlg.MultiplyByScalar(m, s)
    Inputs:
      - m: A matrix
      - s: A number or Rational object
    Output:
      - A matrix with each element multiplied by s

20) RationalAlg.Transpose(m)
    Inputs:
      - m: A matrix
    Output:
      - The transpose of m

21) RationalAlg.isSquare(m)
    Inputs:
      - m: A matrix
    Output:
      - Boolean indicating whether m has an equal number of rows and columns

22) RationalAlg.isUpperTriangular(m)
    Inputs:
      - m: A matrix
    Output:
      - Boolean indicating whether m is an upper triangular matrix

23) RationalAlg.isLowerTriangular(m)
    Inputs:
      - m: A matrix
    Output:
      - Boolean indicating whether m is a lower triangular matrix

24) RationalAlg.Inverse(m)
    Inputs:
      - m: An n×n square matrix
    Output:
      - The inverse matrix of m (if it exists), or nil if not invertible

25) RationalAlg.ROSwap(m, row1, row2)
    Inputs:
      - m: A matrix
      - row1, row2: Row indices
    Output:
      - A new matrix with the specified rows swapped

26) RationalAlg.ROAdd(m, row1, row2)
    Inputs:
      - m: A matrix
      - row1, row2: Row indices
    Output:
      - A new matrix with row1 replaced by (row1 + row2)

27) RationalAlg.ROMult(m, row1, const)
    Inputs:
      - m: A matrix
      - row1: Row index
      - const: A number or Rational representing the multiplier
    Output:
      - A new matrix with row1 scaled by const

28) RationalAlg.ROMultAndAdd(m, row1, row2, const)
    Inputs:
      - m: A matrix
      - row1, row2: Row indices
      - const: A number or Rational
    Output:
      - A new matrix with row1 replaced by row1 + (row2 × const)

29) RationalAlg.CopyMatrix(t)
    Inputs:
      - t: A matrix
    Output:
      - A new matrix that is a copy of t

30) RationalAlg.Augment(m, n)
    Inputs:
      - m, n: Two matrices with the same number of rows
    Output:
      - A new matrix formed by appending n’s columns to m

31) RationalAlg.Split(m, c)
    Inputs:
      - m: A matrix
      - c: Integer column index at which to split
    Output:
      - Two matrices: left (first c columns) and right (remaining columns)

32) RationalAlg.isRREF(matrix)
    Inputs:
      - matrix: A matrix
    Output:
      - If matrix is in row-reduced echelon form: returns an integer rank
      - Otherwise: returns false

33) RationalAlg.isREF(matrix)
    Inputs:
      - matrix: A matrix
    Output:
      - If matrix is in row echelon form: returns an integer rank
      - Otherwise: returns false

34) RationalAlg.GaussJordanRowReduce(mat)
    Inputs:
      - mat: A matrix
    Output:
      - The matrix in RREF form
      - A list of row operations performed
      - The rank (integer) of the matrix

35) RationalAlg.RowEchelon(mat)
    Inputs:
      - mat: A matrix
    Output:
      - The matrix in REF form
      - A list of row operations performed
      - The rank (integer) of the matrix

36) RationalAlg.RowOpListToString(r)
    Inputs:
      - r: A table of row operations and intermediate matrices
    Output:
      - A string representation of the row operations

37) RationalAlg.RowOpListToTeX(result, cols, xfrac)
    Inputs:
      - result: A table describing row operation steps
      - cols (optional): How many matrices per row in the TeX output
      - xfrac (optional): Boolean controlling fraction display
    Output:
      - A TeX-formatted string showing each step of the row operations

38) RationalAlg.PLUDecomposition(A)
    Inputs:
      - A: a matrix
    Output:
      - P, L, U: matrices such that PA = LU that provide a PLU-decomposition of A 
]]


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
    local result = "{ "
    for i = 1, #m do
        result = result .. "{"
        for j = 1, #m[i] do
            result = result .. tostring(m[i][j])
            if j < #m[i] then
                result = result .. ","
            end
        end
        result = result .. "}"
        if i < #m then
            result = result .. ","
        end
    end
    result = result .. " }"
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
    if not RationalAlg.EqualSize(m,n) or RationalAlg.GetNumberOfCols(m) > 1 then
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
    if not RationalAlg.EqualSize(m, n) then
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

    local a = RationalAlg.CopyMatrix(m)
    for i = 1, RationalAlg.GetNumberOfRows(m) do
        for j = 1, RationalAlg.GetNumberOfCols(m) do
            a[i][j] = m[i][j] - n[i][j]
        end
    end
    return a
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

function RationalAlg.isSquare(m)
    return (RationalAlg.GetNumberOfRows(m) == RationalAlg.GetNumberOfCols(m))
end

function RationalAlg.isUpperTriangular(m)
    if not RationalAlg.isSquare(m) then
        return false
    end

    if RationalAlg.GetNumberOfRows(m) == 1 then
        return true
    end

    local result = true
    for i = 1, RationalAlg.GetNumberOfRows(m) do
        for j = 1, i - 1 do
            if m[i][j] ~= Rational.ZERO() then
                result = false
            end
        end
    end
    return result
end

function RationalAlg.isLowerTriangular(m)
    return RationalAlg.isUpperTriangular(RationalAlg.Transpose(m))
end


function RationalAlg.Inverse(m) 
    if not RationalAlg.isSquare(m) then
        if tex then
            tex.error("Error: (Inverse) Unable to find inverses of non-square matrices")
        else 
            error("Error: (Multiply) Unable to find inverses of non-square matrices")
        end
    end
    
    -- n is the size of the square matrix
    local n = #m
    -- augment matrix and identity
    local aug = RationalAlg.Augment(RationalAlg.CopyMatrix(m), RationalAlg.IdentityMatrix(n))

    -- Perform a full Gauss-Jordan
    M = RationalAlg.GaussJordanRowReduce(aug)
    local l, r = RationalAlg.Split(M, n)
    local Rank = RationalAlg.isRREF(l)
    if Rank < n then 
        return nil
    else 
        return r
    end
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

    
    local totalRows = RationalAlg.GetNumberOfRows(m)
    local p = {}

    for i = 1, totalRows do
        local row = m[i]
        for _, v in ipairs(n[i]) do
            table.insert(row, v)
        end
        p[i] = row
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

function RationalAlg.isRREF(matrix)
    local rank = 0
    local leadingColumn = 0
    
    for i = 1, #matrix do
        local row = matrix[i]
        local foundLeadingOne = false
        
        for j = 1, #row do
            if row[j] == Rational.ONE() then
                -- Check if the leading 1 satisfies RREF conditions
                if j <= leadingColumn then
                    return false -- Leading 1 not to the right of the previous leading 1
                end
                
                -- Check if the column of the leading 1 is zero elsewhere
                for k = 1, #matrix do
                    if k ~= i and matrix[k][j] ~= Rational.ZERO() then
                        return false -- Non-zero value in the column of leading 1
                    end
                end
                
                leadingColumn = j
                foundLeadingOne = true
                rank = rank + 1
                break
            elseif row[j] ~= Rational.ZERO() then
                return false -- Non-zero value before leading 1
            end
        end
        
        -- If the row has non-zero values but no leading 1, it's invalid
        if not foundLeadingOne and not isZeroRow(row) then
            return false
        end
    end
    
    return rank
end

function RationalAlg.isREF(matrix)
    local rank = 0
    local leadingColumn = 0
    
    for i = 1, #matrix do
        local row = matrix[i]
        local foundLeadingEntry = false
        
        for j = 1, #row do
            if row[j] ~= Rational.ZERO() then
                -- Check if the leading entry satisfies REF conditions
                if j <= leadingColumn then
                    return false -- Leading entry not to the right of the previous leading entry
                end
                
                -- Check if the column of the leading entry is zero below
                for k = i + 1, #matrix do
                    if matrix[k][j] ~= Rational.ZERO() then
                        return false -- Non-zero value below the leading entry
                    end
                end
                
                leadingColumn = j
                foundLeadingEntry = true
                rank = rank + 1
                break
            end
        end
        
        -- If the row has no leading entry, it must be a zero row
        if not foundLeadingEntry and not isZeroRow(row) then
            return false
        end
    end
    
    return rank
end

-- Helper function to check if a row is all zeros
function isZeroRow(row)
    for _, value in ipairs(row) do
        if value ~= Rational.ZERO() then
            return false
        end
    end
    return true
end

-- Function to execute the Gauss-Jordan elimination algorithm 
-- Input: Matrix mat
-- Output: Matrix M in Row Reduced Echelon Form, RowOperations R, Rank r
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
    return m, result, RationalAlg.isRREF(m)
end

-- Function to find the Row Echelon form of a matrix 
-- Input: Matrix mat
-- Output: Matrix M in Row Reduced Echelon Form, RowOperations R, Rank r
function RationalAlg.RowEchelon(mat)
    local m = RationalAlg.CopyMatrix(mat)
    local result = {{"",RationalAlg.CopyMatrix(m)}}

    -- the result will be a table {row operation list, matrix}
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

            for i = h + 1, RationalAlg.GetNumberOfRows(m) do
                
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

            h = h + 1
            k = k + 1
        end
    end
    return m, result, RationalAlg.isREF(m)
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

function RationalAlg.PLUDecomposition(A)
    if not RationalAlg.isSquare(A) then
        if tex then
            tex.error("Error: (PLUDecomposition) Cannot find the PLU-decomposition of a non-square matrix")
        else 
            error("Error: (PLUDecomposition) Cannot find the PLU-decomposition of a non-square matrix")
        end
    end

    local n = RationalAlg.GetNumberOfRows(A)
    local P = RationalAlg.IdentityMatrix(n)
    local L = RationalAlg.IdentityMatrix(n)
    local U = RationalAlg.CopyMatrix(A)

    for k = 1, n-1 do
        local pivotRow = k
        local maxVal = Rational.abs(U[k][k])
        for i = k+1, n do
            if Rational.abs(U[i][i]) > maxVal then
                maxVal = Rational.abs(U[i][i])
                pivotRow = i
            end
        end

        if pivotRow ~= k then
            U = RationalAlg.ROSwap(U, k, pivotRow)
            P = RationalAlg.ROSwap(P, k, pivotRow)

            if k > 1 then
                -- swap rows from L between k and pivotRow up to column k-1
                local left, right = RationalAlg.Split(L, k-1)
                left = RationalAlg.ROSwap(left, k, pivotRow)
                L = RationalAlg.Augment(left, right)
            end
        end

        for i = k+1, n do
            L[i][k] = U[i][k] / U[k][k]

            for j = k, n do
                U[i][j] = U[i][j] - L[i][k] * U[k][j]
            end
        end
    end

    return P, L, U
end
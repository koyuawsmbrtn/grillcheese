-- GrillCheese Script Compiler

local compiler = {}

-- Token types
local TOKEN_TYPES = {
    IDENTIFIER = "IDENTIFIER",
    NUMBER = "NUMBER",
    STRING = "STRING",
    KEYWORD = "KEYWORD",
    OPERATOR = "OPERATOR",
    PUNCTUATION = "PUNCTUATION",
    NEWLINE = "NEWLINE",
    EOF = "EOF"
}

-- Keywords
local KEYWORDS = {
    "if", "then", "else", "end", "while", "do", "for", "in", "function", "fn", "return", "break", "continue",
    "local", "true", "false", "nil", "and", "or", "not", "array", "length", "string", "bool", "int", "float",
    "priv", "pub", "import", "export", "from", "table"
}

-- Lexer
local function tokenize(source)
    local tokens = {}
    local pos = 1
    local line = 1
    local col = 1
    
    local function peek(n)
        n = n or 1
        return source:sub(pos, pos + n - 1)
    end
    
    local function advance(n)
        n = n or 1
        local char = source:sub(pos, pos)
        if char == '\n' then
            line = line + 1
            col = 1
        else
            col = col + 1
        end
        pos = pos + n
        return char
    end
    
    local function isWhitespace(char)
        return char == ' ' or char == '\t' or char == '\r'
    end
    
    local function isAlpha(char)
        return (char >= 'a' and char <= 'z') or (char >= 'A' and char <= 'Z') or char == '_'
    end
    
    local function isDigit(char)
        return char >= '0' and char <= '9'
    end
    
    local function isAlphaNumeric(char)
        return isAlpha(char) or isDigit(char)
    end
    
    while pos <= #source do
        local char = peek()
        
        -- Skip whitespace
        if isWhitespace(char) then
            advance()
        -- Comments
        elseif char == '-' and pos + 1 <= #source and source:sub(pos + 1, pos + 1) == '-' then
            -- Skip to end of line
            while pos <= #source and peek() ~= '\n' do
                advance()
            end
        elseif char == '/' and pos + 1 <= #source and source:sub(pos + 1, pos + 1) == '/' then
            -- Skip to end of line
            while pos <= #source and peek() ~= '\n' do
                advance()
            end
        -- Newline
        elseif char == '\n' then
            table.insert(tokens, {type = TOKEN_TYPES.NEWLINE, value = '\n', line = line, col = col})
            advance()
        -- String literals
        elseif char == '"' or char == "'" then
            local quote = advance()
            local value = ""
            while pos <= #source and peek() ~= quote do
                if peek() == '\\' and pos + 1 <= #source then
                    advance() -- skip backslash
                    local next = advance()
                    if next == 'n' then
                        value = value .. '\n'
                    elseif next == 't' then
                        value = value .. '\t'
                    elseif next == 'r' then
                        value = value .. '\r'
                    elseif next == '\\' then
                        value = value .. '\\'
                    elseif next == quote then
                        value = value .. quote
                    else
                        value = value .. next
                    end
                else
                    value = value .. advance()
                end
            end
            if pos <= #source then
                advance() -- consume closing quote
            end
            table.insert(tokens, {type = TOKEN_TYPES.STRING, value = value, line = line, col = col})
        -- Numbers
        elseif isDigit(char) then
            local value = ""
            while pos <= #source and (isDigit(peek()) or peek() == '.') do
                value = value .. advance()
            end
            table.insert(tokens, {type = TOKEN_TYPES.NUMBER, value = value, line = line, col = col})
        -- Identifiers and keywords
        elseif isAlpha(char) then
            local value = ""
            while pos <= #source and isAlphaNumeric(peek()) do
                value = value .. advance()
            end
            local tokenType = TOKEN_TYPES.IDENTIFIER
            for _, keyword in ipairs(KEYWORDS) do
                if value == keyword then
                    tokenType = TOKEN_TYPES.KEYWORD
                    break
                end
            end
            table.insert(tokens, {type = tokenType, value = value, line = line, col = col})
        -- Operators and punctuation
        else
            local value = char
            local tokenType = TOKEN_TYPES.PUNCTUATION
            
            -- Multi-character operators
            if char == '=' and pos + 1 <= #source and source:sub(pos + 1, pos + 1) == '=' then
                value = advance() .. advance()
                tokenType = TOKEN_TYPES.OPERATOR
            elseif char == '~' and pos + 1 <= #source and source:sub(pos + 1, pos + 1) == '=' then
                value = advance() .. advance()
                tokenType = TOKEN_TYPES.OPERATOR
            elseif char == '<' and pos + 1 <= #source and source:sub(pos + 1, pos + 1) == '=' then
                value = advance() .. advance()
                tokenType = TOKEN_TYPES.OPERATOR
            elseif char == '>' and pos + 1 <= #source and source:sub(pos + 1, pos + 1) == '=' then
                value = advance() .. advance()
                tokenType = TOKEN_TYPES.OPERATOR
            elseif char == '<' and pos + 1 <= #source and source:sub(pos + 1, pos + 1) == '<' then
                value = advance() .. advance()
                tokenType = TOKEN_TYPES.OPERATOR
            elseif char == '>' and pos + 1 <= #source and source:sub(pos + 1, pos + 1) == '>' then
                value = advance() .. advance()
                tokenType = TOKEN_TYPES.OPERATOR
            elseif char == '!' and pos + 1 <= #source and source:sub(pos + 1, pos + 1) == '=' then
                value = advance() .. advance()
                tokenType = TOKEN_TYPES.OPERATOR
            elseif char == '|' and pos + 1 <= #source and source:sub(pos + 1, pos + 1) == '|' then
                value = advance() .. advance()
                tokenType = TOKEN_TYPES.OPERATOR
            elseif char == '&' and pos + 1 <= #source and source:sub(pos + 1, pos + 1) == '&' then
                value = advance() .. advance()
                tokenType = TOKEN_TYPES.OPERATOR
            elseif char == '+' and pos + 1 <= #source and source:sub(pos + 1, pos + 1) == '+' then
                value = advance() .. advance()
                tokenType = TOKEN_TYPES.OPERATOR
            elseif char == '-' and pos + 1 <= #source and source:sub(pos + 1, pos + 1) == '-' then
                value = advance() .. advance()
                tokenType = TOKEN_TYPES.OPERATOR
            elseif char == '#' then
                tokenType = TOKEN_TYPES.OPERATOR
                advance()
            elseif char == '+' or char == '-' or char == '*' or char == '/' or char == '%' or
                   char == '^' or char == '&' or char == '|' or char == '~' or
                   char == '<' or char == '>' or char == '=' or char == '!' or char == ':' then
                tokenType = TOKEN_TYPES.OPERATOR
                advance()
            elseif char == '.' then
                -- Handle . as punctuation (for dotted identifiers) or .. as operator
                if pos + 1 <= #source and source:sub(pos + 1, pos + 1) == '.' then
                    value = advance() .. advance()
                    tokenType = TOKEN_TYPES.OPERATOR
                else
                    tokenType = TOKEN_TYPES.PUNCTUATION
                    advance()
                end
            else
                advance()
            end
            
            table.insert(tokens, {type = tokenType, value = value, line = line, col = col})
        end
    end
    
    table.insert(tokens, {type = TOKEN_TYPES.EOF, value = "", line = line, col = col})
    return tokens
end

-- Parser
local function parse(tokens)
    local pos = 1
    local nesting_depth = 0
    
    local function peek()
        return tokens[pos]
    end
    
    local function advance()
        if pos <= #tokens then
            pos = pos + 1
        end
        return tokens[pos - 1]
    end
    
    local function expect(tokenType, value)
        local token = peek()
        if token.type ~= tokenType or (value and token.value ~= value) then
            error("Expected " .. tokenType .. (value and (" '" .. value .. "'") or "") .. 
                  " at line " .. token.line .. ", col " .. token.col)
        end
        return advance()
    end
    
    local parseExpression -- forward declaration
    local parseStatement -- forward declaration
    local parseAnonymousFunction -- forward declaration
    
    local function parsePrimary()
        local token = peek()
        
        -- Handle unary operators
        if token.type == TOKEN_TYPES.OPERATOR and (token.value == "-" or token.value == "!") then
            local op = advance().value
            local expr = parsePrimary()
            return {type = "unary_op", operator = op, operand = expr}
        end
        
        if token.type == TOKEN_TYPES.NUMBER then
            return {type = "number", value = tonumber(advance().value)}
        elseif token.type == TOKEN_TYPES.STRING then
            return {type = "string", value = advance().value}
        elseif token.type == TOKEN_TYPES.KEYWORD and token.value == "true" then
            advance()
            return {type = "boolean", value = true}
        elseif token.type == TOKEN_TYPES.KEYWORD and token.value == "false" then
            advance()
            return {type = "boolean", value = false}
        elseif token.type == TOKEN_TYPES.KEYWORD and token.value == "nil" then
            advance()
            return {type = "nil"}
        elseif token.type == TOKEN_TYPES.IDENTIFIER or (token.type == TOKEN_TYPES.KEYWORD and (token.value == "array" or token.value == "string")) then
            local name = advance().value
            local expr = {type = "identifier", name = name}
            
            -- Handle dotted identifiers like love.draw (but not .. for concatenation)
            while peek().type == TOKEN_TYPES.PUNCTUATION and peek().value == "." and peek(2) ~= "." do
                advance() -- consume '.'
                local nextToken = peek()
                local nextName
                if nextToken.type == TOKEN_TYPES.IDENTIFIER or nextToken.type == TOKEN_TYPES.KEYWORD then
                    nextName = advance().value
                else
                    error("Expected identifier or keyword after '.' at line " .. nextToken.line .. ", col " .. nextToken.col)
                end
                name = name .. "." .. nextName
                expr.name = name
            end
            
            -- Special handling for .length property access
            if name:match("%.length$") then
                local target = name:gsub("%.length$", "")
                return {type = "length_property", target = target}
            end
            
            -- Check for function call
            if peek().value == "(" then
                advance() -- consume '('
                local args = {}
                if peek().value ~= ")" then
                    while peek().value ~= ")" do
                        table.insert(args, parseExpression())
                        if peek().value == "," then
                            advance() -- consume ','
                        end
                    end
                end
                expect(TOKEN_TYPES.PUNCTUATION, ")")
                expr = {type = "function_call", name = name, args = args}
            end
            
            -- Handle chained method calls and array access
            while (peek().type == TOKEN_TYPES.PUNCTUATION and peek().value == "[") or 
                  (peek().type == TOKEN_TYPES.OPERATOR and peek().value == ":") do
                if peek().value == ":" then
                    -- Method call
                    advance() -- consume ':'
                    local methodName = expect(TOKEN_TYPES.IDENTIFIER).value
                    expect(TOKEN_TYPES.PUNCTUATION, "(")
                    local args = {}
                    if peek().value ~= ")" then
                        while peek().value ~= ")" do
                            table.insert(args, parseExpression())
                            if peek().value == "," then
                                advance() -- consume ','
                            end
                        end
                    end
                    expect(TOKEN_TYPES.PUNCTUATION, ")")
                    expr = {type = "method_call", object = expr, method = methodName, args = args}
                elseif peek().value == "[" then
                    -- Array access
                    advance() -- consume '['
                    local index = parseExpression()
                    expect(TOKEN_TYPES.PUNCTUATION, "]")
                    expr = {type = "array_access", array = expr, index = index}
                end
            end
            
            return expr
        elseif token.value == "(" then
            advance() -- consume '('
            local expr = parseExpression()
            expect(TOKEN_TYPES.PUNCTUATION, ")")
            return expr
        elseif token.value == "[" then
            advance() -- consume '['
            local elements = {}
            while peek().value ~= "]" do
                table.insert(elements, parseExpression())
                if peek().value == "," then
                    advance() -- consume ','
                end
            end
            expect(TOKEN_TYPES.PUNCTUATION, "]")
            return {type = "array_literal", elements = elements}
        elseif token.value == "{" then
            advance() -- consume '{'
            local elements = {}
            local keys = {}
            local isKeyValue = false
            
            while peek().value ~= "}" do
                local key = nil
                local value = nil
                
                -- Skip newlines
                while peek().type == TOKEN_TYPES.NEWLINE do
                    advance()
                end
                
                -- Check if this is a key-value pair (identifier = expression)
                if peek().type == TOKEN_TYPES.IDENTIFIER then
                    -- Store the identifier and check what comes next
                    local identifier = peek().value
                    advance() -- consume identifier
                    
                    if peek().value == "=" then
                        -- Key-value pair: key = value
                        advance() -- consume '='
                        value = parseExpression()
                        key = identifier
                        isKeyValue = true
                    else
                        -- Just an identifier (array-style)
                        value = {type = "identifier", name = identifier}
                    end
                else
                    -- Just a value (array-style)
                    value = parseExpression()
                end
                
                table.insert(elements, value)
                if key then
                    table.insert(keys, key)
                else
                    table.insert(keys, nil)
                end
                
                -- Skip newlines after value
                while peek().type == TOKEN_TYPES.NEWLINE do
                    advance()
                end
                
                if peek().value == "," then
                    advance() -- consume ','
                end
            end
            expect(TOKEN_TYPES.PUNCTUATION, "}")
            return {type = "table_literal", elements = elements, keys = keys, isKeyValue = isKeyValue}
        else
            error("Unexpected token: " .. token.value .. " at line " .. token.line .. ", col " .. token.col)
        end
    end
    
    -- Operator precedence levels (higher number = higher precedence)
    local function getPrecedence(op)
        if op == "||" then return 1
        elseif op == "&&" then return 2
        elseif op == "==" or op == "~=" or op == "!=" then return 3
        elseif op == "<" or op == ">" or op == "<=" or op == ">=" then return 4
        elseif op == "<<" or op == ">>" then return 5
        elseif op == "+" or op == "-" then return 6
        elseif op == "*" or op == "/" or op == "%" then return 7
        elseif op == ".." then return 8
        elseif op == "&" or op == "|" or op == "~" then return 9
        else return 0
        end
    end
    
    function parseExpression(precedence)
        precedence = precedence or 0
        local left = parsePrimary()
        
        while peek().type == TOKEN_TYPES.OPERATOR and getPrecedence(peek().value) > precedence do
            local op = advance().value
            local right = parseExpression(getPrecedence(op))
            left = {type = "binary_op", left = left, operator = op, right = right}
        end
        
        return left
    end
    
    local function parseStatement()
        local token = peek()
        
        -- Export statements
        if token.type == TOKEN_TYPES.KEYWORD and token.value == "export" then
            advance() -- consume 'export'
            
            local exports = {}
            -- Parse export list: export { func1, func2 }
            if peek().value == "{" then
                advance() -- consume '{'
                while peek().value ~= "}" do
                    local exportName = expect(TOKEN_TYPES.IDENTIFIER).value
                    table.insert(exports, exportName)
                    if peek().value == "," then
                        advance() -- consume ','
                    end
                end
                expect(TOKEN_TYPES.PUNCTUATION, "}")
            else
                -- Single export: export func
                local exportName = expect(TOKEN_TYPES.IDENTIFIER).value
                table.insert(exports, exportName)
            end
            
            return {type = "export_statement", exports = exports}
        -- Import statements
        elseif token.type == TOKEN_TYPES.KEYWORD and token.value == "import" then
            advance() -- consume 'import'
            
            local imports = {}
            local isDestructuring = false
            -- Parse import list: import { func1, func2 } from "module"
            if peek().value == "{" then
                isDestructuring = true
                advance() -- consume '{'
                while peek().value ~= "}" do
                    local importName = expect(TOKEN_TYPES.IDENTIFIER).value
                    table.insert(imports, importName)
                    if peek().value == "," then
                        advance() -- consume ','
                    end
                end
                expect(TOKEN_TYPES.PUNCTUATION, "}")
            else
                -- Single import: import func from "module"
                local importName = expect(TOKEN_TYPES.IDENTIFIER).value
                table.insert(imports, importName)
            end
            
            expect(TOKEN_TYPES.KEYWORD, "from")
            local moduleName
            if peek().type == TOKEN_TYPES.STRING then
                moduleName = expect(TOKEN_TYPES.STRING).value
            else
                -- Handle dotted module names like sprlib.colors
                local name = expect(TOKEN_TYPES.IDENTIFIER).value
                while peek().type == TOKEN_TYPES.PUNCTUATION and peek().value == "." do
                    advance() -- consume '.'
                    local nextName = expect(TOKEN_TYPES.IDENTIFIER).value
                    name = name .. "." .. nextName
                end
                moduleName = name
            end
            
            return {type = "import_statement", imports = imports, module = moduleName, isDestructuring = isDestructuring}
        end
        
        -- Special case: array = [1, 2, 3] syntax
        if token.type == TOKEN_TYPES.KEYWORD and token.value == "array" then
            advance() -- consume 'array'
            expect(TOKEN_TYPES.OPERATOR, "=")
            expect(TOKEN_TYPES.PUNCTUATION, "[")
            
            local elements = {}
            while peek().value ~= "]" do
                table.insert(elements, parseExpression())
                if peek().value == "," then
                    advance() -- consume ','
                end
            end
            expect(TOKEN_TYPES.PUNCTUATION, "]")
            
            return {type = "array_declaration", name = "array", elements = elements}
        end
        
        -- Type declarations: string[] testArray, bool testBool, table myTable, etc.
        if token.type == TOKEN_TYPES.KEYWORD and (token.value == "string" or token.value == "bool" or 
            token.value == "int" or token.value == "float" or token.value == "table") then
            local typeName = advance().value
            local isArray = false
            
            -- Check for array type (string[], bool[], etc.) - but not for table type
            if typeName ~= "table" and peek().value == "[" then
                advance() -- consume '['
                expect(TOKEN_TYPES.PUNCTUATION, "]")
                isArray = true
            end
            
            local varName = expect(TOKEN_TYPES.IDENTIFIER).value
            expect(TOKEN_TYPES.OPERATOR, "=")
            
            local value = parseExpression()
            
            -- For arrays, create array declaration
            if isArray then
                if value.type == "array_literal" then
                    return {type = "array_declaration", name = varName, elements = value.elements}
                else
                    error("Expected array literal for array type declaration at line " .. token.line .. ", col " .. token.col)
                end
            elseif typeName == "table" then
                -- For table type, create table declaration
                if value.type == "table_literal" then
                    return {type = "table_declaration", name = varName, value = value}
                else
                    error("Expected table literal for table type declaration at line " .. token.line .. ", col " .. token.col)
                end
            else
                -- For primitive types, create local declaration
                return {type = "local_declaration", name = varName, value = value}
            end
        end
        
        if token.type == TOKEN_TYPES.KEYWORD and token.value == "local" then
            advance() -- consume 'local'
            local name = expect(TOKEN_TYPES.IDENTIFIER).value
            local stmt = {type = "local_declaration", name = name}
            
            if peek().value == "=" then
                advance() -- consume '='
                -- Check if this is an array declaration
                if peek().type == TOKEN_TYPES.KEYWORD and peek().value == "array" then
                    advance() -- consume 'array'
                    expect(TOKEN_TYPES.PUNCTUATION, "{")
                    
                    local elements = {}
                    while peek().value ~= "}" do
                        table.insert(elements, parseExpression())
                        if peek().value == "," then
                            advance() -- consume ','
                        end
                    end
                    expect(TOKEN_TYPES.PUNCTUATION, "}")
                    
                    return {type = "array_declaration", name = name, elements = elements}
                else
                    -- Check for anonymous function
                    if peek().type == TOKEN_TYPES.KEYWORD and peek().value == "fn" then
                        stmt.value = parseAnonymousFunction()
                    else
                        stmt.value = parseExpression()
                    end
                end
            end
            
            return stmt
        elseif token.type == TOKEN_TYPES.KEYWORD and token.value == "while" then
            advance() -- consume 'while'
            local condition = parseExpression()
            
            local body = {}
            if peek().value == "{" then
                advance() -- consume '{'
                while peek().value ~= "}" do
                    if peek().type == TOKEN_TYPES.NEWLINE then
                        advance()
                    else
                        table.insert(body, parseStatement())
                    end
                end
                expect(TOKEN_TYPES.PUNCTUATION, "}")
            else
                -- Fallback to do/end syntax
                expect(TOKEN_TYPES.KEYWORD, "do")
                while peek().type ~= TOKEN_TYPES.KEYWORD or peek().value ~= "end" do
                    if peek().type == TOKEN_TYPES.NEWLINE then
                        advance()
                    else
                        table.insert(body, parseStatement())
                    end
                end
                expect(TOKEN_TYPES.KEYWORD, "end")
            end
            
            return {type = "while_loop", condition = condition, body = body}
        elseif token.type == TOKEN_TYPES.KEYWORD and token.value == "for" then
            advance() -- consume 'for'
            expect(TOKEN_TYPES.PUNCTUATION, "(")
            
            local init = nil
            local condition = nil
            local increment = nil
            
            -- Parse initialization
            if peek().type ~= TOKEN_TYPES.PUNCTUATION or peek().value ~= ";" then
                init = parseStatement()
            end
            expect(TOKEN_TYPES.PUNCTUATION, ";")
            
            -- Parse condition
            if peek().type ~= TOKEN_TYPES.PUNCTUATION or peek().value ~= ";" then
                condition = parseExpression()
            end
            expect(TOKEN_TYPES.PUNCTUATION, ";")
            
            -- Parse increment
            if peek().type ~= TOKEN_TYPES.PUNCTUATION or peek().value ~= ")" then
                increment = parseStatement()
            end
            expect(TOKEN_TYPES.PUNCTUATION, ")")
            
            local body = {}
            if peek().value == "{" then
                advance() -- consume '{'
                while peek().value ~= "}" do
                    if peek().type == TOKEN_TYPES.NEWLINE then
                        advance()
                    else
                        table.insert(body, parseStatement())
                    end
                end
                expect(TOKEN_TYPES.PUNCTUATION, "}")
            else
                -- Fallback to do/end syntax
                expect(TOKEN_TYPES.KEYWORD, "do")
                while peek().type ~= TOKEN_TYPES.KEYWORD or peek().value ~= "end" do
                    if peek().type == TOKEN_TYPES.NEWLINE then
                        advance()
                    else
                        table.insert(body, parseStatement())
                    end
                end
                expect(TOKEN_TYPES.KEYWORD, "end")
            end
            
            return {type = "for_loop", init = init, condition = condition, increment = increment, body = body}
        elseif token.type == TOKEN_TYPES.KEYWORD and (token.value == "function" or token.value == "fn" or 
               token.value == "priv" or token.value == "pub") then
            local visibility = "public" -- default for top-level functions
            local fnKeyword = "fn"
            
            if token.value == "priv" or token.value == "pub" then
                visibility = token.value == "priv" and "private" or "public"
                advance() -- consume 'priv' or 'pub'
                if peek().value == "fn" then
                    advance() -- consume 'fn'
                else
                    error("Expected 'fn' after '" .. token.value .. "' at line " .. token.line .. ", col " .. token.col)
                end
            else
                advance() -- consume 'function' or 'fn'
                -- For nested functions without explicit visibility, default to private
                if nesting_depth > 0 then
                    visibility = "private"
                end
            end
            
            local name = expect(TOKEN_TYPES.IDENTIFIER).value
            
            -- Handle dotted identifiers like love.draw (but not .. for concatenation)
            while peek().type == TOKEN_TYPES.PUNCTUATION and peek().value == "." and peek(2) ~= "." do
                advance() -- consume '.'
                local nextName = expect(TOKEN_TYPES.IDENTIFIER).value
                name = name .. "." .. nextName
            end
            
            expect(TOKEN_TYPES.PUNCTUATION, "(")
            
            local params = {}
            if peek().value ~= ")" then
                while peek().value ~= ")" do
                    local paramType = nil
                    local paramName = nil
                    
                    -- Check if this is a typed parameter (int x, float y, etc.)
                    if peek().type == TOKEN_TYPES.KEYWORD and (peek().value == "int" or peek().value == "float" or 
                        peek().value == "string" or peek().value == "bool") then
                        paramType = advance().value
                        paramName = expect(TOKEN_TYPES.IDENTIFIER).value
                    else
                        paramName = expect(TOKEN_TYPES.IDENTIFIER).value
                    end
                    
                    table.insert(params, {name = paramName, type = paramType})
                    if peek().value == "," then
                        advance() -- consume ','
                    end
                end
            end
            expect(TOKEN_TYPES.PUNCTUATION, ")")
            
            local body = {}
            nesting_depth = nesting_depth + 1
            if peek().value == "{" then
                advance() -- consume '{'
                while peek().value ~= "}" do
                    if peek().type == TOKEN_TYPES.NEWLINE then
                        advance()
                    else
                        table.insert(body, parseStatement())
                    end
                end
                expect(TOKEN_TYPES.PUNCTUATION, "}")
            else
                -- Fallback to then/end syntax
                while peek().type ~= TOKEN_TYPES.KEYWORD or peek().value ~= "end" do
                    if peek().type == TOKEN_TYPES.NEWLINE then
                        advance()
                    else
                        table.insert(body, parseStatement())
                    end
                end
                expect(TOKEN_TYPES.KEYWORD, "end")
            end
            nesting_depth = nesting_depth - 1
            
            return {type = "function_declaration", name = name, params = params, body = body, visibility = visibility}
        elseif token.type == TOKEN_TYPES.KEYWORD and token.value == "return" then
            advance() -- consume 'return'
            local stmt = {type = "return_statement"}
            if peek().type ~= TOKEN_TYPES.NEWLINE and peek().type ~= TOKEN_TYPES.EOF then
                stmt.value = parseExpression()
            end
            return stmt
        elseif token.type == TOKEN_TYPES.KEYWORD and token.value == "break" then
            advance() -- consume 'break'
            return {type = "break_statement"}
        elseif token.type == TOKEN_TYPES.KEYWORD and token.value == "continue" then
            advance() -- consume 'continue'
            return {type = "continue_statement"}
        elseif token.type == TOKEN_TYPES.KEYWORD and token.value == "if" then
            advance() -- consume 'if'
            local condition = parseExpression()
            
            local thenBody = {}
            local elseBody = {}
            local hasElse = false
            
            if peek().value == "{" then
                advance() -- consume '{'
                while peek().value ~= "}" do
                    if peek().type == TOKEN_TYPES.NEWLINE then
                        advance()
                    else
                        table.insert(thenBody, parseStatement())
                    end
                end
                expect(TOKEN_TYPES.PUNCTUATION, "}")
                
                if peek().value == "else" then
                    advance() -- consume 'else'
                    hasElse = true
                    if peek().value == "{" then
                        advance() -- consume '{'
                        while peek().value ~= "}" do
                            if peek().type == TOKEN_TYPES.NEWLINE then
                                advance()
                            else
                                table.insert(elseBody, parseStatement())
                            end
                        end
                        expect(TOKEN_TYPES.PUNCTUATION, "}")
                    end
                end
            else
                -- Fallback to then/end syntax
                expect(TOKEN_TYPES.KEYWORD, "then")
                while peek().type ~= TOKEN_TYPES.KEYWORD or 
                      (peek().value ~= "else" and peek().value ~= "end") do
                    if peek().type == TOKEN_TYPES.NEWLINE then
                        advance()
                    else
                        table.insert(thenBody, parseStatement())
                    end
                end
                
                if peek().value == "else" then
                    advance() -- consume 'else'
                    hasElse = true
                    while peek().type ~= TOKEN_TYPES.KEYWORD or peek().value ~= "end" do
                        if peek().type == TOKEN_TYPES.NEWLINE then
                            advance()
                        else
                            table.insert(elseBody, parseStatement())
                        end
                    end
                end
                
                expect(TOKEN_TYPES.KEYWORD, "end")
            end
            
            return {type = "if_statement", condition = condition, thenBody = thenBody, 
                   elseBody = elseBody, hasElse = hasElse}
        elseif token.type == TOKEN_TYPES.IDENTIFIER then
            local name = advance().value
            
            -- Handle dotted identifiers like love.graphics (but not .. for concatenation)
            while peek().type == TOKEN_TYPES.PUNCTUATION and peek().value == "." and peek(2) ~= "." do
                advance() -- consume '.'
                local nextName = expect(TOKEN_TYPES.IDENTIFIER).value
                name = name .. "." .. nextName
            end
            
            -- Check for function call
            if peek().value == "(" then
                advance() -- consume '('
                local args = {}
                if peek().value ~= ")" then
                    while peek().value ~= ")" do
                        table.insert(args, parseExpression())
                        if peek().value == "," then
                            advance() -- consume ','
                        end
                    end
                end
                expect(TOKEN_TYPES.PUNCTUATION, ")")
                return {type = "function_call", name = name, args = args}
            end
            
            -- Check for method call
            if peek().value == ":" then
                advance() -- consume ':'
                local methodName = expect(TOKEN_TYPES.IDENTIFIER).value
                expect(TOKEN_TYPES.PUNCTUATION, "(")
                local args = {}
                if peek().value ~= ")" then
                    while peek().value ~= ")" do
                        table.insert(args, parseExpression())
                        if peek().value == "," then
                            advance() -- consume ','
                        end
                    end
                end
                expect(TOKEN_TYPES.PUNCTUATION, ")")
                return {type = "method_call", object = {type = "identifier", name = name}, method = methodName, args = args}
            end
            
            -- Check for array assignment
            local stmt = {type = "assignment", name = name}
            if peek().value == "[" then
                advance() -- consume '['
                local index = parseExpression()
                expect(TOKEN_TYPES.PUNCTUATION, "]")
                stmt.type = "array_assignment"
                stmt.index = index
            end
            
            expect(TOKEN_TYPES.OPERATOR, "=")
            
            -- Special case: array = [1, 2, 3] syntax
            if name == "array" and peek().value == "[" then
                advance() -- consume '['
                local elements = {}
                while peek().value ~= "]" do
                    table.insert(elements, parseExpression())
                    if peek().value == "," then
                        advance() -- consume ','
                    end
                end
                expect(TOKEN_TYPES.PUNCTUATION, "]")
                return {type = "array_declaration", name = "array", elements = elements}
            end
            
            -- Check for anonymous function
            local value
            if peek().type == TOKEN_TYPES.KEYWORD and peek().value == "fn" then
                value = parseAnonymousFunction()
            else
                value = parseExpression()
            end
            stmt.value = value
            return stmt
        else
            -- Try to parse as expression
            return parseExpression()
        end
    end
    
    -- Define parseAnonymousFunction after parseStatement
    function parseAnonymousFunction()
        advance() -- consume 'fn'
        expect(TOKEN_TYPES.PUNCTUATION, "(")
        
        local params = {}
        if peek().value ~= ")" then
            while peek().value ~= ")" do
                local paramType = nil
                local paramName = nil
                
                -- Check if this is a typed parameter (int x, float y, etc.)
                if peek().type == TOKEN_TYPES.KEYWORD and (peek().value == "int" or peek().value == "float" or 
                    peek().value == "string" or peek().value == "bool") then
                    paramType = advance().value
                    paramName = expect(TOKEN_TYPES.IDENTIFIER).value
                else
                    paramName = expect(TOKEN_TYPES.IDENTIFIER).value
                end
                
                table.insert(params, {name = paramName, type = paramType})
                if peek().value == "," then
                    advance() -- consume ','
                end
            end
        end
        expect(TOKEN_TYPES.PUNCTUATION, ")")
        
        local body = {}
        nesting_depth = nesting_depth + 1
        if peek().value == "{" then
            advance() -- consume '{'
            while peek().value ~= "}" do
                if peek().type == TOKEN_TYPES.NEWLINE then
                    advance()
                else
                    table.insert(body, parseStatement())
                end
            end
            expect(TOKEN_TYPES.PUNCTUATION, "}")
        else
            -- Fallback to do/end syntax
            expect(TOKEN_TYPES.KEYWORD, "do")
            while peek().type ~= TOKEN_TYPES.KEYWORD or peek().value ~= "end" do
                if peek().type == TOKEN_TYPES.NEWLINE then
                    advance()
                else
                    table.insert(body, parseStatement())
                end
            end
            expect(TOKEN_TYPES.KEYWORD, "end")
        end
        nesting_depth = nesting_depth - 1
        
        return {type = "anonymous_function", params = params, body = body}
    end
    
    local statements = {}
    while pos <= #tokens and peek().type ~= TOKEN_TYPES.EOF do
        if peek().type == TOKEN_TYPES.NEWLINE then
            advance()
        else
            table.insert(statements, parseStatement())
        end
    end
    
    return {type = "program", statements = statements}
end

-- Code generator
local generateExpression
local generateStatement

generateExpression = function(expr)
    if expr.type == "number" or expr.type == "string" or expr.type == "boolean" then
        if expr.type == "string" then
            return '"' .. expr.value:gsub('"', '\\"') .. '"'
        end
        return tostring(expr.value)
    elseif expr.type == "nil" then
        return "nil"
    elseif expr.type == "identifier" then
        return expr.name
    elseif expr.type == "array_access" then
        return generateExpression(expr.array) .. "[" .. generateExpression(expr.index) .. " + 1]"
    elseif expr.type == "binary_op" then
        local leftExpr = generateExpression(expr.left)
        local rightExpr = generateExpression(expr.right)
        local operator = expr.operator
        
        -- Convert + to .. for string concatenation, but not for arithmetic operations
        if operator == "+" then
            -- Check if both operands are likely strings (contain quotes)
            if leftExpr:match('"') or rightExpr:match('"') then
                operator = ".."
            end
        -- Convert != to ~=
        elseif operator == "!=" then
            operator = "~="
        -- Convert && to and
        elseif operator == "&&" then
            operator = "and"
        -- Convert || to or
        elseif operator == "||" then
            operator = "or"
        -- Convert bit shift operators to Lua bit operations
        elseif operator == "<<" then
            return "bit.lshift(" .. leftExpr .. ", " .. rightExpr .. ")"
        elseif operator == ">>" then
            return "bit.rshift(" .. leftExpr .. ", " .. rightExpr .. ")"
        -- Convert bitwise operators to Lua bit operations
        elseif operator == "&" then
            return "bit.band(" .. leftExpr .. ", " .. rightExpr .. ")"
        elseif operator == "|" then
            return "bit.bor(" .. leftExpr .. ", " .. rightExpr .. ")"
        elseif operator == "~" then
            return "bit.bnot(" .. leftExpr .. ")"
        end
        
        return "(" .. leftExpr .. " " .. operator .. " " .. rightExpr .. ")"
    elseif expr.type == "function_call" then
        local result = expr.name .. "("
        for i, arg in ipairs(expr.args) do
            if i > 1 then result = result .. ", " end
            result = result .. generateExpression(arg)
        end
        result = result .. ")"
        return result
    elseif expr.type == "method_call" then
        local result = generateExpression(expr.object) .. ":" .. expr.method .. "("
        for i, arg in ipairs(expr.args) do
            if i > 1 then result = result .. ", " end
            result = result .. generateExpression(arg)
        end
        result = result .. ")"
        return result
    elseif expr.type == "unary_op" then
        if expr.operator == "!" then
            return "not " .. generateExpression(expr.operand)
        else
            return expr.operator .. generateExpression(expr.operand)
        end
    elseif expr.type == "array_literal" then
        local result = "{"
        for i, element in ipairs(expr.elements) do
            if i > 1 then result = result .. ", " end
            result = result .. generateExpression(element)
        end
        result = result .. "}"
        return result
    elseif expr.type == "table_literal" then
        local result = "{"
        for i, element in ipairs(expr.elements) do
            if i > 1 then result = result .. ", " end
            
            if expr.isKeyValue and expr.keys[i] then
                -- Key-value pair
                result = result .. expr.keys[i] .. " = " .. generateExpression(element)
            else
                -- Array-style element
                result = result .. generateExpression(element)
            end
        end
        result = result .. "}"
        return result
    elseif expr.type == "length_property" then
        return "#" .. expr.target
    elseif expr.type == "anonymous_function" then
        local result = "function("
        for i, param in ipairs(expr.params) do
            if i > 1 then result = result .. ", " end
            if type(param) == "table" then
                result = result .. param.name
            else
                result = result .. param
            end
        end
        result = result .. ")\n"
        for _, bodyStmt in ipairs(expr.body) do
            result = result .. "  " .. generateStatement(bodyStmt, {}, false) .. "\n"
        end
        result = result .. "end"
        return result
    else
        return "nil"
    end
end

generateStatement = function(stmt, publicFunctions, hasExports)
    if stmt.type == "local_declaration" then
        local result = "local " .. stmt.name
        if stmt.value then
            result = result .. " = " .. generateExpression(stmt.value)
        end
        return result
    elseif stmt.type == "array_declaration" then
        local result = "local " .. stmt.name .. " = {"
        for i, element in ipairs(stmt.elements) do
            if i > 1 then result = result .. ", " end
            result = result .. generateExpression(element)
        end
        result = result .. "}"
        return result
    elseif stmt.type == "table_declaration" then
        return "local " .. stmt.name .. " = " .. generateExpression(stmt.value)
    elseif stmt.type == "assignment" then
        return stmt.name .. " = " .. generateExpression(stmt.value)
    elseif stmt.type == "array_assignment" then
        return stmt.name .. "[" .. generateExpression(stmt.index) .. " + 1] = " .. generateExpression(stmt.value)
    elseif stmt.type == "while_loop" then
        local result = "while " .. generateExpression(stmt.condition) .. " do\n"
        for _, bodyStmt in ipairs(stmt.body) do
            result = result .. "  " .. generateStatement(bodyStmt, publicFunctions, hasExports) .. "\n"
        end
        result = result .. "end"
        return result
    elseif stmt.type == "for_loop" then
        local result = "for "
        if stmt.init then
            result = result .. generateStatement(stmt.init, publicFunctions, hasExports)
        end
        result = result .. "; "
        if stmt.condition then
            result = result .. generateExpression(stmt.condition)
        end
        result = result .. "; "
        if stmt.increment then
            result = result .. generateStatement(stmt.increment, publicFunctions, hasExports)
        end
        result = result .. " do\n"
        for _, bodyStmt in ipairs(stmt.body) do
            result = result .. "  " .. generateStatement(bodyStmt, publicFunctions, hasExports) .. "\n"
        end
        result = result .. "end"
        return result
    elseif stmt.type == "import_statement" then
        local result = ""
        if stmt.isDestructuring then
            -- Generate individual require statements for each import
            for i, importName in ipairs(stmt.imports) do
                if i > 1 then result = result .. "\n" end
                result = result .. "local " .. importName .. " = require(\"" .. stmt.module .. "\")." .. importName
            end
        else
            result = "local " .. stmt.imports[1] .. " = require(\"" .. stmt.module .. "\")"
        end
        return result
    elseif stmt.type == "export_statement" then
        -- Export statements are handled at the module level, not as individual statements
        return ""
    elseif stmt.type == "function_declaration" then
        local result = "function " .. stmt.name .. "("
        for i, param in ipairs(stmt.params) do
            if i > 1 then result = result .. ", " end
            if type(param) == "table" then
                result = result .. param.name
            else
                result = result .. param
            end
        end
        result = result .. ")\n"
        for _, bodyStmt in ipairs(stmt.body) do
            result = result .. "  " .. generateStatement(bodyStmt, publicFunctions, hasExports) .. "\n"
        end
        result = result .. "end"
        
        -- Collect public functions for module export
        if stmt.visibility == "public" then
            table.insert(publicFunctions, stmt.name)
            -- Note: hasExports is passed by value, so we can't modify it here
            -- This will be handled by checking if publicFunctions is not empty
        end
        
        return result
    elseif stmt.type == "function_call" then
        local result = stmt.name .. "("
        for i, arg in ipairs(stmt.args) do
            if i > 1 then result = result .. ", " end
            result = result .. generateExpression(arg)
        end
        result = result .. ")"
        return result
    elseif stmt.type == "return_statement" then
        if stmt.value then
            return "return " .. generateExpression(stmt.value)
        else
            return "return"
        end
    elseif stmt.type == "break_statement" then
        return "break"
    elseif stmt.type == "continue_statement" then
        return "goto continue"
    elseif stmt.type == "if_statement" then
        local result = "if " .. generateExpression(stmt.condition) .. " then\n"
        for _, thenStmt in ipairs(stmt.thenBody) do
            result = result .. "  " .. generateStatement(thenStmt, publicFunctions, hasExports) .. "\n"
        end
        if stmt.hasElse then
            result = result .. "else\n"
            for _, elseStmt in ipairs(stmt.elseBody) do
                result = result .. "  " .. generateStatement(elseStmt, publicFunctions, hasExports) .. "\n"
            end
        end
        result = result .. "end"
        return result
    else
        return generateExpression(stmt)
    end
end

local function generateLua(ast)
    local publicFunctions = {}
    local hasExports = false
    
    local result = {}
    for _, stmt in ipairs(ast.statements) do
        table.insert(result, generateStatement(stmt, publicFunctions, hasExports))
    end
    
    -- Add module export if there are public functions
    if #publicFunctions > 0 then
        table.insert(result, "")
        table.insert(result, "-- Module exports")
        table.insert(result, "local module = {}")
        for _, funcName in ipairs(publicFunctions) do
            table.insert(result, "module." .. funcName .. " = " .. funcName)
        end
        table.insert(result, "return module")
    end
    
    return table.concat(result, "\n")
end

-- Expose functions for debugging
function compiler.tokenize(source)
    return tokenize(source)
end

function compiler.parse(tokens)
    return parse(tokens)
end

-- Main compile function
function compiler.compile(source)
    local tokens = tokenize(source)
    local ast = parse(tokens)
    return generateLua(ast)
end

-- Helper function to compile from file
function compiler.compileFile(inputPath, outputPath)
    local file = io.open(inputPath, "r")
    if not file then
        error("Could not open file: " .. inputPath)
    end
    
    local source = file:read("*all")
    file:close()
    
    local luaCode = compiler.compile(source)
    
    local outputFile = io.open(outputPath, "w")
    if not outputFile then
        error("Could not create output file: " .. outputPath)
    end
    
    outputFile:write(luaCode)
    outputFile:close()
    
    return luaCode
end

return compiler

# Change Log

All notable changes to the "grillcheese-script" extension will be documented in this file.

## [1.1.0] - 2024-12-19

### Added
- **Typed Arrays**: Support for `string[]`, `int[]`, `float[]`, `bool[]` with 0-indexing
- **Table Declarations**: `table` keyword for explicit table typing
- **Array Literals**: Square bracket syntax `[1, 2, 3]` for array literals
- **Enhanced Logical Operators**: Full support for `&&`, `||`, `==`, `!=`, `<`, `>`, `<=`, `>=`
- **Operator Precedence**: Proper precedence for all operators
- **Import System**: ES6-style imports with destructuring support
- **Enhanced Syntax Highlighting**: Better highlighting for new operators and types
- **New Code Snippets**: 15+ new snippets for typed arrays, table declarations, and operators
- **Mixed Type Arrays**: Support for arrays with different data types
- **Table Literals**: Enhanced support for key-value pair table literals

### Improved
- **Syntax Highlighting**: Better categorization of operators (logical, comparison, arithmetic)
- **Code Completion**: Enhanced IntelliSense for new syntax features
- **Documentation**: Comprehensive examples and usage patterns
- **Error Handling**: Better error messages for type mismatches

### Technical
- **Parser Enhancements**: Added support for typed array declarations
- **Code Generation**: Improved generation for destructuring imports
- **Type System**: Enhanced type checking and validation
- **Array Handling**: Proper 0-indexed to 1-indexed conversion

## [1.0.0] - 2024-09-21

### Added
- Initial release of GrillCheese Script VS Code extension
- Syntax highlighting for GrillCheese Script (.gcs files)
- IntelliSense and auto-completion for GrillCheese Script keywords
- Type system support (string[], bool, int, float)
- Array syntax support (array = [1, 2, 3])
- C-style comments (//) support
- JavaScript-style curly braces ({}) support
- Complete Löve2D API IntelliSense
- Hover documentation for functions and keywords
- Code snippets for common patterns
- Go-to-definition support
- Compile and run commands
- Language configuration for proper editing experience

### Features
- Full syntax highlighting
- Auto-completion for 50+ Löve2D functions
- Hover documentation with parameter information
- Code snippets for functions, control structures, and type declarations
- Support for 0-indexed arrays that compile to 1-indexed Lua
- String concatenation with + operator
- Logical operators (!, &&, ||)
- Type declarations with proper scoping

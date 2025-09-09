# AGENTS.md

## Build, Lint, and Test Commands

- **Run all tests**: `pytest`
- **Run a single test**: `pytest path/to/test_file.py::test_name`
- **Lint the code**: Use `stylua` for formatting Lua files.
- **Build commands**: Not explicitly defined; ensure dependencies are
installed and configurations are correct.

## Code Style Guidelines

### General Formatting

- Use `stylua` for consistent formatting.
- Indentation: 2 spaces.
- Maximum line width: 120 characters.

### Imports

- Organize imports logically and group by functionality.
- Avoid unused imports.

### Types

- Use explicit types where applicable.
- Follow Lua conventions for type annotations (e.g., `---@type` for LSP support).

### Naming Conventions

- Use snake_case for variables and functions.
- Use PascalCase for modules and classes.
- Be descriptive and avoid abbreviations.

### Error Handling

- Check for errors explicitly.
- Use `pcall` or similar mechanisms for safe execution.

### Additional Notes

- Follow LazyVim plugin conventions for Lua configurations.
- Test configurations are defined in `lazyvim.plugins.extras.test.core`.
- Ensure compatibility with the `stylua.toml` configuration file.

This file is intended to guide agents working in this repository. Ensure
adherence to these guidelines for consistency and maintainability.

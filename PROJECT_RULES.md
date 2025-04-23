# StrokeStakes Project Rules

## Code Style and Formatting
1. Follow the [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
2. Use `dart format` to format code before committing
3. Maximum line length: 80 characters
4. Use 2 spaces for indentation
5. Always use trailing commas in multi-line parameter lists

## Flutter Best Practices
1. **Widget Organization**
   - Break down large widgets into smaller, reusable components
   - Use `StatelessWidget` when possible
   - Implement `StatefulWidget` only when necessary
   - Keep widget files focused and single-responsibility

2. **State Management**
   - Use `Provider` or `Riverpod` for state management
   - Keep business logic separate from UI code
   - Implement proper state immutability
   - Use `ChangeNotifier` for local state when appropriate

3. **Performance Optimization**
   - Use `const` constructors for widgets
   - Implement `ListView.builder` for long lists
   - Use `RepaintBoundary` for complex animations
   - Optimize image assets with proper sizes
   - Implement proper caching strategies

4. **Navigation**
   - Use named routes for navigation
   - Implement proper route guards
   - Handle deep linking appropriately
   - Maintain consistent navigation patterns

5. **Theme and Styling**
   - Use theme data for consistent styling
   - Implement responsive design
   - Use proper text scaling
   - Follow Material Design guidelines
   - Create reusable style constants

6. **Asset Management**
   - Organize assets in proper directories
   - Use proper image formats (WebP when possible)
   - Implement proper asset caching
   - Follow platform-specific asset guidelines

7. **Platform-Specific Code**
   - Use platform channels for native functionality
   - Implement proper error handling for platform calls
   - Follow platform-specific design guidelines
   - Test platform-specific features thoroughly

8. **Internationalization**
   - Use `intl` package for translations
   - Implement proper RTL support
   - Handle different date/time formats
   - Test with different locales

9. **Testing**
   - Write widget tests for UI components
   - Implement integration tests for critical flows
   - Use mock data for testing
   - Test on different screen sizes
   - Test platform-specific features

10. **Dependency Injection**
    - Use proper dependency injection patterns
    - Implement service locators when needed
    - Keep dependencies loosely coupled
    - Use proper scoping for services

## Naming Conventions
1. **Files**: Use snake_case for file names (e.g., `user_profile_screen.dart`)
2. **Classes**: Use PascalCase (e.g., `UserProfileScreen`)
3. **Variables and Functions**: Use camelCase (e.g., `userProfile`, `getUserData()`)
4. **Constants**: Use SCREAMING_SNAKE_CASE (e.g., `MAX_RETRY_COUNT`)
5. **Private Members**: Prefix with underscore (e.g., `_privateVariable`)

## Project Structure
```
lib/
├── core/           # Core functionality, utilities, and constants
├── features/       # Feature-specific code
│   ├── auth/      # Authentication related code
│   ├── profile/   # User profile related code
│   └── ...        # Other features
├── shared/         # Shared widgets and components
├── services/       # API services and business logic
└── main.dart       # Application entry point
```

## Git Workflow
1. Create feature branches from `main`
2. Branch naming: `feature/description` or `fix/description`
3. Write descriptive commit messages
4. Create pull requests for code review
5. Squash and merge to `main`

## Testing
1. Write tests for all new features
2. Maintain test coverage above 80%
3. Run tests before creating pull requests
4. Use meaningful test names that describe the test case

## Documentation
1. Document all public APIs
2. Use clear and concise comments
3. Update README.md with new features
4. Document complex business logic

## Performance
1. Optimize widget rebuilds
2. Use const constructors where possible
3. Implement proper state management
4. Minimize network calls
5. Cache data when appropriate

## Security
1. Never commit sensitive data
2. Use environment variables for API keys
3. Validate all user input
4. Implement proper authentication
5. Follow OWASP security guidelines

## Accessibility
1. Use semantic widgets
2. Provide text alternatives for images
3. Ensure proper color contrast
4. Support screen readers
5. Test with accessibility tools

## Error Handling
1. Implement proper error boundaries
2. Show user-friendly error messages
3. Log errors appropriately
4. Handle network errors gracefully
5. Implement retry mechanisms where appropriate

## Dependencies
1. Keep dependencies up to date
2. Document why each dependency is needed
3. Use specific version numbers
4. Review dependencies for security vulnerabilities
5. Minimize the number of dependencies

## Code Review
1. Review code for:
   - Functionality
   - Performance
   - Security
   - Accessibility
   - Code style
2. Provide constructive feedback
3. Address all comments before merging
4. Keep PRs small and focused

## Release Process
1. Version numbers follow semantic versioning
2. Create release notes
3. Test on all target platforms
4. Update documentation
5. Tag releases in git

## Maintenance
1. Regular dependency updates
2. Code cleanup and refactoring
3. Performance monitoring
4. Security audits
5. Regular backups

## Communication
1. Document major decisions
2. Keep team members informed
3. Use clear and professional language
4. Document meeting notes
5. Share knowledge and best practices 
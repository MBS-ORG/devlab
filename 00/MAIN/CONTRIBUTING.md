# Contributing to Ultra-Automated DevContainer Framework

First off, thank you for considering contributing to this project! 🎉

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [How to Contribute](#how-to-contribute)
- [Coding Standards](#coding-standards)
- [Commit Messages](#commit-messages)
- [Pull Request Process](#pull-request-process)
- [Testing](#testing)

## Code of Conduct

This project adheres to a code of conduct. By participating, you are expected to uphold this code. Please be respectful and professional in all interactions.

## Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/YOUR-USERNAME/CI-CD.git
   cd CI-CD
   ```
3. **Set up the development environment** (see below)

## Development Setup

### Using GitHub Codespaces (Recommended)

1. Click "Code" → "Codespaces" → "Create codespace on main"
2. Wait for the container to build (~2-3 minutes with prebuilds)
3. Everything is pre-configured and ready to go!

### Using VS Code Dev Containers

1. Install [Docker](https://www.docker.com/products/docker-desktop) and [VS Code](https://code.visualstudio.com/)
2. Install the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
3. Open the project in VS Code
4. When prompted, click "Reopen in Container"

### Local Development

1. Install dependencies:
   ```bash
   npm install
   pip install -r requirements.txt
   ```

2. Copy environment file:
   ```bash
   cp .env.example .env
   ```

3. Start services:
   ```bash
   make start
   ```

## How to Contribute

### Reporting Bugs

- Use the GitHub issue tracker
- Include detailed steps to reproduce
- Provide system information (OS, Node version, etc.)
- Include error messages and stack traces

### Suggesting Enhancements

- Use GitHub issues with the "enhancement" label
- Clearly describe the feature and its benefits
- Provide examples of how it would work

### Code Contributions

1. **Create a branch** from `main`:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes** following our coding standards

3. **Test your changes**:
   ```bash
   npm test
   npm run lint
   ```

4. **Commit your changes** (see commit message guidelines)

5. **Push to your fork**:
   ```bash
   git push origin feature/your-feature-name
   ```

6. **Open a Pull Request** on GitHub

## Coding Standards

### JavaScript/TypeScript

- Follow the ESLint configuration
- Use Prettier for formatting
- Write JSDoc comments for public APIs
- Prefer async/await over callbacks
- Use meaningful variable names

### Python

- Follow PEP 8 style guide
- Use type hints where appropriate
- Write docstrings for functions and classes
- Use Black for formatting
- Maximum line length: 88 characters

### General

- Keep functions small and focused
- Write self-documenting code
- Add comments for complex logic
- Follow SOLID principles
- Don't repeat yourself (DRY)

## Commit Messages

We follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks
- `perf`: Performance improvements
- `ci`: CI/CD changes

### Examples

```
feat(auth): add OAuth2 authentication

Implemented OAuth2 flow with GitHub provider.
Added middleware for token validation.

Closes #123
```

```
fix(docker): resolve container networking issue

Fixed DNS resolution in docker-compose network.
Updated network configuration to use bridge mode.
```

## Pull Request Process

1. **Update documentation** if needed (README, CHANGELOG)
2. **Add tests** for new features
3. **Ensure all tests pass**:
   ```bash
   npm test
   npm run lint
   ```
4. **Update CHANGELOG.md** following Keep a Changelog format
5. **Request review** from maintainers
6. **Address feedback** promptly
7. **Squash commits** if requested
8. **Wait for approval** before merging

### PR Checklist

- [ ] Tests added/updated
- [ ] Documentation updated
- [ ] CHANGELOG.md updated
- [ ] All tests passing
- [ ] No lint errors
- [ ] Branch up to date with main
- [ ] Reviewed by at least one maintainer

## Testing

### Running Tests

```bash
# JavaScript tests
npm test
npm run test:watch
npm run test:ci

# Python tests
cd python_app
pytest
pytest --cov
```

### Writing Tests

- Write tests for all new features
- Maintain test coverage above 70%
- Use descriptive test names
- Test edge cases and error conditions
- Mock external dependencies

### Test Structure

```javascript
describe('Feature Name', () => {
  describe('method/function name', () => {
    it('should do something specific', () => {
      // Arrange
      const input = 'test';

      // Act
      const result = myFunction(input);

      // Assert
      expect(result).toBe('expected');
    });
  });
});
```

## Development Workflow

1. **Check existing issues** before starting work
2. **Create an issue** for new features/bugs
3. **Discuss approach** with maintainers
4. **Create a branch** for your work
5. **Develop and test** locally
6. **Push and create PR** when ready
7. **Respond to feedback**
8. **Celebrate** when merged! 🎉

## Questions?

- Open an issue for general questions
- Tag maintainers for urgent matters
- Check existing documentation first

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

**Thank you for contributing!** Your efforts help make this project better for everyone. 🚀

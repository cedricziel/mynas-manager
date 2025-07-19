# GitHub Workflows

This directory contains GitHub Actions workflows for CI/CD:

## Workflows

### CI (`ci.yml`)
- Runs on every push to main and on pull requests
- Analyzes and tests all packages (shared, backend, frontend)
- Checks code formatting
- Builds the web application
- Uploads build artifacts

### PR Validation (`pr-validation.yml`)
- Runs on pull requests only
- Validates commit messages follow conventional commits
- Verifies AGPL-3.0 license in all packages
- Checks web build size doesn't exceed 10MB

### Release (`release.yml`)
- Runs on version tags (v*)
- Builds production releases for web and backend
- Creates GitHub releases with artifacts
- Automatically generates release notes

## Dependabot

Dependabot is configured to:
- Check for dependency updates weekly (every Monday at 9:00 AM)
- Create separate PRs for backend, frontend, and shared packages
- Keep GitHub Actions up to date
- Use conventional commit messages with appropriate scopes
# Rails 8 LazyScript Project
This project provides a collection of utility scripts designed to streamline development workflow for Rails 8 applications with Tailwind CSS. The repository contains several scripts that can be run directly from your terminal to quickly set up common functionalities.

# Key Features:

- Authentication Setup: A one-command script to set up complete authentication in a new Rails 8 project, including signup, signin, and user session management.
- Flowbite Integration: Adds Flowbite (a Tailwind CSS component library) to Rails 8 via Importmap for enhanced UI components.
- NSF (Navbar Sidebar Flowbite) Setup: Sets up an NSF configuration (likely refers to a specific setup pattern or framework).

# Usage:
These scripts are primarily intended for new Rails 8 projects with Tailwind CSS

```bash
curl -s https://raw.githubusercontent.com/jusondac/lazy_script/refs/heads/master/setup_nsf.sh | bash
```

The README specifically warns that scripts like setup_auth.sh and setup_nsf.sh are for starter projects and may cause issues if applied to projects already in development

Each script can be executed directly using curl piped to bash or by downloading and running locally

This project serves as a collection of time-saving utilities for Rails 8 developers who want to quickly bootstrap common functionality with Tailwind CSS integration.

## Available Scripts

### Authentication Setup
```bash
curl -s https://raw.githubusercontent.com/jusondac/lazy_script/refs/heads/master/setup_auth.sh | bash
```

### Flowbite Integration
```bash
curl -s https://raw.githubusercontent.com/jusondac/lazy_script/refs/heads/master/setup_flowbite.sh | bash
```

### NSF Setup
```bash
curl -s https://raw.githubusercontent.com/jusondac/lazy_script/refs/heads/master/setup_nsf.sh | bash
```

**Note:** These scripts are designed for new Rails 8 projects. Running them on established projects may cause conflicts.
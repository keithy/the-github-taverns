# Harbour Master

Centralized GitHub workflows and CI/CD configuration for the devops-cove ecosystem.

## Purpose
- Reusable GitHub Actions workflows
- Standardized CI/CD pipelines for polperro and other harbours
- Centralized configuration management

## Structure
```
harbour-master/
├── .github/workflows/     # Reusable workflow definitions
├── templates/          # Workflow templates for new projects
├── configs/            # Shared configuration files
└── README.md
```

## Usage
Add this repository as a submodule to projects needing these workflows:

```bash
git submodule add https://github.com/[your-org]/harbour-master.git .github/harbour-master
```

## Available Workflows
- [To be populated with actual workflows]
# Harbour Master

https://www.cornwallharbours.co.uk/

Shared GitHub workflows and CI/CD configuration for the devops-cove ecosystem.

## Purpose
- Reusable GitHub Actions workflows
- Standardized CI/CD pipelines for Polperro and other harbours
- Adopted using a subscription-update model.

## Structure

```
harbour-master/
├── .github/workflows/  # Reusable workflow definitions
├── config/             # Shared configuration files
└── README.md
```

## Usage

Add this repository as a submodule to projects needing these workflows:

```bash
git submodule add https://github.com/keithy/harbour-master.git .github/harbour-master
git submodule update --init
.github/harbour-master/update-workflows.sh
```

Run the update script to copy these workflows into the harbour.

## Available Workflows
- [To be populated with actual workflows]

## Customization of watchmen

The harbour-master maintains a shared library of workflows that individual ports may subscribe to. 
Most usually each *cove-port* will adopt one or more watchman. A watchman is a workflow that monitors the port
for particular changes and triggers pipeline activities. Different watchmen specialise in watching different things.

**watchman-linus** runs on a linux runner and watches three types of repository branches. If this is not exactly the
required behaviour, the harbour-master may be asked to tweak the workflow and publish it under a new name.
Each *cove-port* may select their watchmen from those available.



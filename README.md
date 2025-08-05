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
├── the-admiralty-inn/               # Harbour master bench (the authorities)
│   └── harbour-master.hm.yml        # Handoff reusable workflow (bench copy)
├── the-coopers-inn/                 # Builders bench (the coopers)
│   └── linux/                        # Builder workflows (bench copies)
├── the-lighthouse-inn/              # Watchmen bench (the lighthouse)
└── the-hook-and-tackle/                      # Shared hook scripts
```

## Usage

Add this repository as a submodule to harbours that need these workflows:

```bash
git submodule add https://github.com/keithy/harbour-master.git .github/harbour-master
git submodule update --init
```

Then copy selected bench items into the harbour’s workflows:

```bash
# Example: adopt the docker builder and harbour-master handoff
cp .github/harbour-master/the-coopers-inn/linux/builder-docker.hm.yml .github/workflows/
cp .github/harbour-master/the-admiralty-inn/harbour-master.hm.yml .github/workflows/
```

## Available Workflows
- Builders: docker, buildah, compose, configure-make, maven, gradle, node, dotnet, mise
- Watchmen: the-lighthouse-inn/watchman-linus

## Customization of watchmen

The harbour-master maintains a shared library of workflows that individual ports may subscribe to. 
Most usually each *cove-port* will adopt one or more watchman. A watchman is a workflow that monitors the port
for particular changes and triggers pipeline activities. Different watchmen specialise in watching different things.

watchman-linus runs on a linux runner and watches three types of repository branches. If this is not exactly the
required behaviour, the harbour-master may be asked to tweak the workflow and publish it under a new name.
Each *cove-port* may select their watchmen from those available.

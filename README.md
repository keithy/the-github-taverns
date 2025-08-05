# The GitHub Taverns

https://www.cornwallharbours.co.uk/

Shared GitHub workflows and CI/CD configuration for the devops-cove ecosystem.

## Purpose
- Reusable GitHub Actions workflows
- Standardized CI/CD pipelines for Polperro and other harbours
- Adopted using a subscription-update model.

## Structure

```
the-github-taverns/
├── the-admiralty-inn/               # The harbour-master's rest (the authorities)
│   └── harbour-master.hm.yml        # Workflow that receives incoming items
├── the-coopers-inn/                 # Cask/keg builders retreat (the artefact makers)
│   └── linux/                       # Tech specialist artefact makers
├── the-lighthouse-inn/              # Hangout for off duty watchmen
└── the-hook-and-tackle/             # Box of tricks, scripts and hooks
```

## Usage

This repository is provided as a submodule of devops-cove:

```bash
git clone https://github.com/keithy/devops-cove.git 
git submodule update --init
```

Populate one of the empty harbour-templates, e.g. Polperro.
Search the pubs for workers that you need, and copy them into the harbour’s `.github/workflows`

```bash
# Example: adopt the docker builder and harbour-master handoff (from the-github-taverns)
cd ~/devops-cove/polperro/.github

# Add a watchman
cp -v  ~/devops-cove/the-github-taverns/the-lighthouse-inn/watchman-linus.hm.yml workflows

# Add the harbour-master
cp -v  ~/devops-cove/the-github-taverns/the-admiralty-inn/harbour-master.hm.yml workflows

# Add tech builders for your needs
cp -v  ~/devops-cove/the-github-taverns/the-coopers-inn/linux/builder-docker.hm.yml  workflows
cp -v  ~/devops-cove/the-github-taverns/the-coopers-inn/linux/builder-buildah.hm.yml workflows

# Add the inspectors for your artefact types
cp -v  ~/devops-cove/the-github-taverns/the-shelock-holmes/investigator-keg.hm.yml workflows
```

## Available Workflows
- Builders: docker, buildah, compose, configure-make, maven, gradle, node, dotnet, mise
- Watchmen: the-lighthouse-inn/watchman-linus

## Customization of watchmen

The GitHub Taverns maintains a shared library of workflows that individual ports may subscribe to. 
Most usually each *cove-port* will adopt one or more watchman. A watchman is a workflow that monitors the port
for particular changes and triggers pipeline activities. Different watchmen specialise in watching different things.

watchman-linus runs on a linux runner and watches three types of repository branches. If this is not exactly the
required behaviour, the Navy (maintainers) may be asked to tweak the workflow code and publish it under a
new watchman name. Each *cove-port* may select their watchmen from those available.

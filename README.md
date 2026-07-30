# Donnager Administrator's Handbook

> **Official documentation repository for the Donnager scientific
> computing server**

------------------------------------------------------------------------

## Overview

The **Donnager Administrator's Handbook** is the authoritative technical
reference for the design, configuration, administration, maintenance,
and disaster recovery of **Donnager**, a Lenovo ThinkStation P510
repurposed as a scientific computing, AI, and infrastructure server.

The handbook is maintained as a **living document** under Git version
control. Source material is written in Markdown and automatically
published to PDF, with future support for HTML and EPUB.

------------------------------------------------------------------------

## Server Summary

  Item                    Value
  ----------------------- ----------------------------------------
  Server Name             Donnager
  Platform                Lenovo ThinkStation P510
  Operating System        Ubuntu 26.04 LTS
  Primary Administrator   David Woodruff (drw72)
  Documentation Version   See `VERSION`
  Repository              https://github.com/drw72/donnager-docs

------------------------------------------------------------------------

## Project Goals

-   Document every major subsystem of Donnager.
-   Provide repeatable installation and recovery procedures.
-   Maintain an accurate operational reference for upgrades and
    maintenance.
-   Preserve institutional knowledge through version control.
-   Produce publication-quality documentation from a single Markdown
    source.

------------------------------------------------------------------------

## Planned Handbook Volumes

1.  **Volume I -- JupyterHub & Scientific Python**
2.  **Volume II -- Infrastructure**
3.  **Volume III -- BASE-9 & Astronomy**
4.  **Volume IV -- Ollama & Local AI**
5.  **Volume V -- Docker, Portainer & n8n**
6.  **Volume VI -- System Administration**
7.  **Volume VII -- Maintenance & Disaster Recovery**

------------------------------------------------------------------------

## Repository Layout

``` text
assets/      Shared images, diagrams, screenshots and templates
styles/      PDF theme and build configuration
volumes/     Handbook source by volume
output/      Generated PDF, HTML and EPUB
scripts/     Utility and publishing scripts
archive/     Historical snapshots
```

------------------------------------------------------------------------

## Building the Handbook

### Prerequisites

-   Pandoc
-   XeLaTeX
-   JetBrains Mono
-   TeX Live packages

### Build all configured volumes

``` bash
./build.sh
```

### Build a single volume

``` bash
./build-volume.sh Volume-I-JupyterHub
```

Generated PDFs are written to:

``` text
output/pdf/
```

------------------------------------------------------------------------

## Version Control

Typical workflow:

``` bash
git add .
git commit -m "Describe the changes"
git push
```

------------------------------------------------------------------------

## License

See `LICENSE.md` for copyright, disclaimer, document scope, and
licensing information.

------------------------------------------------------------------------

## Status

This project is under active development and is intended to evolve
alongside the Donnager server.

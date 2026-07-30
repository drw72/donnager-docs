#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="/opt/donnager-docs"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_DIR="$ROOT_DIR/archive/bootstrap-$TIMESTAMP"

backup_if_present() {
    local path="$1"
    if [[ -e "$path" && -s "$path" ]]; then
        mkdir -p "$BACKUP_DIR/$(dirname "${path#$ROOT_DIR/}")"
        cp -a "$path" "$BACKUP_DIR/${path#$ROOT_DIR/}"
    fi
}

write_file() {
    local path="$1"
    backup_if_present "$path"
    mkdir -p "$(dirname "$path")"
    cat > "$path"
}

if [[ ! -d "$ROOT_DIR" ]]; then
    echo "ERROR: $ROOT_DIR does not exist." >&2
    exit 1
fi

if [[ ! -w "$ROOT_DIR" ]]; then
    echo "ERROR: $ROOT_DIR is not writable by $(whoami)." >&2
    echo "Fix ownership first:" >&2
    echo "  sudo chown -R \$USER:\$USER $ROOT_DIR" >&2
    exit 1
fi

mkdir -p \
    "$ROOT_DIR/assets/screenshots/jupyterhub" \
    "$ROOT_DIR/assets/screenshots/base9" \
    "$ROOT_DIR/assets/screenshots/docker" \
    "$ROOT_DIR/assets/screenshots/ollama" \
    "$ROOT_DIR/assets/screenshots/system" \
    "$ROOT_DIR/assets/diagrams" \
    "$ROOT_DIR/assets/logos" \
    "$ROOT_DIR/assets/photos" \
    "$ROOT_DIR/assets/icons" \
    "$ROOT_DIR/assets/templates" \
    "$ROOT_DIR/styles" \
    "$ROOT_DIR/output/pdf" \
    "$ROOT_DIR/output/html" \
    "$ROOT_DIR/output/epub" \
    "$ROOT_DIR/scripts" \
    "$ROOT_DIR/archive" \
    "$ROOT_DIR/volumes/Volume-I-JupyterHub/chapters" \
    "$ROOT_DIR/volumes/Volume-I-JupyterHub/figures" \
    "$ROOT_DIR/volumes/Volume-I-JupyterHub/images"

printf '0.1.0\n' > "$ROOT_DIR/VERSION"

write_file "$ROOT_DIR/styles/handbook-header.tex" <<'FILE_END'
\usepackage{fancyhdr}
\usepackage{lastpage}
\usepackage{titlesec}
\usepackage{xcolor}
\usepackage{graphicx}
\usepackage{float}
\usepackage{booktabs}
\usepackage{longtable}
\usepackage{array}
\usepackage{enumitem}
\usepackage{microtype}
\usepackage{caption}
\usepackage{setspace}

\definecolor{DonnagerBlue}{HTML}{243B53}
\definecolor{DonnagerGray}{HTML}{52606D}

\setstretch{1.08}
\setlength{\parindent}{0pt}
\setlength{\parskip}{6pt}

\titleformat{\chapter}
  {\normalfont\huge\bfseries\color{DonnagerBlue}}
  {\thechapter}{1em}{}

\titleformat{\section}
  {\normalfont\Large\bfseries\color{DonnagerBlue}}
  {\thesection}{0.75em}{}

\titleformat{\subsection}
  {\normalfont\large\bfseries\color{DonnagerGray}}
  {\thesubsection}{0.75em}{}

\pagestyle{fancy}
\fancyhf{}
\fancyhead[L]{Donnager Administrator's Handbook}
\fancyhead[R]{\leftmark}
\fancyfoot[C]{Page \thepage\ of \pageref{LastPage}}
\renewcommand{\headrulewidth}{0.4pt}
\renewcommand{\footrulewidth}{0.4pt}

\setlist[itemize]{topsep=4pt,itemsep=2pt}
\setlist[enumerate]{topsep=4pt,itemsep=2pt}
\captionsetup{font=small,labelfont=bf}
FILE_END

write_file "$ROOT_DIR/styles/pdf-defaults.yaml" <<'FILE_END'
from: markdown+yaml_metadata_block+smart
standalone: true
toc: true
toc-depth: 3
number-sections: true
pdf-engine: xelatex

variables:
  documentclass: report
  classoption:
    - oneside
    - openany
  papersize: letter
  fontsize: 11pt
  geometry:
    - top=0.85in
    - bottom=0.85in
    - left=0.9in
    - right=0.9in
    - headheight=15pt
  mainfont: DejaVu Serif
  sansfont: DejaVu Sans
  monofont: JetBrains Mono
  colorlinks: true
  linkcolor: blue
  urlcolor: blue

include-in-header:
  - styles/handbook-header.tex
FILE_END

write_file "$ROOT_DIR/volumes/Volume-I-JupyterHub/metadata.yaml" <<'FILE_END'
---
title: "Donnager Administrator's Handbook"
subtitle: "Volume I — JupyterHub and Scientific Python"
author: "Dave W."
date: "2026"
subject: "Administration of the Donnager scientific-computing server"
keywords:
  - Donnager
  - JupyterHub
  - JupyterLab
  - Scientific Python
  - Ubuntu
rights: "Private administrative documentation"
lang: en-US
---
FILE_END

write_file "$ROOT_DIR/volumes/Volume-I-JupyterHub/chapters/01-introduction.md" <<'FILE_END'
# Introduction

## Purpose

This volume documents the installation, configuration, administration, maintenance,
and recovery procedures for JupyterHub and the shared scientific Python environment
on **Donnager**.

## Server Platform

Donnager is a Lenovo ThinkStation P510 configured as a headless scientific-computing,
automation, and local-AI server.

| Component | Configuration |
|---|---|
| Operating system | Ubuntu 26.04 LTS |
| Processor | Intel Xeon E5-2680 v4 |
| Logical CPUs | 56 |
| Memory | Approximately 247 GiB |
| GPUs | Two NVIDIA Quadro M4000 8 GB |
| Storage | Six 500 GB SSDs in RAID5 |
| Remote access | Tailscale SSH and SFTP |
| Jupyter environment | Shared Conda environment under `/opt/jupyterhub` |

## Documentation Conventions

Commands intended for a normal user appear as follows:

```bash
jupyter lab --version
```

Commands requiring administrative privileges include `sudo`:

```bash
sudo systemctl status jupyterhub
```

Configuration paths, usernames, hostnames, and version numbers must be verified
before commands are executed on a production system.

## Scope

This volume covers:

1. JupyterHub architecture.
2. JupyterLab configuration.
3. Shared Conda environment administration.
4. User provisioning.
5. Scientific Python packages.
6. Git integration.
7. Themes, fonts, and keyboard shortcuts.
8. Service management.
9. Backup and recovery.
10. Troubleshooting.
FILE_END

write_file "$ROOT_DIR/volumes/Volume-I-JupyterHub/chapters/02-system-architecture.md" <<'FILE_END'
# System Architecture

## Installation Layout

The shared JupyterHub installation is maintained under:

```text
/opt/jupyterhub
```

The persistent JupyterHub process is controlled by systemd:

```bash
sudo systemctl status jupyterhub
```

## Multi-User Model

Each authorized Linux user receives an independent notebook server while using the
centrally maintained JupyterHub and scientific Python environment.

Detailed architecture diagrams and service-flow documentation will be added in a
later revision.
FILE_END

write_file "$ROOT_DIR/build-volume.sh" <<'FILE_END'
#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VOLUME_NAME="${1:-}"
VERSION="$(tr -d '[:space:]' < "$ROOT_DIR/VERSION")"

if [[ -z "$VOLUME_NAME" ]]; then
    echo "Usage: $0 <volume-directory-name>"
    echo "Example: $0 Volume-I-JupyterHub"
    exit 1
fi

VOLUME_DIR="$ROOT_DIR/volumes/$VOLUME_NAME"
CHAPTER_DIR="$VOLUME_DIR/chapters"
METADATA_FILE="$VOLUME_DIR/metadata.yaml"
OUTPUT_DIR="$ROOT_DIR/output/pdf"

[[ -d "$VOLUME_DIR" ]] || { echo "ERROR: Missing $VOLUME_DIR" >&2; exit 1; }
[[ -f "$METADATA_FILE" ]] || { echo "ERROR: Missing $METADATA_FILE" >&2; exit 1; }

mapfile -t CHAPTERS < <(
    find "$CHAPTER_DIR" -maxdepth 1 -type f -name '*.md' -print | sort
)

(( ${#CHAPTERS[@]} > 0 )) || {
    echo "ERROR: No Markdown chapters found in $CHAPTER_DIR" >&2
    exit 1
}

mkdir -p "$OUTPUT_DIR"

SAFE_NAME="${VOLUME_NAME//-/_}"
OUTPUT_FILE="$OUTPUT_DIR/Donnager_Administrators_Handbook_${SAFE_NAME}_v${VERSION}.pdf"

cd "$ROOT_DIR"

echo "Building $VOLUME_NAME..."
echo "Version: $VERSION"
echo "Chapters: ${#CHAPTERS[@]}"

pandoc \
    --defaults="$ROOT_DIR/styles/pdf-defaults.yaml" \
    --metadata-file="$METADATA_FILE" \
    --resource-path="$ROOT_DIR:$VOLUME_DIR:$CHAPTER_DIR:$ROOT_DIR/assets" \
    "${CHAPTERS[@]}" \
    --output="$OUTPUT_FILE"

echo
echo "Created:"
echo "$OUTPUT_FILE"
FILE_END

write_file "$ROOT_DIR/build.sh" <<'FILE_END'
#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

VOLUMES=(
    "Volume-I-JupyterHub"
)

for volume in "${VOLUMES[@]}"; do
    "$ROOT_DIR/build-volume.sh" "$volume"
done

echo
echo "All configured handbook volumes built successfully."
FILE_END

write_file "$ROOT_DIR/.gitignore" <<'FILE_END'
# Generated handbook output
output/pdf/*
output/html/*
output/epub/*

# Preserve empty output directories
!output/pdf/.gitkeep
!output/html/.gitkeep
!output/epub/.gitkeep

# LaTeX temporary files
*.aux
*.log
*.out
*.toc
*.fls
*.fdb_latexmk
*.synctex.gz

# Editor and OS files
*.swp
*.tmp
*.bak
.DS_Store
.vscode/
.idea/
FILE_END

touch \
    "$ROOT_DIR/output/pdf/.gitkeep" \
    "$ROOT_DIR/output/html/.gitkeep" \
    "$ROOT_DIR/output/epub/.gitkeep"

chmod +x "$ROOT_DIR/build.sh" "$ROOT_DIR/build-volume.sh"

echo
echo "Bootstrap complete."
if [[ -d "$BACKUP_DIR" ]]; then
    echo "Previous non-empty files backed up under:"
    echo "  $BACKUP_DIR"
fi

echo
echo "Verification:"
echo "  cd $ROOT_DIR"
echo "  bash -n build.sh build-volume.sh"
echo "  ./build.sh"

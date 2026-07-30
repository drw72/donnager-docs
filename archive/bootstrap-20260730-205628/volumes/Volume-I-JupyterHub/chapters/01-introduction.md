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

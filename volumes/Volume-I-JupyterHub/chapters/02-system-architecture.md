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

# kasm-OrcaSlicer

A Kasm container image for OrcaSlicer built from the official OrcaSlicer AppImage release.

## Overview

This repository builds a Docker image that installs OrcaSlicer from the upstream SoftFever/OrcaSlicer GitHub release AppImage. The container is designed for use with Kasm Workspaces and includes a custom startup script to launch OrcaSlicer in the Kasm desktop environment.

## Contents

- `Dockerfile` — builds the container image, installs dependencies, downloads the OrcaSlicer AppImage, extracts it, and prepares the runtime environment.
- `custom_startup.sh` — startup script used by the container to launch OrcaSlicer.
- `.github/workflows/docker-image-orcaslicer.yml` — GitHub Actions workflow that builds and pushes the image, and creates a GitHub release for matching versions.

## Build and publish

### Local build

To build the image locally:

```bash
docker build -t kasm-orcaslicer:latest .
```

### Push to GitHub Container Registry

The CI workflow currently publishes the image to GitHub Container Registry (`ghcr.io`). It tags the image with both `latest` and the OrcaSlicer version pulled from the upstream release.

Example push tags:

- `ghcr.io/${GITHUB_REPOSITORY_OWNER}/kasm-orcaslicer:latest`
- `ghcr.io/${GITHUB_REPOSITORY_OWNER}/kasm-orcaslicer:v2.4.2`

## CI / Release flow

The GitHub Actions workflow at `.github/workflows/docker-image-orcaslicer.yml` performs the following steps:

1. Fetches the latest OrcaSlicer release tag from `SoftFever/OrcaSlicer`.
2. Checks whether a matching release already exists in this repository.
3. Downloads the appropriate Ubuntu 24.04 AppImage asset.
4. Builds and pushes the Docker image to GHCR.
5. Creates a GitHub release when the workflow runs on `main` or via the scheduled event.

### Triggering the workflow

- `push` on `main` triggers the workflow.
- `workflow_dispatch` allows manual runs.
- a daily schedule is configured at `0 6 * * *`.

## Usage

Run the published container like any other Docker image:

```bash
docker run --rm -it ghcr.io/<owner>/kasm-orcaslicer:latest
```

In Kasm, configure the workspace to use the published image and custom startup script.

## Custom startup

`custom_startup.sh` currently launches OrcaSlicer with:

```bash
/usr/bin/desktop_ready && /opt/orcaSlicer/AppRun
```

This script may be customized to support alternate startup behavior or startup arguments.

## Notes

- The workflow uses Ubuntu 24.04 runners.
- Docker buildx is configured to build `linux/amd64` images.
- The GitHub release creation step runs for scheduled builds and main branch pushes so release records stay aligned with published images.

## Contributing

1. Fork the repository.
2. Create a feature branch.
3. Make your changes.
4. Submit a pull request.

---

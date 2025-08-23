<p align="center">
    <picture>
        <source media="(prefers-color-scheme: dark)" srcset=".meta/logo-dark.png" width="40%" />
        <source media="(prefers-color-scheme: light)" srcset=".meta/logo-light.png" width="40%" />
        <img alt="T3 Foundation" src=".meta/logo-light.png" width="40%" />
    </picture>
</p>

# T3 Gemstone Nextcloud

 [![T3 Foundation](./.meta/t3-foundation.svg)](https://www.t3vakfi.org/en) [![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## What is it?

Preconfigured Nextcloud DEB package generator for easy installation and deployment in the Gemstone Cloud project.

Includes the following additional apps beyond the base Nextcloud installation:

- Passman (open-source password manager)
- Deck (Trello-style kanban task management)
- Drawio (diagramming tool)
- Spreed (video chat and messaging)
- RichDocuments (online office suite)
- Calendar (scheduling and events)

## Prerequisites

The project utilizes devbox as its build system. Please install it from [here](https://www.jetify.com/docs/devbox/installing_devbox/).

## Usage

Activate the jetify-devbox shell to automatically install tools

```bash
$ devbox shell
```

During development, use the following command for quick packaging and testing:

```bash
📦 devbox:t3-gem-nextcloud> task build
```

The package will be generated at: build/t3-gem-nextcloud_{VERSION}_all.deb

To create a release version, run:

```bash
📦 devbox:t3-gem-nextcloud> task release
```

The release package will be generated at: release/t3-gem-nextcloud_{VERSION}_all.deb

## Docker

For Docker instructions, read [docker/README.md]. Make any necessary changes, then run:

```bash
📦 devbox:t3-gem-nextcloud> task docker-start
```

To stop the containers, run:

```bash
📦 devbox:t3-gem-nextcloud> task docker-stop
```
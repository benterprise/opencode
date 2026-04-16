# Building opencode locally

## Prerequisites

- [Bun](https://bun.sh) 1.3+
- Git

## Setup

```bash
git clone https://github.com/benterprise/opencode.git
cd opencode
bun install
```

## Running without a build (dev mode)

From the repo root, runs directly from source with no compile step:

```bash
bun dev
```

To run it against a specific directory:

```bash
bun dev /path/to/your/project
```

## Building a standalone binary

Builds a native executable for your current platform only:

```bash
cd packages/opencode
bun run build --single
```

Output lands at:

| Platform        | Path |
|-----------------|------|
| Windows x64     | `packages/opencode/dist/opencode-windows-x64/bin/opencode.exe` |
| macOS arm64     | `packages/opencode/dist/opencode-darwin-arm64/bin/opencode` |
| macOS x64       | `packages/opencode/dist/opencode-darwin-x64/bin/opencode` |
| Linux x64       | `packages/opencode/dist/opencode-linux-x64/bin/opencode` |

To build for all platforms at once (takes longer):

```bash
cd packages/opencode
bun run build
```

## Using with the local model config

Copy `opencode.json` from this directory to your project folder (or `~/.config/opencode/`),
then run the binary from that directory:

```bash
# Windows
.\opencode-windows-x64\bin\opencode.exe

# macOS / Linux
./opencode-darwin-arm64/bin/opencode
```

The binary picks up `opencode.json` from the current directory automatically.
Start llama-server first using `llama-vulkan-gpt-oss.bat` before launching opencode.

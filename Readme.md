# r

A minimal script to automatically detect and run the `dev` script for whatever language i'm working on.

Detection order
- `package.json` (npm)
- `go.mod` (go)
- `requirements.txt` (python)
- `Cargo.toml` (rust)
- `makefile` (c)
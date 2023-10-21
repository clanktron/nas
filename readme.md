# NAS
Custom kairos OS based on ubuntu 22.04 LTS.
For a list of built-in packages refer to packages.txt

## Build
```bash
make
```

## Testing
For a live demo environment run:
```bash
CLI=docker # could be nerdctl/podman/etc
VERSION=0.1.1
"$CLI" run -it quay.io/clanktron/nas:"$VERSION" fish
```

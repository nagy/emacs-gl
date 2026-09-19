#!/usr/bin/env sh
# Generate the glad OpenGL loader (GL 4.3 compatibility profile).
#
# Usage: ./gen-glad.sh [output-dir]   (default: build/glad)
#
# Requires python3.  glad 0.1.x is installed into a throwaway virtualenv.

set -eu

OUT="${1:-build/glad}"

python3 -m venv .venv-glad
.venv-glad/bin/pip -q install 'glad==0.1.34'
.venv-glad/bin/glad --profile=compatibility --api='gl=4.3' \
    --generator=c --out-path="$OUT"

echo "glad generated in $OUT"

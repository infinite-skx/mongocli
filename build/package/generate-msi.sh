#!/usr/bin/env bash
# Copyright 2020 MongoDB Inc
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


set -Eeou pipefail

GOCACHE="$(cygpath --mixed "${workdir:?}\.gocache")"
CGO_ENABLED=0
export GOCACHE
export CGO_ENABLED

go-msi check-env

SOURCE_FILES=./cmd/mongocli

VERSION=$(git describe | cut -d "v" -f 2)
COMMIT=$(git log -n1 --format=format:"%H")

env GOOS=windows GOARCH=amd64 go build \
  -ldflags "-s -w -X github.com/mongodb/mongocli/internal/version.Version=${VERSION} -X github.com/mongodb/mongocli/internal/version.GitCommit=${COMMIT}" \
  -o ./bin/mongocli.exe "${SOURCE_FILES}"

go-msi make --msi "dist/mongocli_${VERSION}_windows_x86_64.msi" --version "${VERSION}"

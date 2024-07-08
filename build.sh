#!/usr/bin/env bash
# ./build.sh


: "${VERSION?:VERSION has to be specified}"

go build -ldflags "-X="github.com/arsenidze/kbot/cmd.appVersion=$VERSION

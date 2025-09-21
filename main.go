package main

import (
	"fmt"
	"runtime/debug"
)

var version string

func main() {
	if version == "" {
		if bi, ok := debug.ReadBuildInfo(); ok {
			version = bi.Main.Version
		}
	}

	fmt.Printf("sample-go-github-actions version %s\n", version) //nolint:forbidigo
}

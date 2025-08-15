package main

import (
	"fmt"
	"os"
)

const version = "1.0.0"

func main() {
	for _, arg := range os.Args[1:] {
		if arg == "-v" || arg == "-version" {
			fmt.Printf("sample-go-github-actions version %s\n", version)
			os.Exit(0)
		}
	}
}

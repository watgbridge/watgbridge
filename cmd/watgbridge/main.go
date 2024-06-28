package main

import (
	"fmt"
	"github.com/watgbridge/watgbridge/cmd/watgbridge/binConfig"
)

func main() {
	fmt.Printf("%#v\n", binConfig.AllConfigOptions)
	fmt.Println("Hello, World!")
}

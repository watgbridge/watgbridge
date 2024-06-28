package main

import (
	"fmt"

	"github.com/watgbridge/watgbridge/cmd/watgbridge/binConfig"
	"github.com/watgbridge/watgbridge/cmd/watgbridge/state"
)

func main() {
	fmt.Printf("%#v\n", binConfig.AllConfigOptions)
	fmt.Println("VERSION:", state.VERSION)
}

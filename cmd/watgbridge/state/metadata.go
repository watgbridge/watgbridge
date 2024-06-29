package state

import "strconv"

var Version = "2.0.0"

var SupportsBinaryUpdatesStr = "true"
var SupportsBinaryUpdates = true

func init() {
	SupportsBinaryUpdates, _ = strconv.ParseBool(SupportsBinaryUpdatesStr)
}

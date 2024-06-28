package binConfig

import (
	commonConfig "github.com/watgbridge/watgbridge/config"
)

var AllConfigOptions = []commonConfig.ConfigOption{
	commonConfig.NewConfigOption(
		[]string{""},
		"",
		false, false,
		commonConfig.ConfigOptionDataTypeBool, nil,
		nil,
	),
}

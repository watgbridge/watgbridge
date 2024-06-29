package binConfig

import (
	commonConfig "github.com/watgbridge/watgbridge/config"
)

type Config struct {
	Telegram struct{} `mapstructure:"telegram"`
	WhatsApp struct{} `mapstructure:"whatsapp"`
	General  struct {
		TimeZone string `mapstructure:"time_zone"`
	} `mapstructure:"general"`
}

var AllConfigOptions = []commonConfig.ConfigOption{
	commonConfig.NewConfigOption(
		[]string{"general", "time_zone"},
		"",
		false, false,
		commonConfig.ConfigOptionDataTypeBool, nil,
		nil,
	),
}

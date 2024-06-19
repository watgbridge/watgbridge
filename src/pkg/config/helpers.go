package config

import (
	"fmt"

	"github.com/spf13/viper"
)

// `configOptions` is all the valid configuration options
// `configPaths` are the paths where to find the config file(s)
// `configName` is the name of the files (without the extension) that will be read. (Eg "config")
// `envPrefix` is the prefix before the environment variables that will be read for values. Viper automatically adds an underscore after the prefix.
func LoadConfig[C any](
	configOptions []ConfigOption,
	configPaths []string,
	configName string,
	envPrefix string,
) (*C, error) {
	for _, opt := range configOptions {
		if opt.Default != nil {
			viper.SetDefault(opt.ViperKey(), opt.Default)
		}
	}
	viper.SetConfigName(configName)
	for _, path := range configPaths {
		viper.AddConfigPath(path)
	}
	viper.SetEnvPrefix(envPrefix)
	viper.AutomaticEnv()

	err := viper.ReadInConfig()
	if err != nil {
		return nil, fmt.Errorf("viper failed to read config: %w", err)
	}

	var cfg C
	err = viper.Unmarshal(&cfg)
	if err != nil {
		return nil, fmt.Errorf("failed to unmarshal config options into struct: %w", err)
	}
	return &cfg, nil
}

func ValidateConfig(configOptions []ConfigOption) error {
	for _, opt := range configOptions {
		var (
			key   = opt.ViperKey()
			isSet = viper.IsSet(key)
			value = viper.Get(key)
		)

		if !isSet {
			if opt.Required {
				return fmt.Errorf("[%s] is a required key, but not set", key)
			}
			continue
		}

		if opt.Validator != nil {
			if err := opt.Validator(opt, value); err != nil {
				return err
			}
		}
	}

	return nil
}

func ValidateOptions(configOptions []ConfigOption) error {
	for _, opt := range configOptions {
		if opt.Validator == nil {
			return fmt.Errorf("[%s] validator is nil", opt.ViperKey())
		}

		if opt.Default != nil && opt.Validator(opt, opt.Default) != nil {
			return fmt.Errorf("[%s] default value does not pass its validator", opt.ViperKey())
		}
	}
	return nil
}

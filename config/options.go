package config

import (
	"reflect"
	"strings"
)

type ConfigOptionDataType uint8

const (
	ConfigOptionDataTypeInt64 ConfigOptionDataType = iota
	ConfigOptionDataTypeString
	ConfigOptionDataTypeBool
	ConfigOptionDataTypePath
	ConfigOptionDataTypeListOfInt64s
	ConfigOptionDataTypeListOfStrings
)

type ConfigOption struct {
	Default     any                   `json:"default"`
	Validator   ConfigOptionValidator `json:"-"`
	Description string                `json:"description"`
	Path        []string              `json:"path"`
	Required    bool                  `json:"required"`
	Type        ConfigOptionDataType  `json:"type"`
	TgMutable   bool                  `json:"mutable"`
}

func NewConfigOption(
	path []string, description string,
	required, mutable bool,
	dataType ConfigOptionDataType,
	defaultValue any, validator ConfigOptionValidator,
) ConfigOption {
	return ConfigOption{
		Path:        path,
		Type:        dataType,
		Description: description,
		Default:     defaultValue,
		TgMutable:   mutable,
		Validator:   validator,
		Required:    required,
	}
}

func (opt ConfigOption) ViperKey() string {
	return strings.Join(opt.Path, ".")
}

func init() {

	{
		// Check that the constructor function has all the fields
		// TODO: find a way to make this a compile time check
		newConfigOptionFuncInputsNum := reflect.TypeOf(NewConfigOption).NumIn()
		configOptionFieldsNum := reflect.TypeOf(ConfigOption{}).NumField()
		if newConfigOptionFuncInputsNum != configOptionFieldsNum {
			panic("The number of fields in ConfigOption struct doesn't match the number of inputs in the NewConfigOption function. Report this to the developer of the project by opening an issue on GitHub or in the Telegram group.")
		}
	}
}

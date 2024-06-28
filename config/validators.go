package config

import (
	"errors"
	"fmt"
	"net/url"
	"os"
	"reflect"
	"slices"
	"strings"
	"time"

	"golang.org/x/exp/constraints"
)

type ConfigOptionValidator func(opt ConfigOption, v any) error

func ExpectType[T any](v any) error {
	switch v.(type) {
	case T:
		return nil
	default:
		return fmt.Errorf(
			"expected value of type %s, got %s",
			reflect.TypeFor[T]().Name(),
			reflect.TypeOf(v).Name(),
		)
	}
}

func EnumValidatorGen[T comparable](acceptableValues ...T) ConfigOptionValidator {
	if len(acceptableValues) == 0 {
		panic("list of acceptable values should not be empty")
	}

	return func(opt ConfigOption, v any) error {
		if err := ExpectType[T](v); err != nil {
			return fmt.Errorf("[%s] unexpected type: %w", opt.ViperKey(), err)
		}
		val := v.(T)

		if !slices.Contains(acceptableValues, val) {
			return fmt.Errorf(
				"[%s] unexpected value: got %#v, acceptable values: %#v",
				opt.ViperKey(), val, acceptableValues,
			)
		}

		return nil
	}
}

func EnumListValidatorGen[T comparable](acceptableValues ...T) ConfigOptionValidator {
	if len(acceptableValues) == 0 {
		panic("list of acceptable values should not be empty")
	}

	return func(opt ConfigOption, v any) error {
		if err := ExpectType[[]T](v); err != nil {
			return fmt.Errorf("[%s] unexpected type: %w", opt.ViperKey(), err)
		}
		vals := v.([]T)

		for idx, val := range vals {
			if !slices.Contains(acceptableValues, val) {
				return fmt.Errorf(
					"[%s] unexpected value at index %d: got %#v, acceptable values: %#v",
					opt.ViperKey(), idx, val, acceptableValues,
				)
			}
		}

		return nil
	}
}

func TimeZoneValidator(opt ConfigOption, v any) error {
	if err := ExpectType[string](v); err != nil {
		return fmt.Errorf("[%s] unexpected type: %w", opt.ViperKey(), err)
	}
	val := v.(string)

	if _, err := time.LoadLocation(val); err != nil {
		return fmt.Errorf(
			"[%s] failed to resolve the time zone: %w",
			opt.ViperKey(), err,
		)
	}

	return nil
}

func PathValidator(opt ConfigOption, v any) error {
	if err := ExpectType[string](v); err != nil {
		return fmt.Errorf("[%s] unexpected type: %w", opt.ViperKey(), err)
	}
	val := v.(string)

	if _, err := os.Stat(val); err != nil {
		if os.IsNotExist(err) {
			return fmt.Errorf(
				"[%s] provided path does not exist: %w",
				opt.ViperKey(), err,
			)
		} else if os.IsTimeout(err) {
			return fmt.Errorf(
				"[%s] time ran out while checking the path: %w",
				opt.ViperKey(), err,
			)
		} else if os.IsPermission(err) {
			return fmt.Errorf(
				"[%s] not enough permissions to read the path: %w",
				opt.ViperKey(), err,
			)
		} else {
			return fmt.Errorf(
				"[%s] unknown error occurred while checking the path: %w",
				opt.ViperKey(), err,
			)
		}
	}

	return nil
}

func URLValidator(opt ConfigOption, v any) error {
	if err := ExpectType[string](v); err != nil {
		return fmt.Errorf("[%s] unexpected type: %w", opt.ViperKey(), err)
	}
	val := v.(string)

	if _, err := url.Parse(val); err != nil {
		return fmt.Errorf(
			"[%s] failed to parse the URL: %w",
			opt.ViperKey(), err,
		)
	}

	return nil
}

func NonEmptyStringValidtorGen(cleanWhitespace bool) ConfigOptionValidator {
	return func(opt ConfigOption, v any) error {
		if err := ExpectType[string](v); err != nil {
			return fmt.Errorf("[%s] unexpected type: %w", opt.ViperKey(), err)
		}
		val := v.(string)

		if cleanWhitespace {
			val = strings.TrimSpace(val)
		}

		if val == "" {
			return fmt.Errorf("[%s] expected a non-empty string", opt.ViperKey())
		}

		return nil
	}
}

func NonEmptyListValidator[T any](opt ConfigOption, v any) error {
	if err := ExpectType[[]T](v); err != nil {
		return fmt.Errorf("[%s] unexpected type: %w", opt.ViperKey(), err)
	}
	val := v.([]T)

	if len(val) == 0 {
		return fmt.Errorf("[%s] expected a non-empty list", opt.ViperKey())
	}

	return nil
}

func NonZeroNumberValidator[T constraints.Integer | constraints.Float](opt ConfigOption, v any) error {
	if err := ExpectType[T](v); err != nil {
		return fmt.Errorf("[%s] unexpected type: %w", opt.ViperKey(), err)
	}
	val := v.(T)

	if val == 0 {
		return fmt.Errorf("[%s] expected a non-zero number", opt.ViperKey())
	}

	return nil
}

func AndValidator(validators ...ConfigOptionValidator) ConfigOptionValidator {
	return func(opt ConfigOption, v any) error {
		for _, validator := range validators {
			err := validator(opt, v)
			if err != nil {
				return err
			}
		}
		return nil
	}
}

func OrValidator(validators ...ConfigOptionValidator) ConfigOptionValidator {
	return func(opt ConfigOption, v any) error {
		var errs = []error{}

		for _, validator := range validators {
			err := validator(opt, v)
			if err != nil {
				return nil
			}
			errs = append(errs, err)
		}

		errString := fmt.Sprintf("[%s] value should satisfy atleast one of the conditions:", opt.ViperKey())
		for idx, err := range errs {
			errString += fmt.Sprintf("\n%d. %v", idx+1, err)
		}
		return errors.New(errString)
	}
}

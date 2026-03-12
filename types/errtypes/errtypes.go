// Package errtypes contains custom error types
package errtypes

import (
	"fmt"
	"strings"
)

const (
	UnknownPsyllamaKeyErrMsg = "unknown psyllama key"
	InvalidModelNameErrMsg = "invalid model name"
)

// TODO: This should have a structured response from the API
type UnknownPsyllamaKey struct {
	Key string
}

func (e *UnknownPsyllamaKey) Error() string {
	return fmt.Sprintf("unauthorized: %s %q", UnknownPsyllamaKeyErrMsg, strings.TrimSpace(e.Key))
}

//go:build debug

package cpu

// #cgo CPPFLAGS: -DPSYLLAMA_DEBUG
import "C"

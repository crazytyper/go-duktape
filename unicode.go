package duktape

import (
	"C"
	"github.com/crazytyper/go-cesu8"
)

func goString(c *C.char) string {
	// duktape encodes string as CESU-8 (a variation of UTF-8).
	// https://duktape.org/guide.html#type-string.
	return cesu8.DecodeString([]byte(C.GoString(c)))
}
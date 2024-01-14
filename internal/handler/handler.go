package handler

import (
	"fmt"
	"net/http"
)

func Health(
	w http.ResponseWriter,
	_ *http.Request,
) {
	fmt.Fprintf(w, "OK")
}

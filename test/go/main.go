package main

import (
	"fmt"
	"net/http"
	"os"

	"github.com/labstack/echo/v4"
)

func main() {
	e := echo.New()

	var PORT string
	if len(os.Args) > 1 {
		PORT = os.Args[1]
	} else {
		PORT = "3000"
	}

	// send "Hello World"
	e.GET("/", func(c echo.Context) error {
		return c.String(http.StatusOK, "Helloxxx World")
	})

	fmt.Println("Listening on port " + PORT)
	http.ListenAndServe(":"+PORT, e)
}

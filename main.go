package main

// based on http://thenewstack.io/building-a-web-server-in-go/

import (
	"io"
	"net/http"
)

func demo(w http.ResponseWriter, r *http.Request) {
	io.WriteString(w, "The demo works!")
}

var mux map[string]func(http.ResponseWriter, *http.Request)

func main() {
	server := http.Server{
		Addr:    ":80",
		Handler: &myHandler{},
	}

	mux = make(map[string]func(http.ResponseWriter, *http.Request))
	mux["/"] = demo

	server.ListenAndServe()
}

type myHandler struct{}

func (*myHandler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	if h, ok := mux[r.URL.String()]; ok {
		h(w, r)
		return
	}

	io.WriteString(w, "This page intentionally left blank")
}

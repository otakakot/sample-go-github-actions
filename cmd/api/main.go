package main

import (
	"context"
	"errors"
	"log/slog"
	"net/http"
	"os"
	"os/signal"
	"time"

	"github.com/otakakot/sample-go-github-actions/internal/handler"
)

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	hdl := http.NewServeMux()

	hdl.HandleFunc("/health", handler.Health)

	const timeout = 30

	server := &http.Server{
		Addr:              ":" + port,
		Handler:           hdl,
		ReadHeaderTimeout: timeout * time.Second,
	}

	go func() {
		slog.Info("Server is starting...")

		if err := server.ListenAndServe(); err != nil && !errors.Is(err, http.ErrServerClosed) {
			panic(err)
		}
	}()

	quit := make(chan os.Signal, 1)
	signal.Notify(quit, os.Interrupt)
	<-quit
	slog.Info("Server is shutting down...")

	ctx, cancel := context.WithTimeout(context.Background(), timeout*time.Second)
	defer cancel()

	if err := server.Shutdown(ctx); err != nil {
		panic(err)
	}

	slog.Info("Server exiting")
}

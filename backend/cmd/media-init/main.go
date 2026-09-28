package main

import (
	"RPG-manager/backend/internal/media"
	"context"
	"fmt"
	"os"
	"time"
)

func main() {
	ctx, cancel := context.WithTimeout(context.Background(), 45*time.Second)
	defer cancel()
	storage, err := media.New(ctx)
	if err == nil {
		err = storage.Provision(ctx)
	}
	if err != nil {
		fmt.Fprintln(os.Stderr, "Storage initialization failed:", err)
		os.Exit(1)
	}
	fmt.Println("Media bucket ready (anonymous object reads only).")
}

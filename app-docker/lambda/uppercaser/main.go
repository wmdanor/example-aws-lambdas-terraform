package main

import (
	"context"
	"encoding/json"
	"fmt"
	"log/slog"
	"strings"

	"github.com/aws/aws-lambda-go/lambda"
)

type Data struct {
	Message string `json:"message"`
}

func handleRequest(ctx context.Context, event json.RawMessage) (Data, error) {
	slog.Info("Received request")

	var data Data
	if err := json.Unmarshal(event, &data); err != nil {
		slog.Error("Failed to unmarshall event", "err", err)
		return Data{}, err
	}

	if data.Message == "" {
		slog.Error("Message must not be empty")
		return Data{}, fmt.Errorf("message must not be empty")
	}

	slog.Info("Received message", "str", data.Message)

	return Data{
		Message: strings.ToUpper(data.Message),
	}, nil
}

func main() {
	lambda.Start(handleRequest)
}

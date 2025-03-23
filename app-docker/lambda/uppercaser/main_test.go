package main

import (
	"context"
	"encoding/json"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestHandleRequest(t *testing.T) {
	t.Run("ValidEvent", func(t *testing.T) {
		event := `{ "message": "Hello" }`

		data, err := handleRequest(context.Background(), json.RawMessage(event))

		assert.Nil(t, err)

		assert.Equal(t, data.Message, "HELLO")
	})

	t.Run("InvalidEvent", func(t *testing.T) {
		event := `{ "msg": "Hello" }`

		_, err := handleRequest(context.Background(), json.RawMessage(event))

		assert.Error(t, err)
	})
}

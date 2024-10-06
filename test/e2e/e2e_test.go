package e2e_test

import (
	"context"
	"net/http"
	"os"
	"testing"
)

func TestE2E(t *testing.T) {
	t.Parallel()

	endpoint := os.Getenv("ENDPOINT")
	if endpoint == "" {
		endpoint = "http://localhost:8080"
	}

	t.Run("e2e_test", func(t *testing.T) {
		t.Parallel()

		req, err := http.NewRequest(http.MethodGet, endpoint+"/health", nil)
		if err != nil {
			t.Fatal(err)
		}

		ctx := context.Background()

		res, err := http.DefaultClient.Do(req.WithContext(ctx))
		if err != nil {
			t.Fatal(err)
		}

		defer res.Body.Close()

		if res.StatusCode != http.StatusOK {
			t.Errorf("unexpected status code: %d", res.StatusCode)
		}
	})
}

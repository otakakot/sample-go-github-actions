package integration_test

import (
	"cmp"
	"os"
	"testing"

	"github.com/otakakot/sample-go-github-actions/internal/postgres"
)

func TestIntegration(t *testing.T) {
	t.Parallel()

	dsn := cmp.Or(os.Getenv("POSTGRES_URL"), "postgres://postgres:postgres@localhost:5432/postgres?sslmode=disable")

	db, err := postgres.New(dsn)
	if err != nil {
		t.Fatal(err)
	}

	t.Run("integration_test", func(t *testing.T) {
		t.Parallel()

		if _, err := db.ExecContext(t.Context(), "SELECT 1"); err != nil {
			t.Errorf("failed to exec database: %v", err)
		}
	})
}

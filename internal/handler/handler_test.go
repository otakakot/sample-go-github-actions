package handler_test

import (
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/otakakot/sample-go-github-actions/internal/handler"
)

func TestHealth(t *testing.T) {
	t.Parallel()

	type args struct {
		w http.ResponseWriter
		r *http.Request
	}

	tests := []struct {
		name string
		args args
		want string
	}{
		{
			name: "OK",
			args: args{
				w: httptest.NewRecorder(),
				r: &http.Request{},
			},
			want: "OK",
		},
	}

	for _, tt := range tests {
		tt := tt
		t.Run(tt.name, func(t *testing.T) {
			t.Parallel()
			handler.Health(tt.args.w, tt.args.r)
			checkedGot, ok := tt.args.w.(*httptest.ResponseRecorder)
			if !ok {
				t.Fatalf("failed to cast w to *httptest.ResponseRecorder")
			}
			if got := checkedGot.Body.String(); got != tt.want {
				t.Errorf("Health() = %v, want %v", got, tt.want)
			}
		})
	}
}

package main

import (
	"encoding/json"
	"fmt"
	"log"
	"math/rand"
	"net/http"
	"os"
	"time"
)

var startTime = time.Now()

// バージョンはビルド時に -ldflags で注入する
var version = "dev"

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	mux := http.NewServeMux()
	mux.HandleFunc("/health", handleHealth)
	mux.HandleFunc("/api/info", handleInfo)
	mux.HandleFunc("/simulate/slow", handleSimulateSlow)
	mux.HandleFunc("/simulate/error", handleSimulateError)

	log.Printf("sre-dojo app starting on :%s", port)
	if err := http.ListenAndServe(":"+port, mux); err != nil {
		log.Fatal(err)
	}
}

// GET /health — ALBヘルスチェック用。余計なことはしない
func handleHealth(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(http.StatusOK)
	_, _ = fmt.Fprint(w, "ok")
}

// GET /api/info — サービスの状態確認用
func handleInfo(w http.ResponseWriter, r *http.Request) {
	hostname, _ := os.Hostname()

	info := map[string]any{
		"service":  "sre-dojo",
		"version":  version,
		"uptime":   time.Since(startTime).String(),
		"hostname": hostname,
	}

	w.Header().Set("Content-Type", "application/json")
	_ = json.NewEncoder(w).Encode(info)
}

// GET /simulate/slow — 意図的な遅延。障害シナリオのテスト用
func handleSimulateSlow(w http.ResponseWriter, r *http.Request) {
	delay := time.Duration(1+rand.Intn(5)) * time.Second
	log.Printf("simulate/slow: sleeping %s", delay)
	time.Sleep(delay)

	w.Header().Set("Content-Type", "application/json")
	_ = json.NewEncoder(w).Encode(map[string]any{
		"status": "slow_response",
		"delay":  delay.String(),
	})
}

// GET /simulate/error — 意図的な500エラー。アラート検知の訓練用
func handleSimulateError(w http.ResponseWriter, r *http.Request) {
	log.Printf("simulate/error: returning 500")
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusInternalServerError)
	_ = json.NewEncoder(w).Encode(map[string]any{
		"status":  "error",
		"message": "simulated internal server error",
	})
}

package main

import (
	"os/exec"
	"time"
	"net/http"
)

func main() {
	lmao := time.Now().Format("🌈 02 Jan @ 3")
	exec.Command("git", "add", ".").Run()
	exec.Command("git", "commit", "-m", lmao).Run()
	exec.Command("git", "push", "origin", "main").Run()
	http.Get("https://betteruptime.com/api/v1/heartbeat/zfnS1uFSeYdSwQY41Na7mMRW")
}
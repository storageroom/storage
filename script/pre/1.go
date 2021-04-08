package main

import (
	"fmt"
	"log"
	"time"
	"os/exec"
)

var fabberbjipojirdoed string = "clear"

func main() {
	fmt.Println("optional: curl -L archfi.sf.net/archfi > archfi")
	time.Sleep(2 * time.Second)
	fmt.Println("")
	fmt.Println("starting")
	time.Sleep(3 * time.Second)
	cmd := exec.Command(fabberbjipojirdoed)
	err := cmd.Run()
	if err != nil {
		log.Fatal(err)
	}
}
package main

import (
	"os/exec"
	"strconv"
	"fmt"
	"time"
	"strings"
	"github.com/getsentry/sentry-go"
	"log"
)

func main() {
	// control variable for testing
	// getlatesttag := "v10.9.9"

	err := sentry.Init(sentry.ClientOptions{
		Dsn: "https://70f5eb6587754686892d08ceebc22bbc@o1153157.ingest.sentry.io/6232041",
	})
	if err != nil {
		log.Fatalf("sentry.Init: %s", err)
	}

	// MAP: 
	// TAG -> getlatesttag
	// TAGY -> getlastdigit
	// TAGX -> incrementlastdigit
	// TAGA -> getfirstdigits
	// TAGL -> getseconddigit
	// TAGO -> getfirstdigit
	// TAGF -> finaltag

	lmao, err := exec.Command("git", "describe", "--abbrev=0", "--tags").Output()
	if err != nil {
		log.Fatalf("sentry.Init: %s", err)
	}

	getlatesttag := string(lmao)
	fmt.Println("the initial (latest) tag is: ", getlatesttag)

	getlastdigit := getlatesttag[5:6]
	getfirstdigits := getlatesttag[0:5]
	getfirstdigit := getlatesttag[1:2]
	getseconddigit := getlatesttag[3:4]
	lastdigitconvertstringtonumber, err := strconv.Atoi(getlastdigit)
	incrementlastdigit := lastdigitconvertstringtonumber + 1
	lastdigitconvertnumbertostring := strconv.Itoa(incrementlastdigit)
	finaltag := strings.Join([]string{getfirstdigits, lastdigitconvertnumbertostring}, "")

	if err != nil {
		log.Fatalf("sentry.Init: %s", err)
	}	

	// if the last digit is 9, eg. v0.0.9,
	if getlastdigit == "9" {
		// make the last digit 0 (and add one to the second digit later)
		lastdigitconvertnumbertostring = "0"
		if getseconddigit == "9" {
			// if the second digit is also 9, eg. v0.9.9
			// make the second digit 0 {
			getseconddigit = "0"
			// } add one to the first digit {
			firstdigitconvertstringtonumber, err := strconv.Atoi(getfirstdigit) // Convert string to int
			newfirstdigit := firstdigitconvertstringtonumber + 1 // add one
			getfirstdigit = strconv.Itoa(newfirstdigit) // Convert int to string as per variable type
			// } result: 1.0.0
			if err != nil {
				log.Fatalf("sentry.Init: %s", err)
			}
		} else {
			// else if it is not 9, eg. v0.8.9
			// add one to the second digit {
			seconddigitconvertstringtonumber, err := strconv.Atoi(getseconddigit) // Convert string to int
			newseconddigit := seconddigitconvertstringtonumber + 1 // add one
			getseconddigit = strconv.Itoa(newseconddigit) // Convert int to string as per variable type
			// } result: v0.9.0
			if err != nil {
				log.Fatalf("sentry.Init: %s", err)
			}
		}
		almostfinaltag := strings.Join([]string{getfirstdigit, getseconddigit, lastdigitconvertnumbertostring}, ".") //"v$TAGO.$TAGL.$TAGX"
		finaltag = strings.Join([]string{"v", almostfinaltag}, "")
	}

	// get the length of the final tag
	TAGLENGTH := len(finaltag)
	// if the length of the final tag is over 6, trim it
	if TAGLENGTH > 6 {
		fmt.Println("the length of the version number is over 6, will trim")
		fmt.Println(finaltag)
		fmt.Println("tag length: ", TAGLENGTH)
		finaltag = finaltag[0:6]
	}

	fmt.Println("the new tag is: ", finaltag)
	exec.Command("git", "add", ".").Run()
	exec.Command("git", "commit", "-m", "🫣").Run()
	exec.Command("git", "tag", "-a", finaltag, "-m", "its new release time!! ✨").Run()
	exec.Command("git", "push", "origin", finaltag).Run()
	exec.Command("git", "push", "origin", "main").Run()

	// Flush buffered events before the program terminates.
	defer sentry.Flush(2 * time.Second)
	sentry.CaptureMessage("It works!")
}

package main

import (
	"os/exec"
	"strconv"
	"fmt"
	"strings"
)

func main() {
	// control variable for testing
	// getlatesttag := "v10.9.9"

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
        fmt.Println(err)
    }

	getlatesttag := string(lmao)
	fmt.Println("the latest tag is: ", getlatesttag)

	getlastdigit := getlatesttag[5:6]
	getfirstdigits := getlatesttag[0:5]
	getfirstdigit := getlatesttag[1:2]
	getseconddigit := getlatesttag[3:4]
	lastdigitconvertstringtonumber, _ := strconv.Atoi(getlastdigit)
	incrementlastdigit := lastdigitconvertstringtonumber + 1
	lastdigitconvertnumbertostring := strconv.Itoa(incrementlastdigit)
	finaltag := strings.Join([]string{getfirstdigits, lastdigitconvertnumbertostring}, "")

	// if the last digit is 9, eg. v0.0.9,
	if getlastdigit == "9" {
		// make the last digit 0 (and add one to the second digit later)
		lastdigitconvertnumbertostring = "0"
		if getseconddigit == "9" {
			// if the second digit is also 9, eg. v0.9.9
			// make the second digit 0 {
			getseconddigit = "0"
			// } add one to the first digit {
			firstdigitconvertstringtonumber, _ := strconv.Atoi(getfirstdigit) // Convert string to int
			newfirstdigit := firstdigitconvertstringtonumber + 1 // add one
			getfirstdigit = strconv.Itoa(newfirstdigit) // Convert int to string as per variable type
			// } result: 1.0.0
		} else {
			// else if it is not 9, eg. v0.8.9
			// add one to the second digit {
			seconddigitconvertstringtonumber, _ := strconv.Atoi(getseconddigit) // Convert string to int
			newseconddigit := seconddigitconvertstringtonumber + 1 // add one
			getseconddigit = strconv.Itoa(newseconddigit) // Convert int to string as per variable type
			// } result: v0.9.0
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

	exec.Command("git", "add", ".")
	exec.Command("git", "commit", "-m", "🫣")
	exec.Command("git", "tag", "-a", finaltag, "-m", "its new release time!! ✨")
	exec.Command("git", "push", "origin", finaltag)
	exec.Command("git", "push", "origin", "main")
}

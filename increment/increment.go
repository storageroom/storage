package main

import (
	"log"
	"os"
	"os/exec"
	"strconv"
	"strings"

	"github.com/getsentry/sentry-go"
)

func main() {
	var erroraaa bool = false
	var finaltag string

	key := os.Getenv("key")

	uuuuuuuuu := sentry.Init(sentry.ClientOptions{
		Dsn: key,
	})
	if uuuuuuuuu != nil {
		log.Fatalf("sentry.Init: %s", uuuuuuuuu)
	}

	lmao, asdf := exec.Command("git", "describe", "--abbrev=0", "--tags").Output()
	if asdf != nil {
		sentry.CaptureMessage(string(lmao))
	}

	getlatesttag := string(lmao)
	log.Println("the initial (latest) tag is: ", getlatesttag)

	// set default values
	dotposition1 := 2
	dotposition2 := 3

	firstdigitposition1 := 1
	firstdigitposition2 := 2

	lastdigitposition1 := 5
	lastdigitposition2 := 6

	seconddigitposition1 := 3
	seconddigitposition2 := 4

	isdotthere := getlatesttag[dotposition1:dotposition2]

	for isdotthere != "." {
		dotposition1 = dotposition1 + 1
		dotposition2 = dotposition2 + 1

		firstdigitposition2 = firstdigitposition2 + 1
	
		seconddigitposition1 = seconddigitposition1 + 1
		seconddigitposition2 = seconddigitposition2 + 1

		lastdigitposition1 = lastdigitposition1 + 1
		lastdigitposition2 = lastdigitposition2 + 1

		isdotthere = getlatesttag[dotposition1:dotposition2]
	}

	getfirstdigit := getlatesttag[firstdigitposition1:firstdigitposition2]
	getseconddigit := getlatesttag[seconddigitposition1:seconddigitposition2]
	getlastdigit := getlatesttag[lastdigitposition1:lastdigitposition2]

	// if the last digit is 9, eg. v0.0.9,
	if getlastdigit == "9" {
		// make the last digit 0 (and add one to the second digit later)
		getlastdigit = "0"
		if getseconddigit == "9" {
			// if the second digit is also 9, eg. v0.9.9
			// make the second digit 0 {
			getseconddigit = "0"
			// } add one to the first digit {
			firstdigitconvertstringtonumber, wkauhfsevuiejroefw := strconv.Atoi(getfirstdigit) // Convert string to int
			newfirstdigit := firstdigitconvertstringtonumber + 1 // add one
			getfirstdigit = strconv.Itoa(newfirstdigit) // Convert int to string as per variable type
			// } result: 1.0.0
			if wkauhfsevuiejroefw != nil {
				sentry.CaptureException(wkauhfsevuiejroefw)
			}
		} else {
			// else if it is not 9, eg. v0.8.9
			// add one to the second digit {
			seconddigitconvertstringtonumber, ueworiyiou4783788 := strconv.Atoi(getseconddigit) // Convert string to int
			newseconddigit := seconddigitconvertstringtonumber + 1 // add one
			getseconddigit = strconv.Itoa(newseconddigit) // Convert int to string as per variable type
			// } result: v0.9.0
			if ueworiyiou4783788 != nil {
				sentry.CaptureException(ueworiyiou4783788)
			}
		}
	} else {
		// if last digit is not 9, increment the last digit by 1
		lastdigitconvertstringtonumber, sahdiahd := strconv.Atoi(getlastdigit)
		if sahdiahd != nil {
			sentry.CaptureException(sahdiahd)
		}	
		incrementlastdigit := lastdigitconvertstringtonumber + 1
		getlastdigit = strconv.Itoa(incrementlastdigit)
	}

	almostfinaltag := strings.Join([]string{getfirstdigit, getseconddigit, getlastdigit}, ".")
	finaltag = strings.Join([]string{"v", almostfinaltag}, "")

	log.Println("the new tag is: ", finaltag)

	gitadd, adderr := exec.Command("git", "add", ".").Output()
	if adderr != nil {
		log.Println(string(gitadd))
		log.Println(adderr)
		sentry.CaptureMessage(string(gitadd))
		log.Println("there was an error when performing git push")
		erroraaa = true
	}

	gitcommit, commiterr := exec.Command("git", "commit", "-m", "🫣").Output()
	log.Println(string(gitcommit))
	if commiterr != nil {
		log.Println(commiterr)
		sentry.CaptureMessage(string(gitcommit))
		log.Println("there was an error when performing git push")
		erroraaa = true
	}

	gittag, tagerr := exec.Command("git", "tag", "-a", finaltag, "-m", "its new release time!! ✨").Output()
	if tagerr != nil {
		log.Println(string(gittag))
		log.Println(tagerr)
		sentry.CaptureMessage(string(gittag))
		log.Println("there was an error when performing git push")
		erroraaa = true
	}

	gitpushtag, pushtagerr := exec.Command("git", "push", "origin", finaltag).Output()
	if pushtagerr != nil {
		log.Println(string(gitpushtag))
		log.Println(pushtagerr)
		sentry.CaptureMessage(string(gitpushtag))
		log.Println("there was an error when performing git push")
		erroraaa = true
	}

	gitpushmain, pushmainerr := exec.Command("git", "push", "origin", "main").Output()
	if pushmainerr != nil {
		log.Println(string(gitpushmain))
		log.Println(pushmainerr)
		sentry.CaptureMessage(string(gitpushmain))
		log.Println("there was an error when performing git push")
		erroraaa = true
	}

	if erroraaa {
			log.Println("there was an error")
		}

}

package main

import (
	"fmt"
)

var (
	//Version no of this application
	Version string
	//Build no of this application
	Build string
)

func main() {
	fmt.Println("Hello Alerting Service")
	fmt.Println("Version:", Version)
	fmt.Println("Build no:", Build)
}

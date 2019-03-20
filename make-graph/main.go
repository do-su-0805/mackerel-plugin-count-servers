package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
)

// Dashborad : For `api/v0/dashboard` return
type Dashborad struct {
	ID        string
	CreatedAt int
	UpdatedAt int
	Title     string
	URLPath   string
	Memo      string
	Widgets   []Widget
}

// Widget : For dashboard's widget
type Widget struct {
	Type     string
	Title    string
	Markdown string
	Layout   GraphLayout
	Metric   MetricInfo
	Graph    GraphInfo
}

// GraphLayout : For widget's layout
type GraphLayout struct {
	X      int
	Y      int
	Width  int
	Height int
}

// MetricInfo : For widget's MetricType
type MetricInfo struct {
	Type       string
	HostID     string
	Name       string
	Expression string
}

// GraphInfo : For widget's GraphInfo
type GraphInfo struct {
	Type       string
	HostID     string
	Name       string
	Expression string
}

// Role : For Mackerel Role
type Role struct {
	Roles []RoleInfo
}

// RoleInfo : For Mackerel Role
type RoleInfo struct {
	Name string
}

func main() {
	// For Debug
	DashboardURL := os.Getenv("BASEURL") + "dashboards/" + os.Getenv("DASHBOARD_ID")

	// Request For Getting Dashboard
	req, err := http.NewRequest("GET", DashboardURL, nil)
	if err != nil {
		log.Fatal(err)
	}
	req.Header.Set("X-Api-Key", os.Getenv("MACKEREL_APIKEY"))

	client := new(http.Client)
	res, err := client.Do(req)
	if err != nil {
		log.Fatal(err)
	}

	defer res.Body.Close()
	var dashboard Dashborad
	if err := json.NewDecoder(res.Body).Decode(&dashboard); err != nil {
		log.Fatal(err)
	}

	// fmt.Printf("||||%+v", dashboard)
	for _, w := range dashboard.Widgets {
		fmt.Printf("%+v\n", w)
	}

	// For Debug
	RolesURL := os.Getenv("BASEURL") + "services/" + os.Getenv("SERVICE") + "/roles"

	//  Request For Getting Roles
	req, err = http.NewRequest("GET", RolesURL, nil)
	if err != nil {
		log.Fatal(err)
	}
	req.Header.Set("X-Api-Key", os.Getenv("MACKEREL_APIKEY"))

	client = new(http.Client)
	res, err = client.Do(req)
	if err != nil {
		log.Fatal(err)
	}

	defer res.Body.Close()
	var Roles Role
	if err := json.NewDecoder(res.Body).Decode(&Roles); err != nil {
		log.Fatal(err)
	}

	for _, r := range Roles.Roles {
		fmt.Printf("%+v\n", r)
	}

}

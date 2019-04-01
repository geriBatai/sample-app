package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"text/template"
)

var tmpl = `
<html>
<head>
  <title>{{ .Title }}</title>
  <style>
  body {
    background-color: #fafafa;
	font-family: San Francisco, Helvetica; 
	color: #444;
	margin: 0;
	padding: 0;
  }

  .topnav {
    overflow: hidden;
  }

  .topnav ul {
    list-style: none;
  }

  .topnav a {
    float: left;
    color: #f2f2f2;
    text-align: center;
    padding: 14px 16px;
    text-decoration: none;
    font-size: 17px;
  }


  .blue {
	background-color: #3AAED8;
  }

  .green {
    background-color: #52AA8A;
  }

  .container {
    display: table;
  }
  .centered {
	position: fixed;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
  }
  </style>
</head>

<body>
  <div class="topnav {{ .Title }}">
    <ul>
     	<li><a href="#">sample-app</a></li>
    </ul>
  </div>

  <div class="container">
  <div class="centered"><h1>Hello {{ .Title }}</h1></div>
  </div>
</body>
`

func defaultHandler(w http.ResponseWriter, r *http.Request) {
	t, err := template.New("out").Parse(tmpl)
	if err != nil {
		_, _ = fmt.Fprintf(w, "Error rendering template: %s", err.Error())
		return
	}
	vars := struct {
		Title string
	}{
		Title: colour(),
	}
	_ = t.Execute(w, vars)
}

func envHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Printf(colour())
}

func colour() string {
	c := os.Getenv("POD_DEPLOYMENT_COLOUR")
	if c == "" {
		c = "None"
	}
	return c
}

func main() {
	http.HandleFunc("/", defaultHandler)
	http.HandleFunc("/env", envHandler)
	log.Fatal(http.ListenAndServe(":8080", nil))
}

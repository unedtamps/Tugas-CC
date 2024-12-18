package main

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"html/template"
	"io/ioutil"
	"log"
	"math/rand"
	"net/http"
	"os"
	"time"

	_ "github.com/lib/pq"
)

type Trivia struct {
	ID       string `json:"id"`
	Question struct {
		Text string `json:"text"`
	} `json:"question"`
	Answer string `json:"correctAnswer"`
}

var templates = template.Must(template.ParseFiles("index.html"))

var db *sql.DB

func main() {
	var err error
	db_name := os.Getenv("DB_NAME")
	password := os.Getenv("DB_PASSWORD")
	username := os.Getenv("DB_USERNAME")
	host := os.Getenv("DB_HOST")
	db, err = sql.Open(
		"postgres",
		fmt.Sprintf(
			"postgresql://%s:%s@%s:5432/%s?sslmode=disable",
			username,
			password,
			host,
			db_name,
		),
	)
	if err := db.Ping(); err != nil {
		log.Fatalf(err.Error())
	}

	sqlFile := "database.sql"

	sqlContent, err := ioutil.ReadFile(sqlFile)

	if err != nil {
		log.Fatalf("Failed to read SQL file: %v", err)
	}

	if _, err := db.Exec(string(sqlContent)); err != nil {
		log.Fatalf("Failed to execute SQL file: %v", err)
	}
	fmt.Println("Run the sql")

	go fetchAndInsertTrivia()

	http.HandleFunc("/", triviaHandler)
	http.HandleFunc("/reveal-answer/", revealAnswerHandler)
	if err := http.ListenAndServe(":8000", nil); err != nil {
		log.Fatal("Error")
	}
}

func getRandomTrivia() (*Trivia, error) {
	rand.Seed(time.Now().UnixNano())

	var trivia Trivia
	err := db.QueryRow("SELECT id, question, answer FROM trivia OFFSET floor(random() * (SELECT COUNT(*) FROM trivia)) LIMIT 1").
		Scan(
			&trivia.ID,
			&trivia.Question.Text,
			&trivia.Answer,
		)
	if err != nil {
		return nil, err
	}
	return &trivia, nil
}

func revealAnswerHandler(w http.ResponseWriter, r *http.Request) {
	id := r.URL.Path[len("/reveal-answer/"):]
	var answer string
	if err := db.QueryRow("SELECT answer FROM trivia WHERE id = $1", id).Scan(&answer); err != nil {
		http.Error(w, "Answer not found", http.StatusNotFound)
		log.Printf("Error fetching answer for ID %s: %v", id, err)
		return
	}
	w.Header().Set("Content-Type", "text/html")
	fmt.Fprintf(w, "<p> %s </p>", answer)
}

func triviaHandler(w http.ResponseWriter, r *http.Request) {
	trivia, err := getRandomTrivia()
	if err != nil {
		http.Error(w, "Failed to fetch trivia", http.StatusInternalServerError)
		log.Printf("Error fetching trivia: %v", err)
		return
	}

	w.Header().Set("Content-Type", "text/html")
	templates.ExecuteTemplate(w, "index.html", trivia)
}

func fetchAndInsertTrivia() {
	for {
		apiURL := "https://the-trivia-api.com/v2/questions"
		resp, err := http.Get(apiURL)
		if err != nil {
			log.Printf("failed to fetch data from API: %v", err)

		}
		defer resp.Body.Close()

		if resp.StatusCode != http.StatusOK {
			log.Printf("unexpected status code: %d", resp.StatusCode)
		}

		var triviaList []Trivia
		if err := json.NewDecoder(resp.Body).Decode(&triviaList); err != nil {
			log.Printf("failed to decode JSON: %v", err)
		}

		for _, trivia := range triviaList {
			if _, err := db.Exec(
				"INSERT INTO trivia (id, question, answer) VALUES ($1, $2, $3)",
				trivia.ID, trivia.Question.Text, trivia.Answer,
			); err != nil {
				log.Printf("Failed to insert trivia ID %s: %v", trivia.ID, err)
			}
		}
		fmt.Println("Success insert")
		time.Sleep(5 * time.Second)
	}
}

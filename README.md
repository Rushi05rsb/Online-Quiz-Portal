# Quiz Portal

A college web project built with Python, Flask, HTML, CSS, and MySQL. Students choose a quiz, answer multiple-choice questions, receive an immediate score with answer review, and appear on the leaderboard.

## Features

- Responsive home page listing available quizzes
- Multiple-choice Python Basics quiz
- Name validation and immediate score calculation
- Correct-answer review after submission
- MySQL storage for quizzes, questions, options, and results
- Leaderboard for the latest 50 submissions
- Student registration, login, and personal result history
- Separate administrator login and dashboard
- Administrator controls to create quizzes, add or delete questions, and enable or disable student accounts

## Setup

1. Install Python 3.10 or newer and MySQL Server.
2. Start MySQL Server (for example, through MySQL Workbench or XAMPP).
3. Open `schema.sql` in MySQL Workbench and run the entire script. It creates the `quiz_portal` database, sample questions, and user-account table.
4. In `app.py`, edit the `password` entry in `DB_CONFIG` if your MySQL root account has a password. You can instead set the `DB_PASSWORD` environment variable.
5. Open a terminal in this folder and run:

   ```powershell
   py -m venv venv
   .\venv\Scripts\Activate.ps1
   pip install -r requirements.txt
   python app.py
   ```

6. Visit [http://127.0.0.1:5000](http://127.0.0.1:5000) in your browser.

## Login accounts

When the application starts, it creates a demo administrator account if one does not already exist:

| Role | Email | Password |
| --- | --- | --- |
| Administrator | `admin@quizportal.local` | `Admin@123` |

Students create their own account through **Create student account** on the home page. The application stores passwords as hashes, not plain text.

For a real deployment, change the administrator credentials using `ADMIN_EMAIL` and `ADMIN_PASSWORD` environment variables before starting the application.

## Database tables

| Table | Purpose |
| --- | --- |
| `quizzes` | Quiz title and description |
| `questions` | Questions belonging to each quiz |
| `options` | Four answer options and the correct-answer flag |
| `results` | Each student's score and submission time |

## Adding another question

1. Insert the question into the `questions` table using the correct `quiz_id`.
2. Use the new question's ID to insert four rows in `options`.
3. Set `is_correct` to `TRUE` for exactly one option.

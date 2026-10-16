# Online Quiz Portal

A web-based Online Quiz Management System developed using Python, Flask, HTML, CSS, and MySQL. Students can register, log in, attempt quizzes, receive their scores, review answers, and view their results.

## Technologies Used

* Python
* Flask
* HTML
* CSS
* MySQL
* Git and GitHub

## Features

### Student Panel

* Student registration and login.
* Select and attempt available quizzes.
* Multiple-choice questions for programming subjects.
* Automatic score calculation after submission.
* Review submitted answers and correct answers.
* View personal quiz results and history.
* View the leaderboard.

### Admin Panel

* Secure administrator login.
* View and manage student accounts.
* Create and manage quizzes.
* Add and delete quiz questions.
* Manage quiz availability.
* Enable or disable student accounts.

### Other Features

* Responsive web interface.
* MySQL database integration.
* Automatic result storage.
* Password hashing for user accounts.
* Leaderboard displaying recent quiz submissions.

## Project Structure

```text
Online-Quiz-Portal/
│
├── app.py
├── requirements.txt
├── README.md
├── .env.example
├── .gitignore
├── schema.sql
├── add_15_questions.sql
│
├── static/
│   └── style.css
│
└── templates/
    ├── admin_dashboard.html
    ├── base.html
    ├── error.html
    ├── index.html
    ├── leaderboard.html
    ├── login.html
    ├── quiz.html
    ├── register.html
    ├── result.html
    └── student_dashboard.html
```

## System Requirements

* Python 3.10 or newer.
* MySQL Server.
* Visual Studio Code or another code editor.
* A modern web browser.
* Git, if you want to manage the source code using version control.

## Installation and Setup

### Step 1: Clone the Repository

Open your terminal and run:

```bash
git clone https://github.com/Rushi05rsb/Online-Quiz-Portal.git
```

Navigate to the project directory:

```bash
cd Online-Quiz-Portal
```

### Step 2: Create a Virtual Environment

On Windows, run:

```powershell
py -m venv venv
```

Activate the environment:

```powershell
.\venv\Scripts\Activate.ps1
```

### Step 3: Install Dependencies

Install the required Python packages:

```bash
pip install -r requirements.txt
```

### Step 4: Configure MySQL

1. Install and start MySQL Server.
2. Open `schema.sql` in MySQL Workbench.
3. Execute the SQL script to create the database and its initial tables and data.
4. Configure the database connection in accordance with the settings used by `app.py`.

If your application uses environment variables for database credentials, configure them locally before starting the application.

**Security note:** Do not publish your actual database password, application secret key, or other private credentials in this repository.

### Step 5: Start the Application

Run:

```bash
python app.py
```

Open your browser and visit:

http://127.0.0.1:5000/

The application should be accessible locally if the server starts successfully and the database connection is configured correctly.

## Database Tables

The application uses MySQL to store the information required by the quiz website. Depending on the database schema, the main tables include:

| Table                  | Purpose                                            |
| ---------------------- | -------------------------------------------------- |
| `quizzes`              | Stores quiz titles and descriptions.               |
| `questions`            | Stores questions belonging to quizzes.             |
| `options`              | Stores answer options and correctness information. |
| `results`              | Stores student scores and submission times.        |
| Student accounts table | Stores student account information.                |

The administrator dashboard manages student records and quiz content through the application.

## Adding Quiz Questions

Questions can be managed through the administrator panel if the relevant functionality is enabled in the application.

The supplied `add_15_questions.sql` file can also be used to add questions, provided it matches the database schema.

Before executing an SQL script, verify that it targets the correct database and does not overwrite data you need to preserve.

## Security Considerations

* Never commit a real `.env` file containing credentials.
* Keep `.env.example` limited to placeholder values.
* Do not use default demonstration administrator credentials in a public deployment.
* Use strong administrator credentials.
* Store passwords using secure password hashing.
* Use parameterized SQL queries to help prevent SQL injection.
* Do not include real student records or private information in the repository.

## Limitations

* A local development server is intended for testing, not public production hosting.
* Internet access requires deployment to a suitable hosting service.
* The MySQL database must be configured separately.
* Features available to administrators and students depend on the current implementation.

## Future Enhancements

* Add more programming subjects and question banks.
* Introduce quiz time limits.
* Add difficulty levels for questions.
* Generate downloadable result reports.
* Improve the administrator analytics dashboard.
* Add randomized questions and answer options.
* Deploy the application to a suitable web hosting platform.

## Author

**Name:** Rushiraj Bhosale

**Course:** Master of Computer Applications (MCA)

**Project:** Online Quiz Management System

**Technologies:** Python, Flask, HTML, CSS, MySQL

## License

Add a license if you intend to distribute this project under specific reuse terms. Otherwise, clarify the intended usage before selecting one.

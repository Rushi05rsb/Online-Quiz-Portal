"""Quiz Portal: a Flask and MySQL college project."""
import os
import re
from functools import wraps

import mysql.connector
from flask import Flask, flash, g, redirect, render_template, request, session, url_for
from mysql.connector import Error
from werkzeug.security import check_password_hash, generate_password_hash

app = Flask(__name__)
app.config["SECRET_KEY"] = os.getenv("SECRET_KEY", "replace-this-for-production")

# Set these values as environment variables or change them for your MySQL setup.
DB_CONFIG = {
    "host": os.getenv("DB_HOST", "localhost"),
    "user": os.getenv("DB_USER", "root"),
    "password": os.getenv("DB_PASSWORD", "rushiraj"),
    "database": os.getenv("DB_NAME", "quiz_portal"),
}


def get_connection():
    """Return a new connection to the Quiz Portal MySQL database."""
    return mysql.connector.connect(**DB_CONFIG)


def close_database(connection, cursor):
    """Close database resources when they were opened successfully."""
    if cursor:
        cursor.close()
    if connection and connection.is_connected():
        connection.close()


def create_user_table():
    """Create login storage and a demo administrator on the first application run."""
    connection = None
    cursor = None
    try:
        connection = get_connection()
        cursor = connection.cursor()
        cursor.execute(
            """
            CREATE TABLE IF NOT EXISTS users (
                id INT AUTO_INCREMENT PRIMARY KEY,
                full_name VARCHAR(100) NOT NULL,
                email VARCHAR(150) NOT NULL UNIQUE,
                password_hash VARCHAR(255) NOT NULL,
                role ENUM('admin', 'student') NOT NULL DEFAULT 'student',
                is_active BOOLEAN NOT NULL DEFAULT TRUE,
                created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
            )
            """
        )

        admin_email = os.getenv("ADMIN_EMAIL", "admin@quizportal.local").lower()
        admin_password = os.getenv("ADMIN_PASSWORD", "Admin@123")
        cursor.execute("SELECT id FROM users WHERE email = %s", (admin_email,))
        if cursor.fetchone() is None:
            cursor.execute(
                """
                INSERT INTO users (full_name, email, password_hash, role)
                VALUES (%s, %s, %s, 'admin')
                """,
                ("Quiz Administrator", admin_email, generate_password_hash(admin_password)),
            )
        connection.commit()
    except Error as error:
        app.logger.warning("Authentication table setup failed: %s", error)
    finally:
        close_database(connection, cursor)


@app.before_request
def load_current_user():
    """Load an active session user and remove sessions for disabled users."""
    g.current_user = None
    if request.endpoint == "static" or "user_id" not in session:
        return

    connection = None
    cursor = None
    try:
        connection = get_connection()
        cursor = connection.cursor(dictionary=True)
        cursor.execute(
            """
            SELECT id, full_name, email, role, is_active
            FROM users
            WHERE id = %s
            """,
            (session["user_id"],),
        )
        user = cursor.fetchone()
        if user and user["is_active"]:
            g.current_user = user
        else:
            session.clear()
    except Error:
        session.clear()
    finally:
        close_database(connection, cursor)


@app.context_processor
def inject_current_user():
    return {"current_user": getattr(g, "current_user", None)}


def login_required(view):
    @wraps(view)
    def wrapped_view(*args, **kwargs):
        if not g.current_user:
            flash("Please sign in as a student to continue.")
            return redirect(url_for("student_login"))
        return view(*args, **kwargs)

    return wrapped_view


def role_required(role):
    def decorator(view):
        @wraps(view)
        def wrapped_view(*args, **kwargs):
            if not g.current_user:
                flash("Please sign in to continue.")
                return redirect(url_for("admin_login" if role == "admin" else "student_login"))
            if g.current_user["role"] != role:
                flash("You do not have permission to open that page.")
                return redirect(url_for("home"))
            return view(*args, **kwargs)

        return wrapped_view

    return decorator


def is_valid_email(email):
    return bool(re.fullmatch(r"[^@\s]+@[^@\s]+\.[^@\s]+", email))


def sign_in(user):
    session.clear()
    session["user_id"] = user["id"]


@app.route("/")
def home():
    """Show the quizzes available to students."""
    connection = None
    cursor = None
    try:
        connection = get_connection()
        cursor = connection.cursor(dictionary=True)
        cursor.execute(
            """
            SELECT quizzes.id, quizzes.title, quizzes.description,
                   COUNT(questions.id) AS question_count
            FROM quizzes
            LEFT JOIN questions ON quizzes.id = questions.quiz_id
            GROUP BY quizzes.id, quizzes.title, quizzes.description
            ORDER BY quizzes.title
            """
        )
        return render_template("index.html", quizzes=cursor.fetchall())
    except Error as error:
        return render_template("error.html", message=f"Could not connect to MySQL: {error}"), 500
    finally:
        close_database(connection, cursor)


@app.route("/login/student", methods=["GET", "POST"])
def student_login():
    if g.current_user:
        return redirect(url_for("student_dashboard" if g.current_user["role"] == "student" else "admin_dashboard"))

    if request.method == "POST":
        email = request.form.get("email", "").strip().lower()
        password = request.form.get("password", "")
        connection = None
        cursor = None
        try:
            connection = get_connection()
            cursor = connection.cursor(dictionary=True)
            cursor.execute("SELECT * FROM users WHERE email = %s AND role = 'student'", (email,))
            user = cursor.fetchone()
            if user and user["is_active"] and check_password_hash(user["password_hash"], password):
                sign_in(user)
                return redirect(url_for("student_dashboard"))
            flash("Invalid email or password. Check that your account is active.")
        except Error as error:
            return render_template("error.html", message=f"Login failed: {error}"), 500
        finally:
            close_database(connection, cursor)
    return render_template("login.html", role="student")


@app.route("/login/admin", methods=["GET", "POST"])
def admin_login():
    if g.current_user:
        return redirect(url_for("admin_dashboard" if g.current_user["role"] == "admin" else "student_dashboard"))

    if request.method == "POST":
        email = request.form.get("email", "").strip().lower()
        password = request.form.get("password", "")
        connection = None
        cursor = None
        try:
            connection = get_connection()
            cursor = connection.cursor(dictionary=True)
            cursor.execute("SELECT * FROM users WHERE email = %s AND role = 'admin'", (email,))
            user = cursor.fetchone()
            if user and user["is_active"] and check_password_hash(user["password_hash"], password):
                sign_in(user)
                return redirect(url_for("admin_dashboard"))
            flash("Invalid administrator email or password.")
        except Error as error:
            return render_template("error.html", message=f"Login failed: {error}"), 500
        finally:
            close_database(connection, cursor)
    return render_template("login.html", role="admin")


@app.route("/register", methods=["GET", "POST"])
def register():
    """Allow students to create their own account."""
    if g.current_user:
        return redirect(url_for("home"))

    if request.method == "POST":
        full_name = request.form.get("full_name", "").strip()[:100]
        email = request.form.get("email", "").strip().lower()[:150]
        password = request.form.get("password", "")
        confirm_password = request.form.get("confirm_password", "")

        if len(full_name) < 2:
            flash("Enter a name with at least two characters.")
        elif not is_valid_email(email):
            flash("Enter a valid email address.")
        elif len(password) < 6:
            flash("Use a password with at least six characters.")
        elif password != confirm_password:
            flash("The passwords do not match.")
        else:
            connection = None
            cursor = None
            try:
                connection = get_connection()
                cursor = connection.cursor()
                cursor.execute("SELECT id FROM users WHERE email = %s", (email,))
                if cursor.fetchone():
                    flash("An account with this email already exists. Please sign in.")
                else:
                    cursor.execute(
                        """
                        INSERT INTO users (full_name, email, password_hash, role)
                        VALUES (%s, %s, %s, 'student')
                        """,
                        (full_name, email, generate_password_hash(password)),
                    )
                    connection.commit()
                    flash("Student account created. You can sign in now.")
                    return redirect(url_for("student_login"))
            except Error as error:
                return render_template("error.html", message=f"Could not create the account: {error}"), 500
            finally:
                close_database(connection, cursor)
    return render_template("register.html")


@app.route("/logout")
def logout():
    session.clear()
    flash("You have been signed out.")
    return redirect(url_for("home"))


@app.route("/student/dashboard")
@role_required("student")
def student_dashboard():
    """Show a student's available quizzes and their own recorded results."""
    connection = None
    cursor = None
    try:
        connection = get_connection()
        cursor = connection.cursor(dictionary=True)
        cursor.execute(
            """
            SELECT quizzes.id, quizzes.title, quizzes.description,
                   COUNT(questions.id) AS question_count
            FROM quizzes
            LEFT JOIN questions ON quizzes.id = questions.quiz_id
            GROUP BY quizzes.id, quizzes.title, quizzes.description
            ORDER BY quizzes.title
            """
        )
        quizzes = cursor.fetchall()
        cursor.execute(
            """
            SELECT quizzes.title, results.score, results.total_questions, results.taken_at
            FROM results
            INNER JOIN quizzes ON quizzes.id = results.quiz_id
            WHERE results.student_name = %s
            ORDER BY results.taken_at DESC
            LIMIT 10
            """,
            (g.current_user["full_name"],),
        )
        results = cursor.fetchall()
        return render_template("student_dashboard.html", quizzes=quizzes, results=results)
    except Error as error:
        return render_template("error.html", message=f"Could not load the student dashboard: {error}"), 500
    finally:
        close_database(connection, cursor)


@app.route("/quiz/<int:quiz_id>")
@role_required("student")
def quiz(quiz_id):
    """Display every question and option belonging to one quiz."""
    connection = None
    cursor = None
    try:
        connection = get_connection()
        cursor = connection.cursor(dictionary=True)
        cursor.execute("SELECT id, title, description FROM quizzes WHERE id = %s", (quiz_id,))
        selected_quiz = cursor.fetchone()
        if selected_quiz is None:
            return render_template("error.html", message="The requested quiz does not exist."), 404

        cursor.execute("SELECT id, question_text FROM questions WHERE quiz_id = %s ORDER BY id", (quiz_id,))
        questions = cursor.fetchall()
        if not questions:
            return render_template("error.html", message="This quiz has no questions yet."), 400

        for question in questions:
            cursor.execute("SELECT id, option_text FROM options WHERE question_id = %s ORDER BY id", (question["id"],))
            question["options"] = cursor.fetchall()
        return render_template("quiz.html", quiz=selected_quiz, questions=questions)
    except Error as error:
        return render_template("error.html", message=f"Database error: {error}"), 500
    finally:
        close_database(connection, cursor)


@app.route("/submit/<int:quiz_id>", methods=["POST"])
@role_required("student")
def submit_quiz(quiz_id):
    """Calculate a student's score, store it, and show the answer review."""
    connection = None
    cursor = None
    try:
        connection = get_connection()
        cursor = connection.cursor(dictionary=True)
        cursor.execute("SELECT title FROM quizzes WHERE id = %s", (quiz_id,))
        selected_quiz = cursor.fetchone()
        if selected_quiz is None:
            return render_template("error.html", message="The requested quiz does not exist."), 404

        cursor.execute("SELECT id, question_text FROM questions WHERE quiz_id = %s ORDER BY id", (quiz_id,))
        questions = cursor.fetchall()
        score = 0

        for question in questions:
            cursor.execute(
                "SELECT id, option_text, is_correct FROM options WHERE question_id = %s ORDER BY id",
                (question["id"],),
            )
            options = cursor.fetchall()
            selected_option_id = request.form.get(f"question_{question['id']}", type=int)
            correct_option = next((option for option in options if option["is_correct"]), None)
            selected_option = next((option for option in options if option["id"] == selected_option_id), None)
            is_correct = bool(correct_option and selected_option_id == correct_option["id"])
            if is_correct:
                score += 1
            question["selected_answer"] = selected_option["option_text"] if selected_option else "Not answered"
            question["correct_answer"] = correct_option["option_text"] if correct_option else "Not configured"
            question["is_correct"] = is_correct

        cursor.execute(
            """
            INSERT INTO results (student_name, quiz_id, score, total_questions)
            VALUES (%s, %s, %s, %s)
            """,
            (g.current_user["full_name"], quiz_id, score, len(questions)),
        )
        connection.commit()
        return render_template(
            "result.html",
            student_name=g.current_user["full_name"],
            quiz_title=selected_quiz["title"],
            score=score,
            total_questions=len(questions),
            questions=questions,
        )
    except Error as error:
        return render_template("error.html", message=f"Could not save the result: {error}"), 500
    finally:
        close_database(connection, cursor)


@app.route("/leaderboard")
def leaderboard():
    """Show the most recent quiz results, with highest scores first."""
    connection = None
    cursor = None
    try:
        connection = get_connection()
        cursor = connection.cursor(dictionary=True)
        cursor.execute(
            """
            SELECT results.student_name, quizzes.title, results.score,
                   results.total_questions, results.taken_at
            FROM results
            INNER JOIN quizzes ON quizzes.id = results.quiz_id
            ORDER BY results.score DESC, results.taken_at DESC
            LIMIT 50
            """
        )
        return render_template("leaderboard.html", results=cursor.fetchall())
    except Error as error:
        return render_template("error.html", message=f"Database error: {error}"), 500
    finally:
        close_database(connection, cursor)


@app.route("/admin/dashboard")
@role_required("admin")
def admin_dashboard():
    """Give administrators a view of students, quizzes, and questions."""
    connection = None
    cursor = None
    try:
        connection = get_connection()
        cursor = connection.cursor(dictionary=True)

        cursor.execute("SELECT COUNT(*) AS value FROM users WHERE role = 'student'")
        student_count = cursor.fetchone()["value"]
        cursor.execute("SELECT COUNT(*) AS value FROM quizzes")
        quiz_count = cursor.fetchone()["value"]
        cursor.execute("SELECT COUNT(*) AS value FROM questions")
        question_count = cursor.fetchone()["value"]
        cursor.execute("SELECT COUNT(*) AS value FROM results")
        attempt_count = cursor.fetchone()["value"]

        cursor.execute("SELECT id, title FROM quizzes ORDER BY title")
        quizzes = cursor.fetchall()
        cursor.execute(
            """
            SELECT questions.id, questions.question_text, quizzes.title
            FROM questions INNER JOIN quizzes ON quizzes.id = questions.quiz_id
            ORDER BY questions.id DESC LIMIT 20
            """
        )
        questions = cursor.fetchall()
        cursor.execute(
            """
            SELECT id, full_name, email, is_active, created_at
            FROM users WHERE role = 'student'
            ORDER BY created_at DESC
            """
        )
        students = cursor.fetchall()

        return render_template(
            "admin_dashboard.html",
            counts={"students": student_count, "quizzes": quiz_count, "questions": question_count, "attempts": attempt_count},
            quizzes=quizzes,
            questions=questions,
            students=students,
        )
    except Error as error:
        return render_template("error.html", message=f"Could not load the admin dashboard: {error}"), 500
    finally:
        close_database(connection, cursor)


@app.route("/admin/quizzes/add", methods=["POST"])
@role_required("admin")
def add_quiz():
    title = request.form.get("title", "").strip()[:120]
    description = request.form.get("description", "").strip()[:500]
    if not title or not description:
        flash("Enter both a quiz title and a description.")
        return redirect(url_for("admin_dashboard"))

    connection = None
    cursor = None
    try:
        connection = get_connection()
        cursor = connection.cursor()
        cursor.execute("INSERT INTO quizzes (title, description) VALUES (%s, %s)", (title, description))
        connection.commit()
        flash("New quiz created.")
    except Error as error:
        flash(f"Could not create the quiz: {error}")
    finally:
        close_database(connection, cursor)
    return redirect(url_for("admin_dashboard"))


@app.route("/admin/questions/add", methods=["POST"])
@role_required("admin")
def add_question():
    quiz_id = request.form.get("quiz_id", type=int)
    question_text = request.form.get("question_text", "").strip()[:1000]
    options = [request.form.get(f"option_{number}", "").strip()[:500] for number in range(1, 5)]
    correct_option = request.form.get("correct_option", type=int)

    if not quiz_id or not question_text or not all(options) or correct_option not in range(1, 5):
        flash("Enter a question, four options, and select one correct answer.")
        return redirect(url_for("admin_dashboard"))

    connection = None
    cursor = None
    try:
        connection = get_connection()
        cursor = connection.cursor()
        cursor.execute("INSERT INTO questions (quiz_id, question_text) VALUES (%s, %s)", (quiz_id, question_text))
        question_id = cursor.lastrowid
        cursor.executemany(
            "INSERT INTO options (question_id, option_text, is_correct) VALUES (%s, %s, %s)",
            [(question_id, option, index == correct_option) for index, option in enumerate(options, start=1)],
        )
        connection.commit()
        flash("Question added successfully.")
    except Error as error:
        flash(f"Could not add the question: {error}")
    finally:
        close_database(connection, cursor)
    return redirect(url_for("admin_dashboard"))


@app.route("/admin/questions/<int:question_id>/delete", methods=["POST"])
@role_required("admin")
def delete_question(question_id):
    connection = None
    cursor = None
    try:
        connection = get_connection()
        cursor = connection.cursor()
        cursor.execute("DELETE FROM questions WHERE id = %s", (question_id,))
        connection.commit()
        flash("Question deleted.")
    except Error as error:
        flash(f"Could not delete the question: {error}")
    finally:
        close_database(connection, cursor)
    return redirect(url_for("admin_dashboard"))


@app.route("/admin/students/<int:student_id>/toggle", methods=["POST"])
@role_required("admin")
def toggle_student(student_id):
    connection = None
    cursor = None
    try:
        connection = get_connection()
        cursor = connection.cursor()
        cursor.execute(
            """
            UPDATE users SET is_active = NOT is_active
            WHERE id = %s AND role = 'student'
            """,
            (student_id,),
        )
        connection.commit()
        flash("Student access updated.")
    except Error as error:
        flash(f"Could not update student access: {error}")
    finally:
        close_database(connection, cursor)
    return redirect(url_for("admin_dashboard"))


if __name__ == "__main__":
    create_user_table()
    app.run(debug=True)

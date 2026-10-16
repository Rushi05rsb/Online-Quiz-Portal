CREATE DATABASE IF NOT EXISTS quiz_portal
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE quiz_portal;

CREATE TABLE IF NOT EXISTS quizzes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(120) NOT NULL,
    description VARCHAR(500) NOT NULL
);

CREATE TABLE IF NOT EXISTS questions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    quiz_id INT NOT NULL,
    question_text VARCHAR(1000) NOT NULL,
    CONSTRAINT fk_questions_quiz
        FOREIGN KEY (quiz_id) REFERENCES quizzes(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS options (
    id INT AUTO_INCREMENT PRIMARY KEY,
    question_id INT NOT NULL,
    option_text VARCHAR(500) NOT NULL,
    is_correct BOOLEAN NOT NULL DEFAULT FALSE,
    CONSTRAINT fk_options_question
        FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('admin', 'student') NOT NULL DEFAULT 'student',
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS results (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    quiz_id INT NOT NULL,
    score INT NOT NULL,
    total_questions INT NOT NULL,
    taken_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_results_quiz
        FOREIGN KEY (quiz_id) REFERENCES quizzes(id) ON DELETE CASCADE
);

INSERT INTO quizzes (title, description)
SELECT 'Python Basics', 'Test your knowledge of core Python concepts.'
WHERE NOT EXISTS (SELECT 1 FROM quizzes WHERE title = 'Python Basics');

SET @quiz_id = (SELECT id FROM quizzes WHERE title = 'Python Basics' LIMIT 1);

INSERT INTO questions (quiz_id, question_text)
SELECT @quiz_id, 'Which keyword is used to define a function in Python?'
WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE quiz_id = @quiz_id
    AND question_text = 'Which keyword is used to define a function in Python?'
);
SET @q1 = (
    SELECT id FROM questions
    WHERE quiz_id = @quiz_id
    AND question_text = 'Which keyword is used to define a function in Python?'
    LIMIT 1
);
INSERT INTO options (question_id, option_text, is_correct)
SELECT @q1, 'func', FALSE WHERE NOT EXISTS (SELECT 1 FROM options WHERE question_id = @q1)
UNION ALL SELECT @q1, 'def', TRUE WHERE NOT EXISTS (SELECT 1 FROM options WHERE question_id = @q1)
UNION ALL SELECT @q1, 'function', FALSE WHERE NOT EXISTS (SELECT 1 FROM options WHERE question_id = @q1)
UNION ALL SELECT @q1, 'define', FALSE WHERE NOT EXISTS (SELECT 1 FROM options WHERE question_id = @q1);

INSERT INTO questions (quiz_id, question_text)
SELECT @quiz_id, 'Which data type stores True or False values?'
WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE quiz_id = @quiz_id
    AND question_text = 'Which data type stores True or False values?'
);
SET @q2 = (
    SELECT id FROM questions
    WHERE quiz_id = @quiz_id
    AND question_text = 'Which data type stores True or False values?'
    LIMIT 1
);
INSERT INTO options (question_id, option_text, is_correct)
SELECT @q2, 'str', FALSE WHERE NOT EXISTS (SELECT 1 FROM options WHERE question_id = @q2)
UNION ALL SELECT @q2, 'bool', TRUE WHERE NOT EXISTS (SELECT 1 FROM options WHERE question_id = @q2)
UNION ALL SELECT @q2, 'int', FALSE WHERE NOT EXISTS (SELECT 1 FROM options WHERE question_id = @q2)
UNION ALL SELECT @q2, 'list', FALSE WHERE NOT EXISTS (SELECT 1 FROM options WHERE question_id = @q2);

INSERT INTO questions (quiz_id, question_text)
SELECT @quiz_id, 'What is the output of len([10, 20, 30])?'
WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE quiz_id = @quiz_id
    AND question_text = 'What is the output of len([10, 20, 30])?'
);
SET @q3 = (
    SELECT id FROM questions
    WHERE quiz_id = @quiz_id
    AND question_text = 'What is the output of len([10, 20, 30])?'
    LIMIT 1
);
INSERT INTO options (question_id, option_text, is_correct)
SELECT @q3, '2', FALSE WHERE NOT EXISTS (SELECT 1 FROM options WHERE question_id = @q3)
UNION ALL SELECT @q3, '3', TRUE WHERE NOT EXISTS (SELECT 1 FROM options WHERE question_id = @q3)
UNION ALL SELECT @q3, '4', FALSE WHERE NOT EXISTS (SELECT 1 FROM options WHERE question_id = @q3)
UNION ALL SELECT @q3, 'Error', FALSE WHERE NOT EXISTS (SELECT 1 FROM options WHERE question_id = @q3);

INSERT INTO questions (quiz_id, question_text)
SELECT @quiz_id, 'Which symbol starts a single-line comment in Python?'
WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE quiz_id = @quiz_id
    AND question_text = 'Which symbol starts a single-line comment in Python?'
);
SET @q4 = (
    SELECT id FROM questions
    WHERE quiz_id = @quiz_id
    AND question_text = 'Which symbol starts a single-line comment in Python?'
    LIMIT 1
);
INSERT INTO options (question_id, option_text, is_correct)
SELECT @q4, '//', FALSE WHERE NOT EXISTS (SELECT 1 FROM options WHERE question_id = @q4)
UNION ALL SELECT @q4, '#', TRUE WHERE NOT EXISTS (SELECT 1 FROM options WHERE question_id = @q4)
UNION ALL SELECT @q4, '<!--', FALSE WHERE NOT EXISTS (SELECT 1 FROM options WHERE question_id = @q4)
UNION ALL SELECT @q4, '**', FALSE WHERE NOT EXISTS (SELECT 1 FROM options WHERE question_id = @q4);

INSERT INTO questions (quiz_id, question_text)
SELECT @quiz_id, 'Which collection type is ordered and changeable?'
WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE quiz_id = @quiz_id
    AND question_text = 'Which collection type is ordered and changeable?'
);
SET @q5 = (
    SELECT id FROM questions
    WHERE quiz_id = @quiz_id
    AND question_text = 'Which collection type is ordered and changeable?'
    LIMIT 1
);
INSERT INTO options (question_id, option_text, is_correct)
SELECT @q5, 'Tuple', FALSE WHERE NOT EXISTS (SELECT 1 FROM options WHERE question_id = @q5)
UNION ALL SELECT @q5, 'Set', FALSE WHERE NOT EXISTS (SELECT 1 FROM options WHERE question_id = @q5)
UNION ALL SELECT @q5, 'List', TRUE WHERE NOT EXISTS (SELECT 1 FROM options WHERE question_id = @q5)
UNION ALL SELECT @q5, 'Dictionary', FALSE WHERE NOT EXISTS (SELECT 1 FROM options WHERE question_id = @q5);

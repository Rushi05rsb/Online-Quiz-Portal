-- Adds 15 questions to the existing Python Basics quiz.
-- This script is safe to execute more than once: it will not add duplicates.

USE quiz_portal;

SET @quiz_id = (SELECT id FROM quizzes WHERE title = 'Python Basics' LIMIT 1);

INSERT INTO questions (quiz_id, question_text)
SELECT @quiz_id, 'Which function receives input from a user?'
WHERE NOT EXISTS (SELECT 1 FROM questions WHERE quiz_id = @quiz_id AND question_text = 'Which function receives input from a user?');

INSERT INTO questions (quiz_id, question_text)
SELECT @quiz_id, 'What is the result of 2 ** 3 in Python?'
WHERE NOT EXISTS (SELECT 1 FROM questions WHERE quiz_id = @quiz_id AND question_text = 'What is the result of 2 ** 3 in Python?');

INSERT INTO questions (quiz_id, question_text)
SELECT @quiz_id, 'Which operator checks whether two values are equal?'
WHERE NOT EXISTS (SELECT 1 FROM questions WHERE quiz_id = @quiz_id AND question_text = 'Which operator checks whether two values are equal?');

INSERT INTO questions (quiz_id, question_text)
SELECT @quiz_id, 'Which keyword starts a conditional statement in Python?'
WHERE NOT EXISTS (SELECT 1 FROM questions WHERE quiz_id = @quiz_id AND question_text = 'Which keyword starts a conditional statement in Python?');

INSERT INTO questions (quiz_id, question_text)
SELECT @quiz_id, 'What does print("Hi" * 3) display?'
WHERE NOT EXISTS (SELECT 1 FROM questions WHERE quiz_id = @quiz_id AND question_text = 'What does print("Hi" * 3) display?');

INSERT INTO questions (quiz_id, question_text)
SELECT @quiz_id, 'Which loop continues while its condition is true?'
WHERE NOT EXISTS (SELECT 1 FROM questions WHERE quiz_id = @quiz_id AND question_text = 'Which loop continues while its condition is true?');

INSERT INTO questions (quiz_id, question_text)
SELECT @quiz_id, 'What does the break statement do inside a loop?'
WHERE NOT EXISTS (SELECT 1 FROM questions WHERE quiz_id = @quiz_id AND question_text = 'What does the break statement do inside a loop?');

INSERT INTO questions (quiz_id, question_text)
SELECT @quiz_id, 'What does continue do inside a loop?'
WHERE NOT EXISTS (SELECT 1 FROM questions WHERE quiz_id = @quiz_id AND question_text = 'What does continue do inside a loop?');

INSERT INTO questions (quiz_id, question_text)
SELECT @quiz_id, 'Which Python collection stores key-value pairs?'
WHERE NOT EXISTS (SELECT 1 FROM questions WHERE quiz_id = @quiz_id AND question_text = 'Which Python collection stores key-value pairs?');

INSERT INTO questions (quiz_id, question_text)
SELECT @quiz_id, 'What does type(10) return?'
WHERE NOT EXISTS (SELECT 1 FROM questions WHERE quiz_id = @quiz_id AND question_text = 'What does type(10) return?');

INSERT INTO questions (quiz_id, question_text)
SELECT @quiz_id, 'Which function converts a value to an integer?'
WHERE NOT EXISTS (SELECT 1 FROM questions WHERE quiz_id = @quiz_id AND question_text = 'Which function converts a value to an integer?');

INSERT INTO questions (quiz_id, question_text)
SELECT @quiz_id, 'Which list method adds an item at the end of a list?'
WHERE NOT EXISTS (SELECT 1 FROM questions WHERE quiz_id = @quiz_id AND question_text = 'Which list method adds an item at the end of a list?');

INSERT INTO questions (quiz_id, question_text)
SELECT @quiz_id, 'Which statement is used to handle errors in Python?'
WHERE NOT EXISTS (SELECT 1 FROM questions WHERE quiz_id = @quiz_id AND question_text = 'Which statement is used to handle errors in Python?');

INSERT INTO questions (quiz_id, question_text)
SELECT @quiz_id, 'What is the result of 10 // 3?'
WHERE NOT EXISTS (SELECT 1 FROM questions WHERE quiz_id = @quiz_id AND question_text = 'What is the result of 10 // 3?');

INSERT INTO questions (quiz_id, question_text)
SELECT @quiz_id, 'Which keyword imports a module in Python?'
WHERE NOT EXISTS (SELECT 1 FROM questions WHERE quiz_id = @quiz_id AND question_text = 'Which keyword imports a module in Python?');

INSERT INTO options (question_id, option_text, is_correct)
SELECT question_id, option_text, is_correct
FROM (
    SELECT id AS question_id, 'read()' AS option_text, FALSE AS is_correct FROM questions WHERE quiz_id = @quiz_id AND question_text = 'Which function receives input from a user?'
    UNION ALL SELECT id, 'input()', TRUE FROM questions WHERE quiz_id = @quiz_id AND question_text = 'Which function receives input from a user?'
    UNION ALL SELECT id, 'get()', FALSE FROM questions WHERE quiz_id = @quiz_id AND question_text = 'Which function receives input from a user?'
    UNION ALL SELECT id, 'scan()', FALSE FROM questions WHERE quiz_id = @quiz_id AND question_text = 'Which function receives input from a user?'

    UNION ALL SELECT id, '5', FALSE FROM questions WHERE quiz_id = @quiz_id AND question_text = 'What is the result of 2 ** 3 in Python?'
    UNION ALL SELECT id, '6', FALSE FROM questions WHERE quiz_id = @quiz_id AND question_text = 'What is the result of 2 ** 3 in Python?'
    UNION ALL SELECT id, '8', TRUE FROM questions WHERE quiz_id = @quiz_id AND question_text = 'What is the result of 2 ** 3 in Python?'
    UNION ALL SELECT id, '9', FALSE FROM questions WHERE quiz_id = @quiz_id AND question_text = 'What is the result of 2 ** 3 in Python?'

    UNION ALL SELECT id, '=', FALSE FROM questions WHERE quiz_id = @quiz_id AND question_text = 'Which operator checks whether two values are equal?'
    UNION ALL SELECT id, '==', TRUE FROM questions WHERE quiz_id = @quiz_id AND question_text = 'Which operator checks whether two values are equal?'
    UNION ALL SELECT id, '!=', FALSE FROM questions WHERE quiz_id = @quiz_id AND question_text = 'Which operator checks whether two values are equal?'
    UNION ALL SELECT id, '>=', FALSE FROM questions WHERE quiz_id = @quiz_id AND question_text = 'Which operator checks whether two values are equal?'

    UNION ALL SELECT id, 'check', FALSE FROM questions WHERE quiz_id = @quiz_id AND question_text = 'Which keyword starts a conditional statement in Python?'
    UNION ALL SELECT id, 'when', FALSE FROM questions WHERE quiz_id = @quiz_id AND question_text = 'Which keyword starts a conditional statement in Python?'
    UNION ALL SELECT id, 'if', TRUE FROM questions WHERE quiz_id = @quiz_id AND question_text = 'Which keyword starts a conditional statement in Python?'
    UNION ALL SELECT id, 'condition', FALSE FROM questions WHERE quiz_id = @quiz_id AND question_text = 'Which keyword starts a conditional statement in Python?'

    UNION ALL SELECT id, 'Hi3', FALSE FROM questions WHERE quiz_id = @quiz_id AND question_text = 'What does print("Hi" * 3) display?'
    UNION ALL SELECT id, 'Hi Hi Hi', FALSE FROM questions WHERE quiz_id = @quiz_id AND question_text = 'What does print("Hi" * 3) display?'
    UNION ALL SELECT id, 'HiHiHi', TRUE FROM questions WHERE quiz_id = @quiz_id AND question_text = 'What does print("Hi" * 3) display?'
    UNION ALL SELECT id, 'Error', FALSE FROM questions WHERE quiz_id = @quiz_id AND question_text = 'What does print("Hi" * 3) display?'

    UNION ALL SELECT id, 'for', FALSE FROM questions WHERE quiz_id = @quiz_id AND question_text = 'Which loop continues while its condition is true?'
    UNION ALL SELECT id, 'while', TRUE FROM questions WHERE quiz_id = @quiz_id AND question_text = 'Which loop continues while its condition is true?'
    UNION ALL SELECT id, 'repeat', FALSE FROM questions WHERE quiz_id = @quiz_id AND question_text = 'Which loop continues while its condition is true?'
    UNION ALL SELECT id, 'loop', FALSE FROM questions WHERE quiz_id = @quiz_id AND question_text = 'Which loop continues while its condition is true?'

    UNION ALL SELECT id, 'Skips one iteration', FALSE FROM questions WHERE quiz_id = @quiz_id AND question_text = 'What does the break statement do inside a loop?'
    UNION ALL SELECT id, 'Stops the loop', TRUE FROM questions WHERE quiz_id = @quiz_id AND question_text = 'What does the break statement do inside a loop?'
    UNION ALL SELECT id, 'Restarts the loop', FALSE FROM questions WHERE quiz_id = @quiz_id AND question_text = 'What does the break statement do inside a loop?'
    UNION ALL SELECT id, 'Prints the loop', FALSE FROM questions WHERE quiz_id = @quiz_id AND question_text = 'What does the break statement do inside a loop?'

    UNION ALL SELECT id, 'Stops the program', FALSE FROM questions WHERE quiz_id = @quiz_id AND question_text = 'What does continue do inside a loop?'
    UNION ALL SELECT id, 'Ends the loop', FALSE FROM questions WHERE quiz_id = @quiz_id AND question_text = 'What does continue do inside a loop?'
    UNION ALL SELECT id, 'Skips the current iteration', TRUE FROM questions WHERE quiz_id = @quiz_id AND question_text = 'What does continue do inside a loop?'
    UNION ALL SELECT id, 'Repeats the current iteration', FALSE FROM questions WHERE quiz_id = @quiz_id AND question_text = 'What does continue do inside a loop?'

    UNION ALL SELECT id, 'List', FALSE FROM questions WHERE quiz_id = @quiz_id AND question_text = 'Which Python collection stores key-value pairs?'
    UNION ALL SELECT id, 'Tuple', FALSE FROM questions WHERE quiz_id = @quiz_id AND question_text = 'Which Python collection stores key-value pairs?'
    UNION ALL SELECT id, 'Dictionary', TRUE FROM questions WHERE quiz_id = @quiz_id AND question_text = 'Which Python collection stores key-value pairs?'
    UNION ALL SELECT id, 'Set', FALSE FROM questions WHERE quiz_id = @quiz_id AND question_text = 'Which Python collection stores key-value pairs?'

    UNION ALL SELECT id, '<class ''str''>', FALSE FROM questions WHERE quiz_id = @quiz_id AND question_text = 'What does type(10) return?'
    UNION ALL SELECT id, '<class ''int''>', TRUE FROM questions WHERE quiz_id = @quiz_id AND question_text = 'What does type(10) return?'
    UNION ALL SELECT id, '<class ''float''>', FALSE FROM questions WHERE quiz_id = @quiz_id AND question_text = 'What does type(10) return?'
    UNION ALL SELECT id, '<class ''bool''>', FALSE FROM questions WHERE quiz_id = @quiz_id AND question_text = 'What does type(10) return?'

    UNION ALL SELECT id, 'str()', FALSE FROM questions WHERE quiz_id = @quiz_id AND question_text = 'Which function converts a value to an integer?'
    UNION ALL SELECT id, 'float()', FALSE FROM questions WHERE quiz_id = @quiz_id AND question_text = 'Which function converts a value to an integer?'
    UNION ALL SELECT id, 'int()', TRUE FROM questions WHERE quiz_id = @quiz_id AND question_text = 'Which function converts a value to an integer?'
    UNION ALL SELECT id, 'bool()', FALSE FROM questions WHERE quiz_id = @quiz_id AND question_text = 'Which function converts a value to an integer?'

    UNION ALL SELECT id, 'add()', FALSE FROM questions WHERE quiz_id = @quiz_id AND question_text = 'Which list method adds an item at the end of a list?'
    UNION ALL SELECT id, 'append()', TRUE FROM questions WHERE quiz_id = @quiz_id AND question_text = 'Which list method adds an item at the end of a list?'
    UNION ALL SELECT id, 'insert()', FALSE FROM questions WHERE quiz_id = @quiz_id AND question_text = 'Which list method adds an item at the end of a list?'
    UNION ALL SELECT id, 'push()', FALSE FROM questions WHERE quiz_id = @quiz_id AND question_text = 'Which list method adds an item at the end of a list?'

    UNION ALL SELECT id, 'try-except', TRUE FROM questions WHERE quiz_id = @quiz_id AND question_text = 'Which statement is used to handle errors in Python?'
    UNION ALL SELECT id, 'if-else', FALSE FROM questions WHERE quiz_id = @quiz_id AND question_text = 'Which statement is used to handle errors in Python?'
    UNION ALL SELECT id, 'for-while', FALSE FROM questions WHERE quiz_id = @quiz_id AND question_text = 'Which statement is used to handle errors in Python?'
    UNION ALL SELECT id, 'break-continue', FALSE FROM questions WHERE quiz_id = @quiz_id AND question_text = 'Which statement is used to handle errors in Python?'

    UNION ALL SELECT id, '3', TRUE FROM questions WHERE quiz_id = @quiz_id AND question_text = 'What is the result of 10 // 3?'
    UNION ALL SELECT id, '3.33', FALSE FROM questions WHERE quiz_id = @quiz_id AND question_text = 'What is the result of 10 // 3?'
    UNION ALL SELECT id, '4', FALSE FROM questions WHERE quiz_id = @quiz_id AND question_text = 'What is the result of 10 // 3?'
    UNION ALL SELECT id, 'Error', FALSE FROM questions WHERE quiz_id = @quiz_id AND question_text = 'What is the result of 10 // 3?'

    UNION ALL SELECT id, 'include', FALSE FROM questions WHERE quiz_id = @quiz_id AND question_text = 'Which keyword imports a module in Python?'
    UNION ALL SELECT id, 'using', FALSE FROM questions WHERE quiz_id = @quiz_id AND question_text = 'Which keyword imports a module in Python?'
    UNION ALL SELECT id, 'import', TRUE FROM questions WHERE quiz_id = @quiz_id AND question_text = 'Which keyword imports a module in Python?'
    UNION ALL SELECT id, 'require', FALSE FROM questions WHERE quiz_id = @quiz_id AND question_text = 'Which keyword imports a module in Python?'
) AS new_options
WHERE NOT EXISTS (
    SELECT 1
    FROM options AS existing_options
    WHERE existing_options.question_id = new_options.question_id
);

SELECT COUNT(*) AS total_questions
FROM questions
WHERE quiz_id = @quiz_id;

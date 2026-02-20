/* 16-11-2024*/
const express = require('express');
const mysql = require('mysql2');
const bcrypt = require('bcrypt');
const cors = require('cors');
const bodyParser = require('body-parser');
const path = require('path');
const fs = require('fs');

const app = express();
const port = 3000;

// Connect to MySQL database
const connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: 'KuNj22@#',
  database: 'scholarship'
});

// Connect to the database
connection.connect((err) => {
  if (err) {
    console.error('Error connecting to database:', err);
    return;
  }
  console.log('Connected to your MySQL database!');
});

// Middleware
app.use(cors());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

// Serve static files (HTML, CSS, JS)
app.use(express.static(path.join(__dirname, '')));

// Registration route
app.post('/register', (req, res) => {
  const { full_name, username, email, phone, password, gender } = req.body;

  // Hash the password
  bcrypt.hash(password, 10, (err, hash) => {
    if (err) {
      console.error(err);
      return res.status(500).send('Error registering user');
    }

    // Insert the user into the students table
    connection.query(
      'INSERT INTO students (full_name, username, email, phone, password, gender) VALUES (?, ?, ?, ?, ?, ?)',
      [full_name, username, email, phone, hash, gender],
      (err, result) => {
        if (err) {
          console.error(err);
          return res.status(500).send('Error registering user');
        }
        fs.readFile('login.html', 'utf8', (err, data) => {
          if (err) {
            console.error(err);
            return res.status(500).send('Error reading login page');
          }
          res.send(data.replace('{{ message }}', 'Registration successful! Please log in.'));
        });
      }
    );
  });
});

// Login route  old code 
app.post('/login', (req, res) => {
  const { username, password } = req.body;

  // Check if the user exists in the students table
  connection.query(
    'SELECT * FROM students WHERE username = ?',
    [username],
    (err, results) => {
      if (err) {
        console.error(err);
        return res.status(500).send('Error logging in');
      }

      if (results.length === 0) {
        fs.readFile('login.html', 'utf8', (err, data) => {
          if (err) {
            console.error(err);
            return res.status(500).send('Error reading login page');
          }
          res.send(data.replace('{{ message }}', 'Invalid username or password'));
        });
        return;
      }

      // Compare the password
      bcrypt.compare(password, results[0].password, (err, match) => {
        if (err) {
          console.error(err);
          return res.status(500).send('Error logging in');
        }

        if (!match) {
          fs.readFile('login.html', 'utf8', (err, data) => {
            if (err) {
              console.error(err);
              return res.status(500).send('Error reading login page');
            }
            res.send(data.replace('{{ message }}', 'Invalid username or password'));
          });
          return;
        }

        // Insert the user into the users table
        connection.query(
          'INSERT INTO users (username, password, email, user_type) VALUES (?, ?, ?, ?)',
          [username, results[0].password, results[0].email, 'student'],
          (err, result) => {
            if (err) {
              console.error(err);
              return res.status(500).send('Error logging in');
            }
            fs.readFile('index.html', 'utf8', (err, data) => {
              if (err) {
                console.error(err);
                return res.status(500).send('Error reading index page');
              }
              res.send(data.replace('{{ message }}', 'Login successful!'));
            });
          }
        );
      });
    }
  );
});

app.post('/apply-scholarship', (req, res) => {
  // Check if user is logged in (you might want to implement proper session management)
  const { 
    scholarship_type, 
    academic_year, 
    semester, 
    cgpa, 
    family_income, 
    amount_requested 
  } = req.body;

  // Get student_id from the users table based on the logged-in user
  connection.query(
    'SELECT id FROM students WHERE username = ?',
    [req.body.username], // You'll need to pass the username from the client
    (err, results) => {
      if (err) {
        console.error(err);
        return res.status(500).send('Error processing application');
      }

      if (results.length === 0) {
        return res.status(401).send('User not found');
      }

      const student_id = results[0].id;

      // Insert the scholarship application
      connection.query(
        `INSERT INTO scholarship_applications 
        (student_id, scholarship_type, academic_year, semester, cgpa, family_income, amount_requested) 
        VALUES (?, ?, ?, ?, ?, ?, ?)`,
        [student_id, scholarship_type, academic_year, semester, cgpa, family_income, amount_requested],
        (err, result) => {
          if (err) {
            console.error(err);
            return res.status(500).send('Error submitting application');
          }

          // Create initial status entry
          connection.query(
            `INSERT INTO application_status 
            (application_id, previous_status, current_status, remarks) 
            VALUES (?, 'pending', 'pending', 'Application submitted')`,
            [result.insertId],
            (err) => {
              if (err) {
                console.error(err);
                return res.status(500).send('Error updating application status');
              }
              res.status(200).send('Application submitted successfully');
            }
          );
        }
      );
    }
  );
});

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
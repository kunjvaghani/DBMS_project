# Scholarship Management System

A comprehensive web-based application for managing scholarship applications, built with Node.js, Express, MySQL, and vanilla JavaScript.

## 📋 Table of Contents

- [Features](#features)
- [Technology Stack](#technology-stack)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Database Setup](#database-setup)
- [Configuration](#configuration)
- [Usage](#usage)
- [API Endpoints](#api-endpoints)
- [Database Schema](#database-schema)
- [Project Structure](#project-structure)
- [Contributing](#contributing)
- [License](#license)

## ✨ Features

- **User Registration & Authentication**: Secure user registration with password hashing
- **Scholarship Application**: Comprehensive application form for various scholarship types
- **Application Tracking**: Real-time status updates and application history
- **Admin Dashboard**: Overview of all applications and their statuses
- **Document Management**: Support for uploading required documents
- **Responsive Design**: Mobile-friendly user interface
- **Secure Password Storage**: bcrypt hashing for user passwords

### Scholarship Types Supported:
- Merit-based scholarships
- Need-based scholarships
- Sports scholarships
- Cultural scholarships
- Research scholarships

## 🛠 Technology Stack

### Backend
- **Node.js** - Runtime environment
- **Express.js** - Web framework
- **MySQL2** - Database driver
- **bcrypt** - Password hashing
- **CORS** - Cross-origin resource sharing
- **Body-parser** - Request body parsing

### Frontend
- **HTML5** - Markup
- **CSS3** - Styling
- **Vanilla JavaScript** - Client-side logic
- **Fetch API** - HTTP requests

### Database
- **MySQL** - Relational database

## 📋 Prerequisites

Before running this application, make sure you have the following installed:

- Node.js (v14 or higher)
- MySQL Server
- npm or yarn package manager

## 🚀 Installation

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd scholarship-management-system
   ```

2. **Install dependencies:**
   ```bash
   npm install
   ```

3. **Set up the database:**
   - Create a MySQL database named `scholarship`
   - Run the SQL script in `data.sql` to create tables and initial data

4. **Configure database connection:**
   - Update the database credentials in `server.js` (lines 15-20)

## 🗄 Database Setup

1. **Create the database:**
   ```sql
   CREATE DATABASE scholarship;
   ```

2. **Run the schema:**
   ```bash
   mysql -u root -p scholarship < data.sql
   ```

The database includes the following tables:
- `students` - User registration data
- `users` - Authentication data
- `scholarship_applications` - Application details
- `application_status` - Status tracking
- `application_documents` - Document uploads

## ⚙ Configuration

Update the database configuration in `server.js`:

```javascript
const connection = mysql.createConnection({
  host: 'localhost',
  user: 'your-username',
  password: 'your-password',
  database: 'scholarship'
});
```

## 🎯 Usage

1. **Start the server:**
   ```bash
   node server.js
   ```

2. **Access the application:**
   - Open your browser and navigate to `http://localhost:3000`
   - Register a new account or login with existing credentials
   - Apply for scholarships through the application form

## 📡 API Endpoints

### Authentication
- `POST /register` - User registration
- `POST /login` - User login

### Applications
- `POST /apply-scholarship` - Submit scholarship application

### Static Files
- All HTML, CSS, and client-side JavaScript files are served statically

## 🏗 Project Structure

```
scholarship-management-system/
├── server.js              # Main server file
├── data.sql               # Database schema and sample data
├── package.json           # Dependencies and scripts
├── .gitignore            # Git ignore rules
├── index.html            # Home page
├── register.html         # Registration page
├── login.html            # Login page
├── apply.html            # Scholarship application form
├── style.css             # Main stylesheet
├── apply.css             # Application form styles
├── er.mwb                # ER diagram (MySQL Workbench)
└── dbms_project_er-diagram.png  # ER diagram image
```

## 🗂 Database Schema

### Core Tables

**students**
- User registration information
- Personal details and contact information

**users**
- Authentication credentials
- User roles (student/admin)

**scholarship_applications**
- Application details
- Academic and financial information

**application_status**
- Status tracking history
- Admin remarks and updates

**application_documents**
- File upload tracking
- Document type classification

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 📞 Support

For support or questions, please open an issue in the GitHub repository.

---

**Note:** This is a educational project demonstrating full-stack web development with Node.js, Express, and MySQL. For production use, additional security measures and optimizations would be required.</content>
<parameter name="filePath">e:\all about web-dev\new claude project dbms\README.md
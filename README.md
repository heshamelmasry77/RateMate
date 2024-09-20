
# RateMate Backend

RateMate is a Ruby on Rails API application that allows users to convert currency amounts based on the latest exchange rates.

## Features

- **User Registration**: Users can register with a username, email, and password.
- **User Login**: Registered users can log in to receive a JWT for authenticated requests.
- **JWT Authentication**: Secure authentication using JWT, with tokens expiring after 45 minutes.
- **Password Security**: Passwords are hashed using bcrypt for security.
- **API Namespace**: All routes are under the `/api/v1` namespace for versioning.
- **CORS Enabled**: Configured to allow requests from different origins (e.g., a frontend application).

## Technologies Used

- **Ruby** 3.2.5
- **Rails** 7.2.1
- **MySQL** 8.0
- **bcrypt**
- **jwt**
- **rack-cors**

## Getting Started

### Prerequisites

Ensure you have the following installed:

- **Ruby**: Version 3.2.5
- **Rails**: Version 7.2.1
- **MySQL**: Version 8.0 or higher

### Installation

1. **Clone the Repository**

   ```bash
   git clone https://github.com/heshamelmasry77/RateMate.git
   cd RateMate
   ```

2. **Install the required gems using Bundler**

   ```bash
   bundle install
   ```

3. **Configure Database**

   Update the `config/database.yml` file with your MySQL credentials:

   ```yaml
   default: &default
     adapter: mysql2
     encoding: utf8
     pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
     username: your_mysql_username
     password: your_mysql_password
     host: localhost

   development:
     <<: *default
     database: ratemate_development

   test:
     <<: *default
     database: ratemate_test

   production:
     <<: *default
     database: ratemate_production
     username: <%= ENV['MYSQL_USERNAME'] %>
     password: <%= ENV['MYSQL_PASSWORD'] %>
   ```

4. **Run Database Migrations**

   Create the database and run migrations:

   ```bash
   rails db:create
   rails db:migrate
   ```

5. **Start the Server**

   ```bash
   rails server
   ```

   The application should now be running at `http://localhost:3000`.

## API Endpoints

### **User Registration**

- **URL**: `POST /api/v1/users`
- **Description**: Registers a new user.

#### Request Headers:

- `Content-Type: application/json`

#### Request Body:

```json
{
  "user": {
    "username": "your_username",
    "email": "your_email@example.com",
    "password": "your_password"
  }
}
```

#### Response:

- **Status**: `201 Created`
- **Body**:

```json
{
  "user": {
    "id": 1,
    "username": "your_username",
    "email": "your_email@example.com"
  },
  "jwt": "your_jwt_token"
}
```

### **User Login**

- **URL**: `POST /api/v1/login`
- **Description**: Authenticates a user and returns a JWT.

#### Request Headers:

- `Content-Type: application/json`

#### Request Body:

```json
{
  "email": "your_email@example.com",
  "password": "your_password"
}
```

#### Response:

- **Status**: `202 Accepted`
- **Body**:

```json
{
  "user": {
    "id": 1,
    "username": "your_username",
    "email": "your_email@example.com"
  },
  "jwt": "your_jwt_token"
}
```


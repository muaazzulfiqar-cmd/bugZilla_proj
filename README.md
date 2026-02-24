# Bugzilla - Bug Tracking System

## 📋 Overview

Bugzilla is a comprehensive bug tracking and management system built with Ruby on Rails. It enables software teams to report, assign, and monitor bugs across multiple projects with role-based access control.

## ✨ Features

### User Management
- **Authentication**: Secure signup/login with Devise
- **Global Roles**: 
  - `Admin`: System-wide access to all projects and bugs
  - `Employee`: Regular users with project-specific roles
- **Project Roles** (per project):
  - `Manager`: Full project control, team management
  - `Developer`: Can fix assigned bugs and assign bugs to others
  - `QA`: Can create bugs and test assigned bugs

### Project Management
- Create and manage multiple projects
- Add/remove team members with specific roles
- View project details and statistics

### Bug Tracking
- Report bugs with title, description, priority, and status
- Assign bugs to team members
- Track bug status (open, in_progress, resolved, closed)
- Set priority levels (low, medium, high)
- Attach screenshots to bugs
- View bug history and details

### Dashboard
- Overview of your projects
- List of bugs assigned to you
- Quick statistics (open/resolved bugs)
- Role-based views and actions

### Email Notifications
- Login notifications
- Bug assignment alerts
- Status change updates
- Bug deletion notifications

## 🚀 Installation

### Prerequisites
- Ruby 3.4.6
- Rails 8.1.2
- PostgreSQL
- Git

### Setup Instructions

1. **Clone the repository**
```bash
git clone https://github.com/muaaz.zulfiqar-cmd/bugzilla.git
cd bugzilla
```

2. **Install dependencies**
```bash
bundle install
```

3. **Database setup**
```bash
# Create and setup database
rails db:create
rails db:migrate

# Optional: Seed with sample data
rails db:seed
```

4. **Configure email (optional)**
Edit `config/environments/development.rb` with your SMTP settings:
```ruby
config.action_mailer.smtp_settings = {
  address: 'smtp.gmail.com',
  port: 587,
  domain: 'localhost:3000',
  user_name: 'your-email@gmail.com',
  password: 'your-app-password',
  authentication: 'plain',
  enable_starttls_auto: true
}
```

5. **Start the server**
```bash
rails server
```

6. **Access the application**
Open your browser and navigate to: `http://localhost:3000`

## 📝 Usage Guide

### Sign Up
1. Click "Sign up" on the login page
2. Choose your account type:
   - **Admin** (password: `admin123`): Full system access
   - **Employee** (password: `employee123`): Standard user
3. Fill in your email and password
4. Click "Sign up"

### Creating a Project
1. From the dashboard, click "Create Project"
2. Enter project name and description
3. You'll automatically become the project manager

### Adding Team Members
1. Go to your project page
2. Click "Manage Team"
3. Select a user and assign their role (Manager/Developer/QA)
4. Click "Add to Project"

### Reporting a Bug
1. Navigate to a project
2. Click "Report Bug"
3. Fill in bug details:
   - Title
   - Description
   - Status
   - Priority
   - Assignee (optional)
   - Screenshots (optional)
4. Click "Create Bug"

### Managing Bugs
- **View all bugs**: Click "View All Bugs" on project page
- **Filter bugs**: Use the filter form by status, priority, or assignee
- **Edit bug**: Click "Edit" on bug details page
- **Change status**: Update bug progress (open → in_progress → resolved)
- **Assign/Reassign**: Change the assignee as needed

### Dashboard
Your dashboard shows:
- Projects you're a member of (with your role)
- Bugs assigned to you
- Overall statistics

## 👥 Role Permissions

### Admin (Global)
- View/edit/delete any project
- Manage team members of any project
- View/edit/delete any bug
- Full system access

### Employee (Global)
- Project-specific roles apply

### Project Manager
- Full control over assigned projects
- Add/remove team members
- Edit/delete any bug in the project
- Assign bugs to anyone

### Developer
- View all bugs in assigned projects
- Fix bugs assigned to them
- Assign bugs to others
- Cannot create new bugs

### QA
- View all bugs in assigned projects
- Create new bugs
- Test and resolve bugs assigned to them
- Cannot assign bugs to others

## 🗄️ Database Schema

### Users
- `email`: string
- `global_role`: integer (0: employee, 1: admin)
- Devise authentication fields

### Projects
- `name`: string
- `description`: text
- `creator_id`: references users

### Project Memberships (Join table)
- `user_id`: references users
- `project_id`: references projects
- `role`: integer (0: manager, 1: developer, 2: qa)

### Bugs
- `title`: string
- `description`: text
- `status`: integer (0: open, 1: in_progress, 2: resolved, 3: closed)
- `priority`: integer (0: low, 1: medium, 2: high)
- `project_id`: references projects
- `reporter_id`: references users
- `assignee_id`: references users (optional)
- Active Storage attachments for screenshots

## 🔧 Configuration

### Environment Variables
Create a `.env` file for sensitive data:
```
GMAIL_USERNAME=your-email@gmail.com
GMAIL_APP_PASSWORD=your-app-password
```

### Email Configuration
For production, update `config/environments/production.rb` with your email settings.

## 🧪 Testing

Run the test suite:
```bash
rails test
```

## 📚 API Endpoints (Optional)

The application follows RESTful conventions:

| Resource | Endpoint | Purpose |
|----------|----------|---------|
| Projects | `/projects` | List/create projects |
| Project | `/projects/:id` | View/update/delete project |
| Bugs | `/projects/:project_id/bugs` | List/create bugs in project |
| Bug | `/projects/:project_id/bugs/:id` | View/update/delete bug |
| Team | `/projects/:project_id/project_memberships` | Manage team members |
| All Bugs | `/bugs` | Global bugs view (admin) |

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License.

## 📞 Support

For issues or questions:
- Check existing GitHub issues
- Create a new issue with detailed description
- Contact the development team

## 🙏 Acknowledgments

- Ruby on Rails community
- Devise for authentication
- Pundit for authorization
- Tailwind CSS for styling
- All contributors and testers


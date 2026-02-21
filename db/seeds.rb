# db/seeds.rb

# Clear existing data (optional - be careful in production!)
puts "Cleaning database..."
ProjectMembership.destroy_all
Bug.destroy_all
Project.destroy_all
User.destroy_all

puts "Creating users..."

# Create users with different emails
users = [
  { email: "manager@example.com", password: "password123", name: "Manager User" },
  { email: "developer@example.com", password: "password123", name: "Developer User" },
  { email: "qa@example.com", password: "password123", name: "QA User" },
  { email: "developer2@example.com", password: "password123", name: "Developer 2" },
  { email: "qa2@example.com", password: "password123", name: "QA 2" },
  { email: "manager2@example.com", password: "password123", name: "Manager 2" }
]

created_users = users.map do |user_attrs|
  User.create!(
    email: user_attrs[:email],
    password: user_attrs[:password],
    password_confirmation: user_attrs[:password]
  )
end

manager = created_users[0]
developer = created_users[1]
qa = created_users[2]
developer2 = created_users[3]
qa2 = created_users[4]
manager2 = created_users[5]

puts "Creating projects..."

# Project 1: E-commerce App (managed by manager@example.com)
project1 = Project.create!(
  name: "E-commerce Mobile App",
  description: "iOS and Android e-commerce application with payment integration",
  creator: manager
)

# Add members to Project 1
ProjectMembership.create!([
  { user: manager, project: project1, role: :manager },
  { user: developer, project: project1, role: :developer },
  { user: qa, project: project1, role: :qa },
  { user: developer2, project: project1, role: :developer }
])

# Project 2: Admin Dashboard (managed by manager2@example.com)
project2 = Project.create!(
  name: "Admin Dashboard",
  description: "Internal admin panel for managing users and analytics",
  creator: manager2
)

ProjectMembership.create!([
  { user: manager2, project: project2, role: :manager },
  { user: developer2, project: project2, role: :developer },
  { user: qa2, project: project2, role: :qa }
])

# Project 3: API Service (mixed team)
project3 = Project.create!(
  name: "Payment API Service",
  description: "RESTful API for payment processing with Stripe integration",
  creator: manager
)

ProjectMembership.create!([
  { user: manager, project: project3, role: :manager },
  { user: developer, project: project3, role: :developer },
  { user: qa, project: project3, role: :qa },
  { user: developer2, project: project3, role: :developer },
  { user: qa2, project: project3, role: :qa }
])

puts "Creating bugs..."

# Bugs for Project 1 (E-commerce App)
bugs_project1 = [
  {
    title: "Payment not processing with PayPal",
    description: "When users try to pay with PayPal, they get a 500 error after authentication",
    status: :open,
    priority: :high,
    reporter: qa,
    assignee: developer,
    project: project1
  },
  {
    title: "App crashes on checkout",
    description: "App crashes when user has more than 5 items in cart during checkout",
    status: :in_progress,
    priority: :high,
    reporter: qa,
    assignee: developer,
    project: project1
  },
  {
    title: "Login button not responsive on iPhone SE",
    description: "Login button is too small and doesn't register taps on iPhone SE",
    status: :open,
    priority: :medium,
    reporter: qa2,
    assignee: developer2,
    project: project1
  },
  {
    title: "Product images not loading",
    description: "Product images take too long to load on slow connections",
    status: :resolved,
    priority: :medium,
    reporter: qa,
    assignee: developer,
    project: project1
  },
  {
    title: "Search returns incorrect results",
    description: "Search by category returns products from wrong categories",
    status: :closed,
    priority: :low,
    reporter: qa,
    assignee: developer2,
    project: project1
  },
  {
    title: "Memory leak in image upload",
    description: "Memory usage keeps increasing when uploading multiple images",
    status: :open,
    priority: :high,
    reporter: qa,
    assignee: developer,  # Assigned instead of nil
    project: project1
  },
  {
    title: "Add dark mode support",
    description: "Feature request: implement dark mode throughout the app",
    status: :open,
    priority: :low,
    reporter: developer,
    assignee: developer2,  # Assigned instead of nil
    project: project1
  }
]

# Bugs for Project 2 (Admin Dashboard)
bugs_project2 = [
  {
    title: "User export feature missing",
    description: "Cannot export user list to CSV, button does nothing",
    status: :open,
    priority: :medium,
    reporter: qa2,
    assignee: developer2,
    project: project2
  },
  {
    title: "Dashboard charts not updating",
    description: "Real-time charts freeze after 5 minutes",
    status: :in_progress,
    priority: :high,
    reporter: qa2,
    assignee: developer2,
    project: project2
  }
]

# Bugs for Project 3 (API Service)
bugs_project3 = [
  {
    title: "Rate limiting too aggressive",
    description: "API returns 429 even when under limit",
    status: :open,
    priority: :high,
    reporter: qa,
    assignee: developer,
    project: project3
  },
  {
    title: "Webhook signature verification fails",
    description: "Stripe webhook signatures not verifying properly",
    status: :in_progress,
    priority: :high,
    reporter: qa2,
    assignee: developer,
    project: project3
  },
  {
    title: "Documentation has wrong endpoint",
    description: "POST /api/v1/payments should be /api/v1/charges",
    status: :open,
    priority: :low,
    reporter: qa,
    assignee: developer2,
    project: project3
  },
  {
    title: "Timeout on large requests",
    description: "Requests with many items timeout after 30 seconds",
    status: :resolved,
    priority: :medium,
    reporter: qa,
    assignee: developer,
    project: project3
  }
]

# Create all bugs
(bugs_project1 + bugs_project2 + bugs_project3).each do |bug_attrs|
  Bug.create!(bug_attrs)
end

puts "\n✅ Seed data created successfully!"
puts "=" * 50
puts "Login Credentials:"
puts "=" * 50
puts "Manager:     manager@example.com / password123"
puts "Developer:   developer@example.com / password123"
puts "QA:          qa@example.com / password123"
puts "Developer 2: developer2@example.com / password123"
puts "QA 2:        qa2@example.com / password123"
puts "Manager 2:   manager2@example.com / password123"
puts "=" * 50
puts "\nProject Summary:"
puts "- E-commerce App (Manager: manager@example.com)"
puts "- Admin Dashboard (Manager: manager2@example.com)"
puts "- Payment API Service (Manager: manager@example.com)"
puts "\nTotal Users: #{User.count}"
puts "Total Projects: #{Project.count}"
puts "Total Memberships: #{ProjectMembership.count}"
puts "Total Bugs: #{Bug.count}"
puts "  - Open: #{Bug.open.count}"
puts "  - In Progress: #{Bug.in_progress.count}"
puts "  - Resolved: #{Bug.resolved.count}"
puts "  - Closed: #{Bug.closed.count}"
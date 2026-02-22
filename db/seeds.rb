# db/seeds.rb

# Clear existing data
puts "🧹 Cleaning database..."
ProjectMembership.destroy_all
Bug.destroy_all
Project.destroy_all
User.destroy_all

puts "👥 Creating users..."

# Create 15 users with different roles
roles = [:manager, :developer, :qa]
users = []

15.times do |i|
  role = roles.sample
  user = User.create!(
    email: "user#{i+1}@example.com",
    password: "password123",
    password_confirmation: "password123"
  )
  users << { user: user, role: role }
  puts "  Created #{user.email} as #{role}"
end

# Create 3 managers specifically for project creation
managers = users.select { |u| u[:role] == :manager }.map { |u| u[:user] }
if managers.empty?
  # Ensure at least 2 managers exist
  2.times do |i|
    user = User.create!(
      email: "manager#{i+1}@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    users << { user: user, role: :manager }
    managers << user
    puts "  Created #{user.email} as manager"
  end
end

puts "📊 Creating 20 projects..."

# Project names and descriptions for variety
project_names = [
  "E-commerce Platform", "Mobile Banking App", "Inventory Management System",
  "Customer Relationship Manager", "Healthcare Portal", "Learning Management System",
  "Food Delivery App", "Hotel Booking System", "Fitness Tracker App",
  "Real Estate Marketplace", "Ticket Management System", "Chat Application",
  "Video Streaming Service", "Payment Gateway Integration", "Analytics Dashboard",
  "Social Media Scheduler", "Email Marketing Tool", "Document Management System",
  "HR Management System", "Project Management Tool"
]

project_descriptions = [
  "Online shopping platform with payment integration",
  "Secure mobile banking application for iOS and Android",
  "Track inventory across multiple warehouses",
  "Manage customer interactions and sales pipeline",
  "Patient records and appointment scheduling system",
  "Online course platform with video hosting",
  "Food ordering and delivery tracking application",
  "Hotel room booking and management system",
  "Track workouts, nutrition, and fitness goals",
  "Property listing and agent management platform",
  "Customer support ticket system with SLA tracking",
  "Real-time messaging with file sharing",
  "Video on demand platform with subscription",
  "Process payments with multiple providers",
  "Business intelligence and data visualization",
  "Schedule and manage social media posts",
  "Create and track email campaigns",
  "Store, organize, and share documents",
  "Employee records, payroll, and leave management",
  "Task tracking, timelines, and team collaboration"
]

# Bug titles and descriptions for variety
bug_titles = [
  "Login fails with special characters", "Page loads slowly on mobile",
  "API returns 500 error intermittently", "UI breaks on small screens",
  "Data not saving properly", "Email notifications not sending",
  "Search returns incorrect results", "Payment processing fails",
  "App crashes when uploading image", "Password reset not working",
  "Dashboard charts not displaying", "Export feature missing data",
  "Date picker shows wrong format", "User permissions not applying",
  "Session timeout too short", "Duplicate entries in database",
  "Formatting issues in reports", "Integration with third-party failing",
  "Memory leak in background job", "Mobile app crashes on startup",
  "Push notifications not received", "Analytics data not tracking",
  "File upload size limit too low", "Search filters not working",
  "Progress bar not updating", "Confirmation email missing link",
  "Dark mode colors not correct", "Font sizes inconsistent",
  "Dropdown menu cuts off text", "Keyboard navigation broken"
]

bug_descriptions = [
  "When users include special characters in username, login fails with generic error",
  "Page takes more than 5 seconds to load on 4G connection",
  "API endpoint returns 500 error randomly, about 5% of requests fail",
  "UI elements overlap and become unreadable on screens under 768px",
  "Form data is not persisted when user navigates away and comes back",
  "Users report not receiving email notifications for important events",
  "Search by category returns products from wrong categories",
  "Payment gateway timeout occurring during high traffic periods",
  "App crashes reproducibly when uploading images larger than 5MB",
  "Password reset emails are sent but link doesn't work",
  "Dashboard charts show 'No data' even when data exists",
  "CSV export missing 20% of records for large datasets",
  "Date picker shows MM/DD/YYYY but should show DD/MM/YYYY",
  "Users can access features they shouldn't have permission for",
  "Session expires after 5 minutes instead of configured 30 minutes",
  "Duplicate records created when user double-clicks submit button",
  "PDF reports have formatting issues with special characters",
  "Third-party API integration failing silently without logging",
  "Memory usage increases over time, eventually causing crash",
  "App crashes immediately on launch for some Android devices",
  "Users not receiving push notifications for new messages",
  "Analytics missing data from the past 3 days",
  "Cannot upload files larger than 1MB, need to increase to 10MB",
  "Search filters don't apply when multiple filters are selected",
  "Progress bar shows 100% but process is only 50% complete",
  "Confirmation email link leads to 404 page",
  "Dark mode makes text unreadable in some sections",
  "Font sizes vary across different pages inconsistently",
  "Long dropdown items are cut off without scrollbar",
  "Cannot navigate form with Tab key, focus gets stuck"
]

puts "🏗️ Creating projects and assigning members..."

projects = []
project_names.each_with_index do |name, index|
  # Randomly select a manager as creator
  creator = managers.sample
  
  project = Project.create!(
    name: name,
    description: project_descriptions[index],
    creator: creator
  )
  projects << project
  
  # Add creator as manager
  ProjectMembership.create!(
    user: creator,
    project: project,
    role: :manager
  )
  
  # Add 4-8 random members to each project
  num_members = rand(4..8)
  available_users = users.reject { |u| u[:user] == creator }.sample(num_members)
  
  available_users.each do |user_data|
    ProjectMembership.create!(
      user: user_data[:user],
      project: project,
      role: user_data[:role]
    )
  end
  
  puts "  Created '#{name}' with #{available_users.count + 1} members"
end

puts "🐛 Creating 5 bugs for each project (100 total)..."

statuses = [:open, :in_progress, :resolved, :closed]
priorities = [:low, :medium, :high]

projects.each_with_index do |project, p_index|
  5.times do |b_index|
    # Get all project members
    members = project.users.to_a
    next if members.empty?
    
    # Randomly select reporter (usually QA or Manager)
    reporters = members.select { |u| 
      membership = ProjectMembership.find_by(user: u, project: project)
      membership&.qa? || membership&.manager?
    }
    reporters = members if reporters.empty? # Fallback to any member
    
    # Randomly select assignee (usually Developer, sometimes others)
    assignees = members.select { |u|
      membership = ProjectMembership.find_by(user: u, project: project)
      membership&.developer? || membership&.manager?
    }
    assignees = members if assignees.empty? # Fallback to any member
    
    # Determine status based on realistic distribution
    status = case rand(10)
    when 0..4 then :open           # 50% open
    when 5..7 then :in_progress    # 30% in progress
    when 8..9 then :resolved       # 20% resolved
    else :closed
    end
    
    # Determine priority based on realistic distribution
    priority = case rand(10)
    when 0..5 then :medium  # 60% medium
    when 6..8 then :high    # 30% high
    else :low               # 10% low
    end
    
    bug = Bug.create!(
      title: bug_titles.sample,
      description: bug_descriptions.sample,
      status: status,
      priority: priority,
      reporter: reporters.sample,
      assignee: assignees.sample,
      project: project
    )
    
    puts "    Created bug #{b_index + 1} for '#{project.name}': #{bug.title[0..30]}..."
  end
end

puts "\n" + "=" * 60
puts "✅ SEED COMPLETED SUCCESSFULLY!"
puts "=" * 60
puts "\n📊 STATISTICS:"
puts "   Users: #{User.count}"
puts "   Projects: #{Project.count}"
puts "   Project Memberships: #{ProjectMembership.count}"
puts "   Bugs: #{Bug.count}"
puts "\n📈 BUG BREAKDOWN:"
puts "   Open: #{Bug.open.count}"
puts "   In Progress: #{Bug.in_progress.count}"
puts "   Resolved: #{Bug.resolved.count}"
puts "   Closed: #{Bug.closed.count}"
puts "\n🎯 PRIORITY BREAKDOWN:"
puts "   High: #{Bug.where(priority: :high).count}"
puts "   Medium: #{Bug.where(priority: :medium).count}"
puts "   Low: #{Bug.where(priority: :low).count}"
puts "\n" + "=" * 60
puts "\n🔑 SAMPLE LOGIN CREDENTIALS:"
puts "   Any user: userX@example.com / password123 (where X is 1-15)"
puts "   Example: user1@example.com / password123"
puts "\n👥 ROLES ARE ASSIGNED PER PROJECT"
puts "   Check your role in each project by visiting the project page"
puts "=" * 60
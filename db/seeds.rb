# db/seeds.rb

# Clear existing data
puts "🧹 Cleaning database..."
ProjectMembership.destroy_all
Bug.destroy_all
Project.destroy_all
User.destroy_all

puts "👥 Creating users..."

# Create 30 users with different global roles
users = []

# Create 5 admins
5.times do |i|
  user = User.create!(
    email: "admin#{i+1}@example.com",
    password: "password123",
    password_confirmation: "password123",
    global_role: :admin
  )
  users << { user: user, role: nil }  # role nil because global role is admin
  puts "  Created admin: admin#{i+1}@example.com"
end

# Create 25 employees
25.times do |i|
  user = User.create!(
    email: "employee#{i+1}@example.com",
    password: "password123",
    password_confirmation: "password123",
    global_role: :employee
  )
  users << { user: user, role: nil }
  puts "  Created employee: employee#{i+1}@example.com"
end

puts "📊 Creating 100 projects..."

# Project names and descriptions arrays
project_prefixes = [
  "E-commerce", "Mobile", "Web", "Desktop", "API", "Cloud", "Enterprise",
  "Social", "Analytics", "Dashboard", "CRM", "ERP", "CMS", "LMS", "POS",
  "Inventory", "HRMS", "Payment", "Booking", "Delivery", "Chat", "Video",
  "Music", "Gaming", "Fitness", "Health", "Education", "Finance", "Banking",
  "Insurance", "Real Estate", "Travel", "Food", "Fashion", "Sports"
]

project_suffixes = [
  "Platform", "System", "App", "Service", "Suite", "Manager", "Tracker",
  "Hub", "Network", "Portal", "Solution", "Toolkit", "Engine", "Core",
  "Interface", "Gateway", "Connector", "Monitor", "Analyzer", "Optimizer"
]

project_adjectives = [
  "Smart", "Intelligent", "Advanced", "Modern", "Fast", "Secure", "Scalable",
  "Robust", "Dynamic", "Flexible", "Integrated", "Automated", "Real-time",
  "Cloud-based", "Mobile-first", "User-friendly", "High-performance"
]

project_descriptions = [
  "A comprehensive solution for modern businesses",
  "Streamline operations and boost productivity",
  "Enterprise-grade platform with advanced features",
  "Next-generation system built for scale",
  "Innovative approach to traditional workflows",
  "Cutting-edge technology stack implementation",
  "Full-stack application with microservices architecture",
  "Real-time data processing and visualization",
  "Multi-tenant SaaS platform with API-first design",
  "Legacy system modernization project"
]

projects = []
100.times do |i|
  # Generate random project name
  name = [
    project_prefixes.sample,
    project_suffixes.sample
  ].join(' ')
  
  # Add adjective sometimes (30% chance)
  if rand < 0.3
    name = "#{project_adjectives.sample} #{name}"
  end
  
  # Add number sometimes (20% chance)
  if rand < 0.2
    name = "#{name} #{rand(1000..9999)}"
  end
  
  # Randomly select a creator from admins (80% chance) or employees (20% chance)
  creator_pool = rand < 0.8 ? users.select { |u| u[:user].admin? } : users
  creator = creator_pool.sample[:user]
  
  project = Project.create!(
    name: name,
    description: "#{project_descriptions.sample} for #{['businesses', 'enterprises', 'startups', 'teams', 'organizations'].sample}.",
    creator: creator
  )
  projects << project
  
  # Add creator as manager (unless they're admin - admins don't need project role)
  unless creator.admin?
    ProjectMembership.create!(
      user: creator,
      project: project,
      role: :manager
    )
  end
  
  # Add 5-15 random members to each project
  num_members = rand(5..15)
  available_users = users.reject { |u| u[:user] == creator }.sample(num_members)
  
  available_users.each do |user_data|
    # Assign random project role (manager, developer, qa)
    # But ensure at least one manager per project (if creator is admin)
    role = if creator.admin? && !ProjectMembership.exists?(project: project, role: :manager)
      :manager
    else
      [:manager, :developer, :qa].sample
    end
    
    ProjectMembership.create!(
      user: user_data[:user],
      project: project,
      role: role
    )
  end
  
  puts "  Created project #{i+1}/100: '#{name}'"
end

puts "🐛 Creating 20 bugs for each project (2000 total bugs)..."

# Bug data arrays
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
  "Dropdown menu cuts off text", "Keyboard navigation broken",
  "Database connection timeout", "Cache invalidation issues",
  "Webhook delivery failing", "SSL certificate expired",
  "CSV import corrupted", "PDF generation fails",
  "Two-factor authentication broken", "Social login not working",
  "Profile picture upload fails", "Notification count incorrect",
  "Calendar integration broken", "Export to Excel formatting wrong",
  "Drag and drop not working", "Infinite scroll duplicates",
  "Modal dialog not closing", "Form validation too strict",
  "Password strength meter wrong", "Remember me not working",
  "Account lockout too quick", "Email template broken"
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
  "Cannot navigate form with Tab key, focus gets stuck",
  "Database connections not being released properly",
  "Cache not invalidating after data updates",
  "Webhook deliveries timing out after 3 attempts",
  "SSL certificate not auto-renewing",
  "CSV import fails on rows with special characters",
  "PDF generation memory usage too high",
  "2FA codes not being accepted",
  "OAuth callback URL not working",
  "Image upload orientation incorrect",
  "Notification badge shows wrong count",
  "Calendar sync not updating events",
  "Excel export dates format incorrectly",
  "Drag drop reorder not saving",
  "Scroll loading shows same items",
  "Modal can't be closed with ESC",
  "Form accepts invalid email formats",
  "Password meter says weak for strong passwords",
  "Remember me cookie expires too soon",
  "Account locks after 2 failed attempts",
  "Email template images not loading"
]

statuses = [:open, :in_progress, :resolved, :closed]
priorities = [:low, :medium, :high]

projects.each_with_index do |project, p_index|
  # Get all project members for this project
  members = project.users.to_a
  next if members.empty?
  
  20.times do |b_index|
    # Find reporters (any member can report)
    reporter = members.sample
    
    # Find assignees (usually developers, sometimes others)
    assignee_pool = members.select { |u| 
      membership = ProjectMembership.find_by(user: u, project: project)
      membership&.developer? || membership&.manager?
    }
    assignee_pool = members if assignee_pool.empty?
    
    # Determine assignee (70% chance assigned, 30% unassigned)
    assignee = rand < 0.7 ? assignee_pool.sample : nil
    
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
    
    # Randomly select title and description
    title = bug_titles.sample
    # Add some variety by sometimes prefixing with project context
    if rand < 0.3
      title = "[#{project.name.split.first}] #{title}"
    end
    
    bug = Bug.create!(
      title: title,
      description: bug_descriptions.sample,
      status: status,
      priority: priority,
      reporter: reporter,
      assignee: assignee,
      project: project
    )
    
    # Randomly add screenshots to some bugs (20% chance)
    if rand < 0.2
      # This is a placeholder - in real seeds you might attach actual files
      # bug.screenshots.attach(io: File.open(Rails.root.join('test/fixtures/files/screenshot.png')), filename: 'screenshot.png')
      puts "    📸 Bug #{b_index+1} has screenshots (simulated)"
    end
  end
  
  puts "  ✅ Added 20 bugs to '#{project.name}' (Project #{p_index+1}/100)"
end

puts "\n" + "=" * 70
puts "✅ SEED COMPLETED SUCCESSFULLY!"
puts "=" * 70
puts "\n📊 STATISTICS:"
puts "   Admins: #{User.where(global_role: :admin).count}"
puts "   Employees: #{User.where(global_role: :employee).count}"
puts "   Total Users: #{User.count}"
puts "   Total Projects: #{Project.count}"
puts "   Project Memberships: #{ProjectMembership.count}"
puts "   Total Bugs: #{Bug.count}"
puts "\n📈 BUG BREAKDOWN:"
puts "   Open: #{Bug.open.count}"
puts "   In Progress: #{Bug.in_progress.count}"
puts "   Resolved: #{Bug.resolved.count}"
puts "   Closed: #{Bug.closed.count}"
puts "\n🎯 PRIORITY BREAKDOWN:"
puts "   High: #{Bug.where(priority: :high).count}"
puts "   Medium: #{Bug.where(priority: :medium).count}"
puts "   Low: #{Bug.where(priority: :low).count}"
puts "\n👥 ASSIGNMENT BREAKDOWN:"
puts "   Assigned: #{Bug.where.not(assignee_id: nil).count}"
puts "   Unassigned: #{Bug.where(assignee_id: nil).count}"
puts "\n" + "=" * 70
puts "\n🔑 LOGIN CREDENTIALS:"
puts "   Admins: admin1@example.com ... admin5@example.com / password123"
puts "   Employees: employee1@example.com ... employee25@example.com / password123"
puts "\n📝 PROJECT ROLES ARE ASSIGNED PER PROJECT"
puts "   Check your role in each project by visiting the project page"
puts "=" * 70
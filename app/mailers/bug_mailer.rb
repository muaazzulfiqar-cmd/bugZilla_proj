class BugMailer < ApplicationMailer
  default from: "bugs@bugzilla.com"

  def bug_assigned(bug, assignee)
    @bug = bug
    @assignee = assignee
    @reporter = bug.reporter
    @project = bug.project
    @assigned_by = @reporter

    mail(to: @assignee.email, subject: "Bug ##{bug.id} has been assigned to you in #{@project.name}")
  end

  def bug_unassigned(bug, previous_assignee)
    @bug = bug
    @previous_assignee = previous_assignee
    @project = bug.project

    mail(to: @previous_assignee.email, subject: "Bug ##{bug.id} has been unassigned from you")
  end

  def bug_status_changed(bug, old_status, new_status)
    @bug = bug
    @old_status = old_status
    @new_status = new_status
    @project = bug.project

    recipients = [ bug.assignee&.email, bug.reporter.email ].compact.uniq

    mail(to: recipients, subject: "Bug ##{bug.id} status changed to #{new_status.humanize}")
  end

  def bug_deleted(bug, previous_assignee)
    @bug = bug
    @previous_assignee = previous_assignee
    @project = bug.project
    @deleted_by = @bug.reporter

    mail(to: @previous_assignee.email, subject: "Bug ##{bug.id} has been deleted from #{@project.name}")
  end
end

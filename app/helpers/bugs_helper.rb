# app/helpers/bugs_helper.rb
module BugsHelper
  def status_color_class(status)
    case status&.to_s
    when "open"
      "text-red-600 font-medium"
    when "in_progress"
      "text-yellow-600 font-medium"
    when "resolved"
      "text-green-600 font-medium"
    when "closed"
      "text-gray-600 font-medium"
    else
      "text-black"
    end
  end

  def priority_color_class(priority)
    case priority&.to_s
    when "high"
      "text-red-600 font-medium"
    when "medium"
      "text-yellow-600 font-medium"
    when "low"
      "text-green-600 font-medium"
    else
      "text-black"
    end
  end
end

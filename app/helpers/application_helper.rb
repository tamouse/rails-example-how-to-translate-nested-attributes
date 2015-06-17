module ApplicationHelper


  def flash_display
    content_tag(:div, class: "container") do
      flash.each do |level, message|
        concat(content_tag(:div, message, class: "alert alert-#{flash_level_to_bootstrap(level)}"))
      end
    end
  end

  def flash_level_to_bootstrap(level)
    case level
    when "alert"
      "danger"
    else
      "info"
    end
  end

end

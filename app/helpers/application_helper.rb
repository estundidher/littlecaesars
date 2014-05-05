module ApplicationHelper

  def admin?
      controller.class.name.split("::").first=="Admin"
  end

  def auditable model
    html = "<dt> #{t 'created_by'}</dt>"
    html << "<dd> #{model.created_by.username} - #{model.created_at} </dd>"
    html << "<dt> #{t 'updated_by'} </dt>"
    if model.updated_by
        html << "<dd> #{model.updated_by.username} - #{model.updated_at} </dd>"
    else
        html << "<dd> -- </dd>"
    end
    return html.html_safe
  end

  def is_active(action)
    params[:controller] == action ? "class=active" : nil
  end

end
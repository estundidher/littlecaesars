module ApplicationHelper

  def admin?
      controller.class.name.split("::").first=="Admin"
  end

  def auditable model
    html = "<dt> #{t 'created_by'}</dt>"
    html << "<dd> #{model.created_by.username} </dd>"
    html << "<dt> #{t 'updated_by'} </dt>"
    if model.updated_by
        html << "<dd> #{model.updated_by.username} </dd>"
    else
        html << "<dd> -- </dd>"
    end
    return html.html_safe
  end
end
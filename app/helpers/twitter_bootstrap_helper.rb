module TwitterBootstrapHelper

	def tb_class_for flash_type

		puts "-------------- flash_type: #{flash_type}"

		case flash_type.to_s
		  when "success"
		    "alert-success" # Green
		  when "error"
		    "alert-danger" # Red
		  when "alert"
		    "alert-warning" # Yellow
		  when "notice"
		    "alert-info" # Blue
		  else
		    flash_type.to_s
		end
	end

	def tb_show_errors_for model
		render 'layouts/form_errors', model:model
	end

	def tb_submit model = nil, message = nil
		button_tag(type: 'submit', class: 'btn btn-primary') do
		 "<i class='glyphicon glyphicon-ok'></i> ".html_safe + message ||= t("links.#{model.id ? 'update' : 'create'}")
		end
	end

	def tb_button_back path, message = nil
		link_to "<i class='glyphicon glyphicon-arrow-left'></i> ".html_safe + message ||= t('.links.back'),
      			path, :class => 'btn btn-default', :role=> 'button'
	end

	def tb_button_new path, message
		link_to "<i class='glyphicon glyphicon-file'></i> ".html_safe + message,
      			path, :class => 'btn btn-primary', :role=> 'button'
	end

	def tb_button_edit path, message = nil
		link_to "<i class='glyphicon glyphicon-pencil'></i> ".html_safe + message ||= t('.links.edit'),
      			path, :class => 'btn btn-primary', :role=> 'button'
	end

	def tb_button path, icon, message = nil, id = nil, tooltip = nil
		link_to "<i class='glyphicon glyphicon-#{icon}'></i> ".html_safe + message, path,
						:id => "#{id}",
      			:class => 'btn btn-default',
      			:role => 'button',
      			:data => {:toggle=>"tooltip", :placement=>"right", "original-title"=>"#{tooltip}" }

	end

	def tb_has_error model, field
		model.errors.any? && model.errors[field] != [] ? 'has-error' : ''
	end

	def tb_grid_show path
		link_to "<i class='glyphicon glyphicon-eye-open'></i> ".html_safe, path
	end

	def tb_grid_edit model
		link_to "<i class='glyphicon glyphicon-pencil'></i> ".html_safe, model
	end

	def tb_grid_remove model
		link_to "<i class='glyphicon glyphicon-remove'></i> ".html_safe, model,
                                    method: :delete,
                                    data: {confirm: t('warnings.confirm')}
	end

	def tb_grid_link path, icon
		link_to "<i class='glyphicon glyphicon-#{icon}'></i> ".html_safe, path
	end

	def tb_breadcrumb previous = nil, active
		render 'layouts/breadcrumb', previous:previous, active:active
	end

	def tb_page_header title, subtitle
		"<div class='page-header'>"\
			"<h1>#{title} <small>#{subtitle}</small></h1>"\
		"</div>".html_safe
	end
end
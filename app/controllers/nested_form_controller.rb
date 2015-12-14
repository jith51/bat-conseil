class NestedFormController < ActionController::Base

	respond_to :html, :only => :add_nested_fields
 
  def add_nested_fields
  	params[:options] ||= Hash.new
  	params[:options][:child_index] = rand(999999999999)
		params[:options][:builder] = params[:options][:builder].constantize if params[:options][:builder]
		
		if params[:path].blank?
			params[:partial] = "#{params[:object].tableize}/#{params[:association].singularize}_fields" if params[:partial].blank?
		else
			params[:partial] = params[:path]
		end
		
  	params[:context].each {|k, v|  eval "@#{k.to_s} = k.to_s.camelize.constantize.#{(v.blank? ? 'new' : 'find(v)')}" } if params[:context].is_a?Hash

  	@object = (params[:id].blank? ? params[:object].constantize.new : params[:object].constantize.find(params[:id]))

    render partial: "add_nested_fields", locals: params
  end

end
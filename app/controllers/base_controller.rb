class BaseController < InheritedResources::Base

  # include Pundit

  include AjaxDatatable

  respond_to :json, :only => :index
  respond_to :js, :html

  before_filter :authenticate_user!
  protect_from_forgery with: :exception

  # after_action :verify_authorized, except: :index
  # after_filter :verify_policy_scoped, only: :index, format: :json

  # Ajout de la gestion des authorisations
  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # Ajout de la gestion des errors en suppression non pris en charge 
  rescue_from ActiveRecord::DeleteRestrictionError, with: :delete_errors

  protected

    # On surcharge la method resource de Inherited Resource pour intégrer Pundit
    # def resource
    #   resource = super
    #   resource if authorize get_resource_ivar
    # end
    # On surcharge la method build_resource de Inherited Resource pour intégrer Pundit
    # def build_resource
    #   build_resource = super
    #   build_resource if authorize get_resource_ivar
    # end

  private

    # def user_not_authorized
    #   flash[:error] = "You are not authorized to perform this action."
    #   redirect_to request.headers["Referer"] || root_path
    # end

    def delete_errors(exception)
      if resource
        resource.errors.add(:base, exception) 
        flash[:error] = "#{exception}"
        respond_to do |format|
          format.html {redirect_to :back}
          format.js
        end
      end
    end

    # Strong parameter : on permet tout par default --> a refaire
    def build_resource_params
      module_name = resource_class.name.deconstantize
      params_name = (module_name.blank? ? resource_instance_name : "#{module_name.tableize.singularize}_#{resource_instance_name.to_s}" )
      [params.require(params_name).permit!] if params[params_name]
    end
    
end
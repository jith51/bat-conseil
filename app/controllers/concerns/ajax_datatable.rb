module AjaxDatatable
  extend ActiveSupport::Concern

  included do

    def index

      if request.format.html?
        # Dans ce cas on cree la datatable via un .js.erb -> on cree donc @datatable_set pour passer les parametres de la datatable
        datatable = "#{self.controller_name}_datatable".classify.constantize.new(view_context)
        @datatable_set =  datatable.set_datatable
      elsif request.format.json?
        # Dans ce cas on fait une requete json soit pour recuperer soit les parametres de la datatable (params[:init] == true), soit les datas de la datatable
        datatable = "#{self.controller_name}_datatable".classify.constantize.new(view_context)
        datas = datatable.send(params[:init] ? :set_datatable : :get_datas)
      end

      respond_to do |format|
        format.html
        format.json {render json: datas}
        format.js {render @datatable_set}
      end

    end

  end

end
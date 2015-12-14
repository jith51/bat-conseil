class EstimationsDatatable < AjaxDatatablesRails::Base
  # uncomment the appropriate paginator module,
  # depending on gems available in your project.
  # include AjaxDatatablesRails::Extensions::Kaminari
  # include AjaxDatatablesRails::Extensions::WillPaginate
  # include AjaxDatatablesRails::Extensions::SimplePaginator
  include DatatableHelper

  def_delegators :@view, :current_user, :link_to, :collection, :edit_resource_path, :resource_path

  def datatable_options
    {
      responsive: true,
      serverSide: false,
      ajax: nil,
      dom: "<'row'<'columns'<'float-left'f>><'toolbar columns'>r>"+"t"+"<'row'<'columns'i><'columns'p>>",
      scrollCollapse: true,
      pagingType: "numbers",
      scrollY:  "300px",
      "columnDefs": [ { "width": "20%", "targets": [-1] } ],
      paging: false
    }
  end
  
  def columns
    {
      reference:   [['estimations.reference'],         :sortable,  :searchable],
      libelle:     [['estimations.libelle'],         :sortable,  :searchable],
      customer:    [['estimations.customer.first_name', 'estimations.customer.last_name'],         :sortable,  :searchable],
      actions:     [[]]
    }
  end

  def format_record(record)
    {
      # DT_RowId: record.id,
      reference: record.reference,
      libelle: record.libelle,
      customer: record.customer.first_name + ' ' + record.customer.last_name,
      actions: [
        dt_link_to(:edit, edit_resource_path(record.id)),
        dt_link_to(:show, resource_path(record.id)),
        dt_link_to(:delete, resource_path(record.id))
        ].join(" ")
    }
  end
  
  private

  def get_raw_records
    # UserPolicy::Scope.new(current_user, Editor).resolve
    collection
  end

  # ==== Insert 'presenter'-like methods below if necessary
end
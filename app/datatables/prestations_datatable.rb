class PrestationsDatatable < AjaxDatatablesRails::Base
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
      dom: "<'dt-toolbar-grid'<'column'<'float-left'f>><'toolbar column'>r>"+"t"+"<'row'<'columns'i><'columns'p>>",
      oLanguage: { "sSearch": '<i class="fi-magnifying-glass hide-for-small-only"></i>' },
      scrollCollapse: true,
      pagingType: "numbers",
      scrollY:  "300px",
      "columnDefs": [ { "width": "20%", "targets": [-1] } ],
      paging: false
    }
  end
  
  def columns
    {
      libelle:      [['prestations.libelle'],         :sortable,  :searchable],
      unite:        [['prestations.unite'],         :sortable,  :searchable],
      price:       [['prestations.price'],        :sortable,  :searchable],
      actions:      [[]]
    }
  end

  def format_record(record)
    {
      # DT_RowId: record.id,
      libelle: record.libelle,
      unite: record.unite,
      price: record.price,
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
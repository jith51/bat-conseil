module AjaxDatatablesRails
  class Base
    extend Forwardable
    class MethodNotImplementedError < StandardError; end

    attr_reader :view, :options#, :columns
    def_delegator :@view, :params #, :params

    def initialize(view)
      @view = view

      @options = {
        serverSide: true,
        processing: true,
        deferLoading: 20,
        ajax: @view.controller_name + "#" + @view.action_name,
        pagingType:'full_numbers'
      }.deep_merge datatable_options
    end

    def datatable_options
      fail(
        MethodNotImplementedError,
        'Please implement this method in your class.'
      )
    end

    def columns
      fail(
        MethodNotImplementedError,
        'Please implement this method in your class.'
      )
    end

    def format_record(record)
      fail(
        MethodNotImplementedError,
        'Please implement this method in your class.'
      )
    end

    def get_raw_records
      fail(
        MethodNotImplementedError,
        'Please implement this method in your class.'
      )
    end

    def get_datas(options = {})
      {
        :draw => params[:draw].to_i,
        :recordsTotal =>  get_raw_records.count(:all),
        :recordsFiltered => (filter_records(get_raw_records).count(:all) unless params[:columns].nil?),
        :data => fetch_records.map { |record| format_record(record) }
      }
    end

    def set_datatable
      {
        data: ( fetch_records.map { |record| format_record(record) } if (!@options[:serverSide] || !@options[:deferLoading].nil?) ),
        aoColumns: columns.collect{|k, v| {
          mData: k.to_s,
          bSortable: v.include?(:sortable),
          bVisible: !v.include?(:invisible),
          sTitle: I18n.t("datatable.#{self.class.name.tableize.gsub('_datatables','')}.#{k.to_s}", default: k.to_s)} 
        }
      }.deep_merge @options
    end

    private

    def fetch_records
      records = get_raw_records
      records = sort_records(records) unless params[:order].nil?
      records = filter_records(records) unless params[:columns].nil?
      records = paginate_records(records) unless ( params[:length] == '-1' || !@options[:serverSide] || @options[:deferLoading].nil? )
      records
    end

    def sort_records(records)
      sort_by = []
      params[:order].each_value do |item|
        columns[params[:columns][item[:column]]['data'].to_sym].first.each do |column|
          sort_by << "#{column} #{sort_direction(item)}"
        end
      end
      records.order(sort_by.join(", "))
    end

    def paginate_records(records)
      fail(
        MethodNotImplementedError,
        'Please mixin a pagination extension.'
      )
    end

    def filter_records(records)
      records = simple_search(records)
      records = composite_search(records)
      records
    end

    def simple_search(records)
      return records unless (params[:search].present? && params[:search][:value].present?)
      conditions = build_conditions_for(params[:search][:value])
      records = records.where(conditions) if conditions
      records
    end

    def composite_search(records)
      conditions = aggregate_query
      records = records.where(conditions) if conditions
      records
    end

    def searchable_columns
      @searchable_columns ||= columns.each_with_object([]) { |(k,v), a| a << v.first if v.include?(:searchable)}.flatten
    end

    def build_conditions_for(query)
      search_for = query.split(' ')
      criteria = search_for.inject([]) do |criteria, atom|
        criteria << searchable_columns.map { |col| search_condition(col, atom) }.reduce(:or)
      end.reduce(:and)
      criteria
    end

    def search_condition(column, value)
      # model, column = column.split('.')
      # model = model.singularize.titleize.gsub( / /, '' ).constantize
      # casted_column = ::Arel::Nodes::NamedFunction.new('CAST', [model.arel_table[column.to_sym].as('VARCHAR')])
      casted_column = ::Arel::Nodes::SqlLiteral.new("CAST (#{column} AS VARCHAR)")
      casted_column.matches("%#{value}%")

    end

    def aggregate_query
      conditions = params[:columns].collect do |k, v| 
        columns[v.data.to_sym].map {|c| search_condition(c, v[:search][:value])} if !v[:search][:value].blank?
      end
      conditions.flatten.compact.reduce(:and)
    end

    def offset
      (page - 1) * per_page
    end

    def page
      (params[:start].to_i / per_page) + 1
    end

    def per_page
      params.fetch(:length, @options.fetch(:deferLoading, 10)).to_i
    end

    def sort_direction(item)
      options = %w(desc asc)
      options.include?(item['dir']) ? item['dir'].upcase : 'ASC'
    end
  end
end
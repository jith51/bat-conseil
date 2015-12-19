module DatatableHelper
	def dt_link_to(method = nil, url = nil, options = {})
  	options[:class] = "tabled-button dt-btn-#{method}"
  	options[:method] = :delete if method == :delete
  	return link_to I18n.t(method), url, options
  end
end
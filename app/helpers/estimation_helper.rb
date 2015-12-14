module EstimationHelper
  def h_prestation_line(libelle, price, currency)
  	content_tag :div, class: 'prestation_line' do 
      concat content_tag(:div, libelle, class: 'libelle')
      concat content_tag(:div, price, class: 'price')
      concat content_tag(:div, currency, class: 'currency')
  	end
  end
  def h_title(title)
  	content_tag :div, title, class: 'text-center title'
  end
end
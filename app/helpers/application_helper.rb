module ApplicationHelper
  def simple_tag(label=nil, data=nil, *args, &block)
  	options = args.extract_options!.symbolize_keys
  	content_tag :div, class: 'group-form' do 
  		concat content_tag(:span, (label + ' :'), class: 'small-12 medium-2 columns') if !label.nil?
  		concat content_tag(:span, data, class: 'small-12 medium-10 columns like-input', &block)
  	end
  end

  def simple_min_tag(label=nil, data=nil, *args, &block)
    options = args.extract_options!.symbolize_keys
    content_tag :div, class: 'group-form' do 
      concat content_tag(:span, (label + ' :'), class: 'small-12 medium-12 large-3 columns') if !label.nil?
      concat content_tag(:span, data, class: 'small-12 medium-12 large-9 columns like-input', &block)
    end
  end
end
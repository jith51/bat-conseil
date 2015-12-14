module AjaxNestedForm
	module FormHelper
		
		def self.included(base)
	    ActionView::Helpers::FormBuilder.send :include, FormBuilderMethods
  	end

		module FormBuilderMethods
			#	
			# Adds a link to insert a new associated records. The first argument is the name of the link, the second is the name of the association.
			# In this case, NestedForm render the partial named _task_fields.html
			#
			# f.link_to_add("Add Task", :tasks)
			#
			# You can pass HTML options in a hash at the end and a block for the content.
			# In this case, NestedForm render the partial named _partial_path.thml
			#
			# <%= f.link_to_add(:tasks, :partial => _partial_path) do %>
			# Add Task
			# <% end %>
			#
			def link_to_add(*args, &block)
				helper_options = args.extract_options!.symbolize_keys

				association = args.shift

				unless object.respond_to?("#{association}_attributes=")
					raise ArgumentError, "Invalid association. Make sure that accepts_nested_attributes_for is used for #{association.inspect} association."
				end

				# class options for link_to
				helper_options[:class] = [helper_options[:class], "add_nested_fields"].compact.join(" ")
				
				# options for fields_for
				helper_options[:fields_for_options] ||= Hash.new
				# helper_options[:fields_for_options][:builder] = (helper_options[:fields_for_options][:builder]||options[:builder]).to_s if helper_options[:fields_for_options][:builder]||options[:builder]
				helper_options[:fields_for_options][:builder] ||= options[:builder].to_s if helper_options[:fields_for_options][:builder]||options[:builder]
				
				# si has_one association, on positionne la limit a 1
				helper_options[:limit] = 1 if object.class.reflect_on_association(association).macro == :has_one

				helper_options[:data] = { object: object.class.name, id: object.id, association: association, record: object_name, options: helper_options[:fields_for_options] }
				# 	partial: helper_options[:partial],
				# 	path: helper_options[:path],
				# 	options: helper_options[:fields_for_options],
				# 	context: helper_options[:context],
				# 	target: helper_options[:target],
				# 	limit: helper_options[:limit]
				# }
				helper_options.delete(:fields_for_options)
				
				[:partial, :path, :context, :target, :limit].each do |data_options|
					if helper_options[data_options]
						helper_options[:data][data_options] = helper_options[data_options]
						helper_options.delete(data_options)
					end
				end
				# helper_options.delete(:path)
				# helper_options.delete(:fields_for_options)
				# helper_options.delete(:context)
				# helper_options.delete(:target)
				# helper_options.delete(:limit)

				args << (helper_options.delete(:href) || "javascript:void(0)")

	 		  args << helper_options
	 		  @template.link_to(*args, &block)
			end
			# Adds a link to remove the associated record. The first argment is the name of the link.
			#
			# f.link_to_remove("Remove Task")
			#
			# You can pass HTML options in a hash at the end and a block for the content.
			#
			# <%= f.link_to_remove(:class => "remove_task", :href => "#") do %>
			# Remove Task
			# <% end %>
			#
			# See the README for more details on where to call this method.
			#
			def link_to_remove(*args, &block)
				options = args.extract_options!.symbolize_keys
				options[:class] = [options[:class], "remove_nested_fields"].compact.join(" ")
				options[:data] = {record: object_name}
				args << (options.delete(:href) || "javascript:void(0)") if !block_given?
		    args << options
		    @template.hidden_field_tag("#{object_name}[_destroy]", object._destroy) + @template.link_to(*args, &block)
			end
		end

	end
end
class EstimationsController < BaseController
	has_scope :with_associations, default: nil, allow_blank: true, only: [:edit, :show, :generate_pdf]

	respond_to :pdf, only: :generate_pdf

	def generate_pdf
		respond_with *with_chain(resource) do |format|
			format.pdf do
	    	render pdf: "Devis_#{resource.id}",
		     	template: 'estimations/generate_pdf.pdf.slim',
		     	layout: 'layouts/application.pdf.slim',
		     	cover: '<h1>COVER</h1>',
		     	footer: {
						center: "Center",
						left: "Left",
						right: "Right"
		     	},
		     	margin: { top: 15, bottom: 15, left: 20, right: 20 },
		     	show_as_html: params[:debug].present?,
		     	save_to_file: Rails.root.join('public/pdf', "Devis_#{resource.id}.pdf")
		  end
	  end
	end

	def send_pdf
		object = resource
		EstimationMailer.send_to_customer(object).deliver_now
		respond_to do |format|
			if true
				format.html { redirect_to(object, notice: 'Devis correctement envoyé.') }
			else
				format.html { redirect_to(object, notice: 'Erreur en envoi de mail.') }
			end
		end
	end

end
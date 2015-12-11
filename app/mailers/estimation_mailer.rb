class EstimationMailer < ApplicationMailer
	def send_to_customer(estimation)
		@estimation = estimation
		puts 'XXXX'
		@url  = 'http://example.com/login'
		attachments['bat_conseil_devis.pdf'] = File.read(Rails.root.join('public', 'pdf', "Devis_#{@estimation.id}.pdf"))
		mail(to: @estimation.customer.email, subject: 'Devis Bat Conseil')

		puts 'XXXX'
		# @url  = 'http://example.com/login'
		# attachments['bat_conseil_devis.pdf'] = File.read("/public/pdf/Devis_#{@estimation.id}.pdf")
		# mail(to: @estimation.customer.email, subject: 'Devis Bat Conseil')
	end
end
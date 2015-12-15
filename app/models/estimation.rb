class Estimation < ActiveRecord::Base
	belongs_to :customer, required: true
	has_many :volets, dependent: :destroy
	accepts_nested_attributes_for :volets, allow_destroy: true

	#
	# validation
	#
	validates :libelle, :objet, :reference, :intervention_dates, :validity_date, presence: :true


	def generate_pdf
		# Initialisation
		pdf = Prawn::Document.new(page_size: 'A4')
		
		full_sanitizer = Rails::Html::WhiteListSanitizer.new
		permit_tags = %w(b i u strikethrough sub sup font color link)
		permit_attributes = %w(color)

		title_color = "0000FF"
		section_color = "00FF80"

		recap = []
		estimation_total_ht, estimation_total_ttc = 0
		estimation_tva = {}
		Tva.all.each{|t| estimation_tva[t.id] = 0}

		# Affichage Adresse
		pdf.move_down 100
		pdf.bounding_box([200, pdf.cursor], width: 300, height: 150) do
			pdf.text "CHAMPFLEURY, le 5 Novembre 2015" ### AJOUTER DATE DEVIS ET PRENDRE CE CHAMP : self.date	
			pdf.move_down 10
			if self.customer
				pdf.text (self.customer.first_name + ' ' + self.customer.last_name)
				adress = self.customer.adresses.first
				if adress
					pdf.text adress.rue # AJOUTER ADRESSE CHOISI DANS DEVIS self.adresse_client
					pdf.text adress.complement if  adress.complement # AJOUTER ADRESSE CHOISI DANS DEVIS self.adresse_client
					pdf.text (adress.code_postal + ' - ' + adress.ville)
				end
			end

			pdf.transparent(0.5) {pdf.stroke_bounds} # A ENLEVER EN VERSION FINALE
		end

		# Affichage OBJET
		pdf.move_down 100
		pdf.bounding_box([150, pdf.cursor], width: 350, height: 500) do
			pdf.text "N/REF. : #{self.reference}"
			pdf.text "OBJET : #{self.objet}"
			pdf.move_down 30
			pdf.text "Madame, Monsieur,"
			pdf.move_down 10
			pdf.text "Madame, Monsieur, Pour faire suite à votre passage sur notre stand à la foire de Chalons en champagne, et à notre visite du 28 septembre 2015, et selon votre demande,  veuillez trouver ci-dessous notre meilleure proposition concernant les travaux de remplacement de fenêtre de toit de marque VELUX en votre maison d’habitation sise –  30, grande rue à BREVEURY SUR COOLE (51240) - ", align: :justify

			pdf.transparent(0.5) {pdf.stroke_bounds} # A ENLEVER EN VERSION FINALE
		end

		# Saut de page
		pdf.start_new_page
		
		# ON AFFICHE LES PRESTATIONS
		pdf.text "NATURE ET DESCRIPTIF DES TRAVAUX", align: :center, color: section_color
		pdf.move_down 40
		
		self.volets.each do |volet|
			volet_total = 0

			pdf.text volet.libelle, color: title_color
			pdf.move_down 20
			
			volet.prestation_lines.each do |prestation_line|
				# pdf.text ActionController::Base.helpers.strip_tags(prestation_line.description), inline_format: true, align: :justify
				pdf.text full_sanitizer.sanitize(prestation_line.description, tags: permit_tags, attributes: permit_attributes), inline_format: true, align: :justify
				pdf.move_down 2

				pdf.bounding_box([10, pdf.cursor], width: 400, height: 20) do
					pdf.text "#{prestation_line.quantite.to_s} #{prestation_line.unite } à #{prestation_line.price.to_s} € HT par #{prestation_line.unite}"
					pdf.transparent(0.5) {pdf.stroke_bounds} # A ENLEVER EN VERSION FINALE
				end
				pdf.bounding_box([410, pdf.cursor+20], width: 100, height: 20) do
					pdf.text "#{prestation_line.price * prestation_line.quantite} € HT", align: :right
					pdf.transparent(0.5) {pdf.stroke_bounds} # A ENLEVER EN VERSION FINALE
				end
				volet_total += prestation_line.price * prestation_line.quantite
				estimation_tva[prestation_line.tva.id] += prestation_line.price * prestation_line.quantite * prestation_line.tva.value / 100
				pdf.move_down 15
			end
			pdf.move_down 5
			# ON AFFICHE LE TOTAL
			pdf.bounding_box([10, pdf.cursor], width: 400, height: 20) do
					pdf.text "Sous-Total :", color: title_color
					pdf.transparent(0.5) {pdf.stroke_bounds} # A ENLEVER EN VERSION FINALE
			end
			pdf.bounding_box([410, pdf.cursor+20], width: 100, height: 20) do
				pdf.text "#{volet_total} € HT", align: :right, color: title_color
				pdf.transparent(0.5) {pdf.stroke_bounds} # A ENLEVER EN VERSION FINALE
			end

			recap << [volet.libelle, volet_total]
		end
		
		#
		# RECAPITULATIF
		#
		pdf.move_down 40
		pdf.text "RECAPITULATIF", align: :center, color: section_color
		pdf.move_down 40

		recap.each do |volet|
			pdf.bounding_box([10, pdf.cursor], width: 400, height: 20) do
				pdf.text volet[0]
				pdf.transparent(0.5) {pdf.stroke_bounds} # A ENLEVER EN VERSION FINALE
			end
			pdf.bounding_box([410, pdf.cursor+20], width: 100, height: 20) do
				estimation_total_ht += volet[1]
				pdf.text "#{volet[1]} €", align: :right
				pdf.transparent(0.5) {pdf.stroke_bounds} # A ENLEVER EN VERSION FINALE
			end
		end
		
		# TOTAUX
		pdf.move_down 5
		
		pdf.bounding_box([10, pdf.cursor], width: 400, height: 20) do
			pdf.text "MONTANT TOTAL HT"
			pdf.transparent(0.5) {pdf.stroke_bounds} # A ENLEVER EN VERSION FINALE
		end
		pdf.bounding_box([410, pdf.cursor+20], width: 100, height: 20) do
			pdf.text "#{estimation_total_ht} €", align: :right
			pdf.transparent(0.5) {pdf.stroke_bounds} # A ENLEVER EN VERSION FINALE
		end
		# TVA
		estimation_total_ttc = estimation_total_ht
		estimation_tva.each do |k, v|
			if !(v == 0)
				pdf.bounding_box([10, pdf.cursor], width: 400, height: 20) do
					pdf.text "TVA à #{Tva.find(k).name} %"
					pdf.transparent(0.5) {pdf.stroke_bounds} # A ENLEVER EN VERSION FINALE

				end
				pdf.bounding_box([410, pdf.cursor+20], width: 100, height: 20) do
					pdf.text "#{v} €", align: :right
					pdf.transparent(0.5) {pdf.stroke_bounds} # A ENLEVER EN VERSION FINALE
				end
				estimation_total_ttc += v
			end
		end
		pdf.bounding_box([10, pdf.cursor], width: 400, height: 20) do
			pdf.text "MONTANT TOTAL TTC"
			pdf.transparent(0.5) {pdf.stroke_bounds} # A ENLEVER EN VERSION FINALE
		end
		pdf.bounding_box([410, pdf.cursor+20], width: 100, height: 20) do
			pdf.text "#{estimation_total_ttc} €", align: :right
			pdf.transparent(0.5) {pdf.stroke_bounds} # A ENLEVER EN VERSION FINALE
		end

		#
		# CONDITION
		#
		pdf.move_down 40
		pdf.text "CONDITIONS", align: :center, color: section_color
		pdf.move_down 40

		pdf.text "A/ DE REGLEMENT"
		pdf.move_down 10

		pdf.text "B/ DE GARANTIE"
		pdf.move_down 10

		pdf.text "C/ ACCEPTATION DU PRESENT DEVIS"
		pdf.move_down 10

		pdf.text "D/ DATE D'INTERVENTION"
		pdf.move_down 10

		# GENERATION DU PDF
		pdf.render_file File.join(Rails.root, "public/pdf", "devis_#{self.id}.pdf") 
	end

end
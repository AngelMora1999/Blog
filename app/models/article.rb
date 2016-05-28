class Article < ActiveRecord::Base
	#uniqueness es para que sea unico.
	belongs_to :user
	has_many :comments
	validates :title, presence: true, uniqueness: true
	validates :body, presence: true, length: { minimum: 20 }
	before_save :set_visit_count
	after_create :save_categories

	has_attached_file :cover, styles: { medium: "1280*720", thumb: "800*600" }
	validates_attachment_content_type :cover, content_type: /\Aimage\/.*\Z/

	def categories=(value)
		#Custom setter
		@categories = value
	end

	def update_visits_count
		#Por primera ves para asignar la visitas a las q no tenian  self.save if self.visits_count.nil?
		self.update(visits_count: self.visits_count + 1)
	end

	private

	def save_categories
		@categories.each do |category_id|
			HasCategory.create(category_id: category_id, article_id: self.id)
		end
	end

	def set_visit_count
		self.visits_count ||= 0
	end
end
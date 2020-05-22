class Product < ApplicationRecord
  has_many :productxcategories
  has_many :categories, through: :productxcategories
  belongs_to :user
  has_many_attached :images

  validates :name, presence: true, length: {minimum: 4}
  validate :correct_image_type

  enum status: [:published, :archived, :unpublished]
  attr_accessor :category_elements

  scope :published, -> { where(status: 'published')}
  scope :unpublished, -> { where(status: 'unpublished')}
  scope :archived, -> { where(status: 'archived')}

  def save_categories
    return productxcategories.destroy_all if category_elements.nil? || category_elements.empty?

    productxcategories.where.not(category_id: category_elements).destroy_all
    category_elements.each do |category_id|
      Productxcategory.find_or_create_by(product: self, category_id: category_id)
    end
  end

  def delete_image(index)
     images[index].purge if images[index]
  end

  def change_status
    if self.status == 'published'
      self.status = 'archived'
      self.save
    elsif self.status == 'archived' || self.status == 'unpublished'
      self.status = 'published'
      self.save
      ProductMailer.product_published(self).deliver!
    end
  end

  def correct_image_type
    if images.attached?
      images.each do |image|
        unless image.content_type.in?(%w(image/jpeg image/png))
          errors.add(:images, 'Must be a JPEG or PNG')
        end
      end
    end
  end#correct_image_type

  def is_propietary?(current_user)
    current_user.id == self.user.id
  end
end

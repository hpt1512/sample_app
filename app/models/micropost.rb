class Micropost < ApplicationRecord
  belongs_to :user

  has_one_attached :image

  validates :content, presence: true,
    length: {maximum: Settings.microposts.digit_140}
  validates :image, content_type: {in: Settings.format_image,
                                   message: I18n.t("image_format_validate")},
    size: {less_than: 5.megabytes, message: I18n.t("should_be_less_5mb")}

  delegate :name, to: :user, prefix: true

  scope :newest, ->{order created_at: :desc}

  def display_image
    image.variant resize_to_limit: [500, 500]
  end
end

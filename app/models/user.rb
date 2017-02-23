class User < ApplicationRecord

  IMAGE_FORMATS = [ "image/jpeg", "image/jpg", "image/png" ].freeze

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :company, optional: true
  has_many :problems
  has_many :comments

  has_attached_file :avatar,
    url: ':s3_domain_url',
    path: 'users/:id/:style_:basename.:extension',
    default_url: 'avatar/:style/default_avatar.png',
    storage: :s3,
    bucket: ENV['S3_BUCKET'],
    s3_region: ENV['AWS_REGION'],
    s3_credentials: {
      access_key_id: ENV['S3_KEY'],
      secret_access_key: ENV['S3_SECRET'],
    },
    s3_protocol: 'https',
    styles: lambda { |image| IMAGE_FORMATS.include?(image.content_type) ? {
      thumb: '160x160#', small: '25x25#' } : {} }

  validates_attachment_content_type :avatar, content_type: IMAGE_FORMATS,
    message: "Uploaded file is not a valid image. Only JPG, JPEG and PNG files are allowed"
  validates :first_name, :last_name, presence: true

  def add_company
    domain_name = email.sub(/.*?@/, '')
    if company = Company.find_by_domain_name(domain_name)
      update(company: company)
    end
  end
end

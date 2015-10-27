class User < ActiveRecord::Base
	validates_presence_of :email, :first_name, :last_name

	has_many :authentication_tokens
  has_many :publication_requests
  has_many :request_attachments
  has_many :requests_as_admin, :class_name => 'PublicationRequest', :foreign_key => 'admin_id'
  has_many :requests_as_designer, :class_name => 'PublicationRequest', :foreign_key => 'designer_id'
  has_many :requests_as_reviewer, :class_name => 'PublicationRequest', :foreign_key => 'reviewer_id'
  has_many :comments
  has_many :templates
  has_secure_password
  validates :password, length: { minimum: 8 }, on: :create
  validates :password, length: { minimum: 8 }, on: :update, allow_blank: true

  before_save :give_user_role

  def self.ROLES
  	%i[admin designer reviewer user banned]
  end

  def roles=(roles)
  	roles = [*roles].map { |r| r.to_sym }
  	self.roles_mask = (roles & User.ROLES).map { |r| 2**User.ROLES.index(r) }.inject(0, :+)
  end

  def roles
  	User.ROLES.reject do |r|
  		((roles_mask.to_i || 0) & 2**User.ROLES.index(r)).zero?
		end
	end

	def has_role?(role)
		roles.include?(role)
	end

  def add_roles(roles)
    self.roles = self.roles.concat(roles)
    self.save!
  end

  private
    def give_user_role
      self.roles=(self.roles << :user)
    end

end

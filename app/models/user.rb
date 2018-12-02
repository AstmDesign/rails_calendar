class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :omniauthable, :omniauth_providers => [:facebook, :google_oauth2]
  attr_accessor :password, :password_confirmation

  # Scopes
  default_scope { order(id: :desc) }

  # validation
  # validates :name, :email, :password, presence: true, allow_blank: false
  # validates :name, :email, uniqueness: true
  # validates :password, length: { minimum: 8 }

  def self.from_omniauth(auth)
    # pass = Devise.friendly_token[0,20]
    #
    # where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
    #   user.email = auth.info.email
    #   user.password = pass
    #   user.name = auth.info.name
    #   user.uid = auth.uid
    #   user.provider = auth.provider
    #   user.image = auth.info.image
    # end

    user = User.where(:provider => auth.provider).where(:email => auth.info.email).first

    unless user
      pass = Devise.friendly_token[0,20]
      user = User.create(name: auth.info.name, email: auth.info.email, provider: auth.provider, image: auth.info.image, password: pass, password_confirmation: pass)
    end

    user
  end

end

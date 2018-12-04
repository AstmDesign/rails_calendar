class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :omniauthable, :omniauth_providers => [:facebook, :google_oauth2, :twitter, :instagram]
  attr_accessor :password, :password_confirmation

  # Scopes
  default_scope { order(id: :desc) }

  # validation
  # validates :name, :email, :password, presence: true, allow_blank: false
  # validates :name, :email, uniqueness: true
  # validates :password, length: { minimum: 8 }

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

    # user = User.where(:provider => auth.provider).where(:email => auth.info.email).first

    # unless user
    #   pass = Devise.friendly_token[0,20]
    #   user = User.create(name: auth.info.name, email: auth.info.email, provider: auth.provider, image: auth.info.image, password: "456", password_confirmation: "456")
    # end

    # user
  # end

  def self.find_for_oauth(auth)
    user = User.where(uid: auth.uid, provider: auth.provider).first


    unless user
      nickname = auth.extra.raw_info.name if auth.provider == 'facebook'
      nickname = auth.info.nickname if auth.provider == 'twitter'
      nickname = auth.info.name if auth.provider == 'google_oauth2'
      nickname = auth.info.name if auth.provider == 'instagram'

      email = auth.extra.raw_info.name if auth.provider == 'facebook'
      email = auth.info.nickname if auth.provider == 'twitter'
      email = auth.info.email if auth.provider == 'google_oauth2'
      email = "" if auth.provider == 'instagram'
      binding.pry

      user = User.create(
        uid:      auth.uid,
        name:     nickname,
        provider: auth.provider,
        email:    email,
        password: Devise.friendly_token[0, 20]
      )
    end

    user
  end

  def self.new_with_session(params, session)
   super.tap do |user|
     if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
       user.email = data["email"] if user.email.blank?
     end
   end
  end

end

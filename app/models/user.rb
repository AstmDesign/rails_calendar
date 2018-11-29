class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :omniauthable, :omniauth_providers => [:facebook, :google_oauth2]
  # Scopes
  default_scope { order(id: :desc) }


  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  # def self.from_omniauth(auth)
  #   where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
  #     user.email = auth.info.email
  #     user.password = Devise.friendly_token[0,20]
  #     user.name = auth.info.name   # assuming the user model has a name
  #   end
  # end


  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(:email => data["email"]).first
  
          
          binding.pry
          
    unless user
      @pass = Devise.friendly_token[0,20]
      user = User.create(name: data["name"], email: data["email"], image: data["image"])
    end
    user
  end

end

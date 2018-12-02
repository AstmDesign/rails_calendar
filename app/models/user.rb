class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :omniauthable, :omniauth_providers => [:facebook, :google_oauth2]
  # Scopes
  default_scope { order(id: :desc) }


  # def self.new_with_session(params, session)
  #   super.tap do |user|
  #     if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
  #       user.email = data["email"] if user.email.blank?
  #     end
  #   end
  # end

  def self.from_omniauth(auth)
    binding.pry

    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.name = auth.info.name
      user.uid = auth.uid
      user.provider = auth.provider
      user.image = auth.info.image
    end
  end


  # def self.from_omniauth(access_token)
  #   data = access_token.info
  #   user = User.where(:email => data["email"]).first
            
  #   unless user
  #     @pass = Devise.friendly_token[0,20]
  #     user = User.create(name: data["name"], email: data["email"], image: data["image"])
  #   end
  #   user
  # end

end

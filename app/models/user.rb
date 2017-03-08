class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]
  has_many :orders
  has_many :restaurants
  has_many :ordered_meals, through: :orders
  has_one :messenger_restaurant, class_name: 'Restaurant', foreign_key: :messenger_user_id

  def self.find_for_facebook_oauth(auth)
    user_params = auth.to_h.slice(:provider, :uid)
    user_params.merge! auth.info.slice(:email, :first_name, :last_name)
    user_params[:facebook_picture_url] = auth.info.image
    user_params[:token] = auth.credentials.token
    user_params[:token_expiry] = Time.at(auth.credentials.expires_at) rescue 30.days.from_now

    user = User.where(provider: auth.provider, uid: auth.uid).first
    user ||= User.where(email: auth.info.email).first # User did a regular sign up in the past.

    user_data_json = RestClient.get("https://graph.facebook.com/v2.8/me?fields=picture&access_token=#{user_params[:token]}")
    user_data = JSON.parse user_data_json
    user_params[:facebook_picture_check] = user_data['picture']['data']['url'].match(/\/\d+_(\d+)_\d+/)[1]

    if user
      user.update(user_params)
    else
      if user = User.find_by(facebook_picture_check: user_params[:facebook_picture_check])
        user.update(user_params)
      else
        user = User.new(user_params)
        user.password = Devise.friendly_token[0,20]  # Fake password for validation
        user.save
      end
    end

    user
  end

  def current_order
    orders.last if (orders.any? && orders.last.paid_at.nil? && (orders.last.updated_at > (30.minutes.ago)))
  end
end

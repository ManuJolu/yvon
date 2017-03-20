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

  enum role: { customer: 0, restaurant_owner: 1, admin: 9 }

  acts_as_voter

  scope :are_restaurant_owner_plus, -> { where('role > 0') }

  def self.find_for_facebook_oauth(auth)
    user_params = auth.to_h.slice('provider', 'uid')
    user_params.merge! auth.info.slice(:email, :first_name, :last_name)
    user_params[:facebook_picture_url] = auth.info.image
    user_params[:token] = auth.credentials.token
    user_params[:token_expiry] = Time.at(auth.credentials.expires_at) rescue 60.days.from_now

    user = User.find_by(provider: auth.provider, uid: auth.uid)

    if user
      user.update(user_params)
    else
      user_data_json = RestClient.get("https://graph.facebook.com/v2.8/me?fields=picture&access_token=#{user_params[:token]}")
      user_data = JSON.parse user_data_json
      user_params[:facebook_picture_check] = user_data['picture']['data']['url'].match(/\/(\w+).jpg/)[1]

      user = User.find_by(facebook_picture_check: user_params[:facebook_picture_check])
      user ||= User.find_by(email: auth.info.email)
      if user
        user.update(user_params)
      else
        user = User.new(user_params)
        user.password = Devise.friendly_token[0,20]
        user.save
      end
    end

    user
  end

  def current_order
    orders.last if (orders.any? && orders.last.sent_at.nil? && (orders.last.updated_at > (30.minutes.ago)))
  end
end

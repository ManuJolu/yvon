class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :legal, :privacy]

  def home
  end

  def fooding
    @restaurants = Restaurant.by_duty.where.not(latitude: nil, longitude: nil)

    @address = 'Bordeaux'
    @restaurants = @restaurants.near(@address, 5)

    @restaurants = @restaurants.where.not(mode: 'inactive')

    @hash = Gmaps4rails.build_markers(@restaurants) do |restaurant, marker|
      marker.lat restaurant.latitude
      marker.lng restaurant.longitude
      marker.infowindow render_to_string(partial: "card_map", locals: { restaurant: restaurant })
      marker.picture({
        "url" => view_context.image_path('yvon.png'),
        "width" => 32,
        "height" => 32
      })
    end
  end

  def legal
  end

  def privacy
  end
end

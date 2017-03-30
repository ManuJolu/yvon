class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :fooding, :legal, :privacy]

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
        "url" => view_context.image_path('y_16.png'),
        "width" => 16,
        "height" => 16
      })
    end

    places = Place.all

    place_hash = Gmaps4rails.build_markers(places) do |place, marker|
      marker.lat place.latitude
      marker.lng place.longitude
      marker.picture({
        "url" => view_context.image_path('google_pointer.png'),
        "width" => 25,
        "height" => 43
      })
    end

    @hash.concat(place_hash)
  end

  def legal
  end

  def privacy
  end
end

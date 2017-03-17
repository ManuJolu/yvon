class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :legal, :privacy]

  def home
  end

  def legal
  end

  def privacy
  end
end

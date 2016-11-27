class MealDecorator < Draper::Decorator
  delegate_all

  def price
    "#{format('%.2f', object.price.fdiv(100))} €"
  end

  def price_num
    format('%.2f', object.price.fdiv(100))
  end

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

end

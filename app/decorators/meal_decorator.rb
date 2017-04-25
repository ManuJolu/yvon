class MealDecorator < Draper::Decorator
  delegate_all
  decorates_association :options

  def display_options
    if price_cents > 0
      "👉 " + options.object.select_active.map { |option| option.decorate.signed_price }.join(' - ')
    else
      "💰 " + options.object.select_active.map { |option| option.decorate.unsigned_price }.join(' - ')
    end
  end

  def price
    humanized_money_with_symbol object.price
  end

  def price_num
    format '%.2f', object.price
  end
end

class OrderDecorator < Draper::Decorator
  delegate_all
  decorates_association :user
  decorates_association :ordered_meals

  def price
    humanized_money_with_symbol object.price
  end

  def price_num
    format '%.2f', object.price
  end

  def tax_num
    format '%.2f', object.tax
  end

  def pretax_price_num
    format '%.2f', object.pretax_price
  end

  def alacarte_price_num
    format '%.2f', object.alacarte_price
  end

  def discount_num
    format '%.2f', object.discount
  end

  def sent_at
    object.sent_at&.strftime('%H:%M:%S')
  end

  def ready_at_limit
    (object.sent_at.try(:+, object.preparation_time.minutes))&.strftime('%H:%M:%S')
  end

  def ready_at
    object.ready_at&.strftime('%H:%M:%S')
  end

  def delivered_at
    object.delivered_at&.strftime('%H:%M:%S')
  end
end

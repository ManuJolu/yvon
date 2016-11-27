class OrderDecorator < Draper::Decorator
  delegate_all
  decorates_association :user
  decorates_association :ordered_meals

  def price
    "#{format('%.2f', object.price.fdiv(100))} €"
  end

  def paid_at
    object.paid_at&.strftime('%-H:%M:%S')
  end

  def ready_at
    object.ready_at&.strftime('%-H:%M:%S')
  end

  def delivered_at
    object.delivered_at&.strftime('%-H:%M:%S')
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

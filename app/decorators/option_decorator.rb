class OptionDecorator < Draper::Decorator
  delegate_all

  def to_s
    str = object.to_label
    str += " (inact.)" unless object.active
    str
  end
end

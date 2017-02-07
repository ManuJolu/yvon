module ApplicationHelper
  def yield_with_default(args = {})
    if content_for?(args[:holder])
      "#{content_for(args[:holder]).squish} | #{args[:default]}"
    else
      args[:default]
    end
  end
end

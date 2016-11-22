module ApplicationHelper
  def yield_with_default(holder, default)
    if content_for?(holder)
      "#{content_for(holder).squish} | #{default}"
    else
      default
    end
  end
end

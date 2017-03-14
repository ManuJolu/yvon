module ApplicationHelper
  def yield_with_default(args = {})
    if content_for?(args[:holder])
      "#{content_for(args[:holder]).squish} | #{args[:default]}"
    else
      args[:default]
    end
  end

  def cl_image_path_with_default(photo_path, options = {})
    if photo_path
      cl_image_path(photo_path, options)
    else
      cl_image_path('yvon_messenger_code.png', options)
    end
  end
end

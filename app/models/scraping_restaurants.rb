require 'open uri'

html_file = open("https://www.lafourchette.com/restaurant+bordeaux")
html_doc = Nokogiri::HTML(html_file)

html_doc.search('.resultItem').each do |element|
    name = element.children[1].child.text
    photo_url = element.child.child.child.attribute('data-src').value
    address = element.children[1].children[1].child.text.strip
    category = element.children[1].children[2].child.child.child.text
    Restaurant.create(name: name, photo_url: photo_url, category: category, address: address)
end

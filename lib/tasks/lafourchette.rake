require 'open-uri'

namespace :scrap do
  desc "resto"
  task :lafourchette do

    user = User.find_by(last_name: "LaFourchette")
    if user.blank?
      puts "LaFourchette creation"
      user = User.new(last_name:"LaFourchette", email: "lafourchette@hello-yvon.com", password: "123456")
      user.encrypted_password="ENCRYPT.MY.ASS!!!KJASOPJ090923ULXCIULSH.IXJ!S920"
      user.save
    end

    html_file = open("https://www.lafourchette.com/restaurant+bordeaux")
    html_doc = Nokogiri::HTML(html_file)

    html_doc.search('.resultItem').each do |element|
      name = element.children[1].child.text
      photo_url = element.child.child.child.attribute('data-src').value
      address = element.children[1].children[1].child.text.strip
      description = element.children[1].children[2].child.child.child.text
      restaurant = Restaurant.new(user: user, name: name, photo_url: photo_url, address: address, description: description, category: rand(0..6), preparation_time: rand(5..20))
      puts restaurant.name
      restaurant.valid?
      puts restaurant.errors.inspect
      if restaurant.save
        puts "saved"
      end
    end
  end
end

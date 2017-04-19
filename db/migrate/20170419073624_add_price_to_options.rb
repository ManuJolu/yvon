class AddPriceToOptions < ActiveRecord::Migration[5.0]
  def change
    add_monetize :options, :price, amount: { default: 0 }, currency: { present: false }
  end
end

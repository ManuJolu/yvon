class Order < ApplicationRecord
  belongs_to :user, required: true
  belongs_to :restaurant
  has_many :ordered_meals
  has_many :meals, through: :ordered_meals
  has_many :options, through: :ordered_meals
  has_many :meal_categories, through: :ordered_meals
  has_many :order_elements
  has_many :elements, through: :order_elements

  monetize :price_cents
  monetize :tax_cents
  monetize :pretax_price_cents
  monetize :alacarte_price_cents
  monetize :discount_cents

  scope :at_week, -> { where('paid_at > ?', 1.week.ago).order(paid_at: :desc) }
  scope :pending, -> { where('paid_at IS NOT NULL').where(delivered_at: nil).order(paid_at: :desc) }
  scope :delivered, -> { where('delivered_at IS NOT NULL').order(delivered_at: :desc) }

  # def self.pending
  #   select { |order| order.paid_at && order.delivered_at.nil? }
  # end

  # def self.delivered
  #   select { |order| order.delivered_at }
  # end

  def price_cents
    order_elements.sum { |order_element| order_element.quantity * order_element.element.price_cents }
  end

  def tax_cents
    order_elements.sum { |order_element| order_element.quantity * order_element.element.tax_cents }
  end

  def pretax_price_cents
    order_elements.sum { |order_element| order_element.quantity * order_element.element.pretax_price_cents }
  end

  def alacarte_price_cents
    ordered_meals.sum { |ordered_meal| ordered_meal.quantity * ordered_meal.meal.price_cents }
  end

  def discount_cents
    alacarte_price_cents - price_cents
  end

  def create_elements
    order_elements.destroy_all
    order_elements_array = []
    ordered_meals.each do |ordered_meal|
      order_elements_array << order_elements.new(element: ordered_meal.meal, quantity: ordered_meal.quantity)
    end
    restaurant.menus.by_price.each do |menu|
      order_elements_array = extract_menu_from_meal_elements(order_elements_array, menu)
    end
    #create order_elements
    order_elements_array.each { |order_element| order_element.save }
  end

  def meal_categories_array(order_elements_array)
    meal_categories_array = []
    order_elements_array.select { |order_element| order_element.element_type == "Meal" }.each do |order_element|
      order_element.quantity.times { meal_categories_array << order_element.element.meal_category }
    end
    meal_categories_array
  end

  def extract_menu_from_meal_elements(order_elements_array, menu)
    if meal_categories_array(order_elements_array).contains_all?(menu.meal_categories_array)
      # add menu element to array
      menu_element = order_elements_array.find { |order_element| order_element.element == menu }
      if menu_element
        menu_element.quantity +=1
      else
        menu_element = order_elements.new(element: menu)
        order_elements_array << menu_element
      end
      # remove meal elements from array
      menu.menu_meal_categories.each do |menu_meal_category|
        delete_order_elements = order_elements_array.select { |order_element| (order_element.element_type == "Meal") && order_element.element.meal_category == menu_meal_category.meal_category}
        delete_order_elements.sort_by! { |order_element| - order_element.element.price }
        to_delete = menu_meal_category.quantity
        while to_delete > 0
          if delete_order_elements.first.quantity > to_delete
            delete_order_elements.first.quantity -= to_delete
            to_delete = 0
          else
            to_delete -= delete_order_elements.first.quantity
            order_elements_array.delete_at(order_elements_array.index(delete_order_elements.first))
            delete_order_elements.delete_at(0)
          end
        end
      end
      # recursive
      extract_menu_from_meal_elements(order_elements_array, menu)
    end
    order_elements_array
  end
end

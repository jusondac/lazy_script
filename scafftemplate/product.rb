class Product < ApplicationRecord
  enum :category, {
    electronics: 0,
    clothing: 1,
    books: 2,
    home_goods: 3,
    sports: 4,
    beauty: 5,
    toys: 6,
    food: 7,
    other: 8
  }
  def self.ransackable_attributes(auth_object = nil)
    [ "name" ]
  end
  # <%= search_form_for @q, html: { class: "sm:pr-3 flex gap-2" } do |f| %>
  #   <%= f.label :name_cont, class: "sr-only" %>
  #   <div class="relative w-48 mt-1 sm:w-64 xl:w-96">
  #     <%= f.search_field :name_cont, class: "bg-gray-50 border border-gray-300 text-gray-900 sm:text-sm rounded-lg focus:ring-primary-500 focus:border-primary-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500", placeholder: "Search for products" %>
  #   </div>
  # <% end %>
end

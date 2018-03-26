# Calculator Model
class Calculator < ActiveRecord::Base
  include ActivityHistory
  include CloneRecord
  # Fields for the search form in the navbar
  def self.search_field
    :name_or_value_cont
  end
end

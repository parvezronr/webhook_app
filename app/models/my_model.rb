class MyModel < ApplicationRecord
	validates :name, presence: true
  validates :data, presence: true
end

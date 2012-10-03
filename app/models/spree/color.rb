module Spree	
	class Color < ActiveRecord::Base
	  attr_accessible :image_id, :name, :hue, :sat, :val, :rank
	  belongs_to :image, :foreign_key => 'image_id'
	end
end
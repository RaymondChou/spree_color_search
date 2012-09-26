module Spree	
	class Color < ActiveRecord::Base
	  attr_accessible :image_id, :name, :hue, :sat, :val
	  belongs_to :image
	end
end
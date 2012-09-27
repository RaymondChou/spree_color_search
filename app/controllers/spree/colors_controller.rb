module Spree
  class ColorsController < BaseController
    rescue_from ActiveRecord::RecordNotFound, :with => :render_404

    respond_to :html, :json

    require 'color_util'

    def index
    	@hex = params[:hex]

    	if @hex.nil?
    		render :template => 'spree/colors/show'
    	else
    		arr = @hex.scan(/../)
    		hsv = ColorUtil.rgb_to_hsv(arr[0].hex.to_i, arr[1].hex.to_i, arr[2].hex.to_i)
    		hue_start = hsv[:h] - 15
    		hue_end = hsv[:h] + 15
            sat_start = hsv[:s] - 15
            sat_end = hsv[:s] + 15
            val_start = hsv[:v] - 15
            val_end = hsv[:v] + 15
    		if hue_start < 0; hue_start += 360; end
    		if hue_end > 360; hue_end -= 360; end
    		if hue_start > hue_end
    			ch = Spree::Color.where("(hue > #{hue_start} or hue < #{hue_end}) and (sat >= #{sat_start} and sat <= #{sat_end}) and (val >= #{val_start} and val <= #{val_end})").joins(:image).order("(abs(sat - #{hsv[:s]})*.33 + abs(hue - #{hsv[:h]})*.33 + abs(val - #{hsv[:v]})*.33) ASC").select("viewable_id")
    		else
	    		ch = Spree::Color.where("(hue > #{hue_start} and hue < #{hue_end}) and (sat >= #{sat_start} and sat <= #{sat_end}) and (val >= #{val_start} and val <= #{val_end})").joins(:image).order("(abs(sat - #{hsv[:s]})*.33 + abs(hue - #{hsv[:h]})*.33 + abs(val - #{hsv[:v]})*.33) ASC").select("viewable_id")
	    	end
#((hue > 345.0 or hue < 15.0) and (sat >= -5.0 and sat <= 5.0) and (val >= -5.0 and val <= 5.0))
	    	id_array = []
	    	ordered_hash = {}

	    	ch.each do |value| 
	    		if ordered_hash[value[:viewable_id]].nil?
		    		ordered_hash[value[:viewable_id]] = ordered_hash.length 
		    		id_array << value[:viewable_id]
		    	end
	    	end

	    	@products = Spree::Product.find(id_array).sort_by {|p| ordered_hash[p.id]}
	    	respond_with @products
	    end
    end

    def show

    end

  end
end

#Spree::Variant.find_by_sql("Select DISTINCT * from spree_variants LEFT JOIN spree_assets ON spree_assets.viewable_id = spree_variants.id INNER JOIN spree_colors ON spree_colors.image_id = spree_assets.id WHERE hue > 21 and hue < 51").count

#Spree::Color.joins("LEFT JOIN spree_assets ON spree_assets.id = spree_colors.image_id").where("hue > 25 and hue < 51").select("viewable_id").order("abs(hue-15) DESC")
#Spree::Image.find_by_sql("SELECT viewable_id, spree_assets.id from spree_assets INNER JOIN spree_colors ON spree_colors.image_id = spree_assets.id WHERE spree_colors.hue > 25 and spree_colors.hue < 51")
require './lib/map.rb'

class WelcomeController < ApplicationController

  	def index
		@result = [[42.365965, -71.25981]]
    	name_list = Building.order(:name).pluck(:id, :name)
    	@notes = {}
    	name_list.sort_by{|id, name| name}.each do |id, name|
      		@notes[name] = name
		end
  	end

 	def search
		respond_to do |format|
			@result = []
			if params[:start] != nil && params[:end] != nil && params[:end] != ""
				if params[:start] != ""
					start_id = (Building.where(name: params[:start]))[0].id.to_i
				else
					lat_lng = cookies[:lat_lng].split("|")
					start_id = WelcomeHelper.nearest_building_id(lat_lng)
					@result.push(lat_lng)
				end
				end_id = (Building.where(name: params[:end]))[0].id.to_i
				@result = WelcomeHelper.find_route(start_id, end_id)
			end
			format.js {}
		end
	end

	def route
		raw_text = params[:text]
		@strs = raw_text.split("\n")
		UserMailer.directions_email(User.current_user, raw_text).deliver
	end

	#def select_home
		#building_id = params[:select_home]
		#node = Node.find(building_id)
		#node.latitude, node.longitude
	#end

end

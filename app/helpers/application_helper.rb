module ApplicationHelper
  def url_with_protocol(url)
    /^http/.match(url) ? url : "http://#{url}"
  end
  
  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    @id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: @id) do |builder|
      if association == :image_attachments
        render('shared/image_attachment_fields', f: builder)
      else
        render(association.to_s.singularize + "_fields", f: builder)
      end
    end
    link_to(name, '#', class: "add_fields", data: {id: @id, fields: fields.gsub("\n", "")})
  end
  
  def set_trips_counts(user)
    if user
    	@trips_incomplete_count = user.trips.where(state: "1").size
    	@trips_active_count = user.trips.where(state: "2").size
    	@trips_in_progress_count = user.trips.where(state: "6").size
    	@trips_complete_count = user.trips.where(state: "5").size
  	end
  end
end

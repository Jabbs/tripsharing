module TripsHelper
  
  def travel_text(group_dynamic_id, nationality_id, group_count_id, group_age_min, group_age_max)
    # GROUP_COUNT = {"1" => "1", "2" => "2", "3" => "3", "4" => "4", "5" => "5", 
    #   "6" => "6-10", "7" => "11-15", "8" => "16+", "9" => "tbd"}
    
    case group_count_id
    when "1"
      plural = false
      group_count_text = "<span class='dots'>#{Trip::GROUP_COUNT[group_count_id]}</span>"
    when "2", "3", "4", "5", "6", "7", "8", "10"
      plural = true
      group_count_text = "<span class='dots'>#{Trip::GROUP_COUNT[group_count_id]}</span>"
    when "9"
      plural = true
      group_count_text = "???"
    end
  
    nationality = User::NATIONALITIES[nationality_id].capitalize
    if nationality_id == "0"
      nationality_text = ""
    else
      nationality_text = "<span class='dots'>#{nationality}</span>"
    end

    case group_dynamic_id
    when "1"
      if plural == true
        group_text = " <span class='dots'><i class='fa fa-mars'></i> males</span> or <span class='dots'><i class='fa fa-venus'></i> females</span>"
      else
        group_text = " <span class='dots'><i class='fa fa-mars'></i> male</span> or <span class='dots'><i class='fa fa-venus'></i> female</span>"
      end
    when "2"
      plural == true ? group_text = " <span class='dots'><i class='fa fa-venus'></i> females</span>" : group_text = " <span class='dots'><i class='fa fa-venus'></i> female</span>"
    when "3"
      plural == true ? group_text = " <span class='dots'><i class='fa fa-mars'></i> males</span>" : group_text = " <span class='dots'><i class='fa fa-mars'></i> male</span>"
    when "4"
      plural == true ? group_text = " <span class='dots'><i class='fa fa-venus-mars'></i> couples</span>" : group_text = " <span class='dots'><i class='fa fa-venus-mars'></i> couple</span>"
    end
    
    if group_age_min == 0 && group_age_max == 0
      age_text = ""
    elsif group_age_min != 0 && group_age_max != 0
      age_text = " ages <span class='dots'>#{group_age_min}</span> to <span class='dots'>#{group_age_max}</span>"
    elsif group_age_min != 0 && group_age_max == 0
      age_text = " above the age of <span class='dots'>#{group_age_min}</span>"
    elsif group_age_min == 0 && group_age_max != 0
      age_text = " under the age of <span class='dots'>#{group_age_max}</span>"
    end
    
    status = "Seeking"
    logger.debug "Age text: #{group_text == nil}"
    if plural == true
      return "#{status} " + group_count_text + " travel companions," + " " + nationality_text + group_text + age_text + "."
    else
      return "#{status} a " + nationality_text + " travel companion, " + group_text + age_text + "."
    end

  end
  
  def age_text(group_age_min, group_age_max)
    if group_age_min == 0 && group_age_max == 0
      age_text = "Any"
    elsif group_age_min != 0 && group_age_max != 0
      age_text = "#{group_age_min}-#{group_age_max}"
    elsif group_age_min != 0 && group_age_max == 0
      age_text = "#{group_age_min} & up"
    elsif group_age_min == 0 && group_age_max != 0
      age_text = "18-#{group_age_max}"
    end
    return age_text
  end
  
  def get_day_text(departing_category)
    case departing_category
    when "1"
      day = Date.today.strftime('%-d')
    when "2"
      day = departing_category
    when "3"
      day = "this"
    else
      day = Trip::DEPARTINGS[departing_category].split.first.capitalize
    end
    day = "<span style='font-size:65%;'>" + day + "</span>"
    day
  end
  
  def time_flexibility_text(time_flexibility)
    case time_flexibility
    when "1"
      text = "No flexibility"
    when "2"
      text = "A little flexible"
    when "3"
      text = "Some flexibility"
    when "4"
      text = "Very flexible"
    end
    text
  end
  
  def get_month_text(departing_category)
    case departing_category
    when "1"
      month = Date.today.strftime('%B')
    when "2"
      month = ""
    when "3"
      month = "weekend"
    else
      month = Trip::DEPARTINGS[departing_category].split.last
    end
    month
  end
  
  def get_tab_class(query_param, link)
    if query_param == link
      return "on"
    else
      return ""
    end
  end
  
  def trip_image_landscape_big
    image_path = "trip_defaults/#{Trip::REGIONS[@trip.region].parameterize.tr("-", "_")}/" + @trip.default_image + ".jpg" 
    return image_tag(image_path, class: "img-responsive", style: "min-height:80px;", title: @trip.name).to_s
  end
  
  def trip_image_landscape_small(trip)
    if trip.image_attachments.any? && trip.image_attachments.first.image.landscape_small.file.exists? 
      image_path = trip.image_attachments.first.image.url(:landscape_small) 
    else 
      image_path = "trip_defaults/#{Trip::REGIONS[trip.region].parameterize.tr("-", "_")}/" + trip.default_image + "_small.jpg" 
    end 
    return image_tag(image_path, class: "img-responsive", style: "min-height:80px;", title: trip.name).to_s 
  end
end

module TripsHelper
  
  def travel_text(group_dynamic_id, nationality_id, group_count_id, group_age_min, group_age_max)
    # GROUP_COUNT = {"1" => "1", "2" => "2", "3" => "3", "4" => "4", "5" => "5", 
    #   "6" => "6-10", "7" => "11-15", "8" => "16+", "9" => "tbd"}
    
    case group_count_id
    when "1"
      plural = false
      group_count_text = "<span class='dots'>#{Trip::GROUP_COUNT[group_count_id]}</span>"
    when "2", "3", "4", "5", "6", "7", "8"
      plural = true
      group_count_text = "<span class='dots'>#{Trip::GROUP_COUNT[group_count_id]}</span>"
    when "9"
      plural = true
      group_count_text = ""
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
        group_text = " <span class='dots'>males</span> or <span class='dots'>females</span>"
      else
        group_text = " <span class='dots'>male</span> or <span class='dots'>female</span>"
      end
    when "2"
      plural == true ? group_text = " <span class='dots'>females</span>" : group_text = " <span class='dots'>female</span>"
    when "3"
      plural == true ? group_text = " <span class='dots'>males</span>" : group_text = " <span class='dots'>male</span>"
    when "4"
      plural == true ? group_text = " <span class='dots'>couples</span>" : group_text = " <span class='dots'>couple</span>"
    end
    
    if group_age_min == "any" && group_age_max == "any"
      age_text = ""
    elsif group_age_min != "any" && group_age_max != "any"
      age_text = "ages <span class='dots'>#{group_age_min}</span> to <span class='dots'>#{group_age_max}</span>"
    elsif group_age_min != "any" && group_age_max == "any"
      age_text = "above the age of <span class='dots'>#{group_age_min}</span>"
    elsif group_age_min == "any" && group_age_max != "any"
      age_text = "under the age of <span class='dots'>#{group_age_max}</span>"
    end
    
    if plural == true
      return "Seeking " + group_count_text + " travelers," + " " + nationality_text + group_text + " " + age_text + "."
    else
      return "Seeking a " + nationality_text + " traveler, " + group_text + " " + age_text + "."
    end

  end
end

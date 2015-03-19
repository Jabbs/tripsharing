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
    
    if group_age_min == "any" && group_age_max == "any"
      age_text = ""
    elsif group_age_min != "any" && group_age_max != "any"
      age_text = " ages <span class='dots'>#{group_age_min}</span> to <span class='dots'>#{group_age_max}</span>"
    elsif group_age_min != "any" && group_age_max == "any"
      age_text = " above the age of <span class='dots'>#{group_age_min}</span>"
    elsif group_age_min == "any" && group_age_max != "any"
      age_text = " under the age of <span class='dots'>#{group_age_max}</span>"
    end
    
    status = "<span class='dots-salmon'>Seeking</span>"
    
    if plural == true
      return "#{status} " + group_count_text + " travel companions," + " " + nationality_text + group_text + age_text + "."
    else
      return "#{status} a " + nationality_text + " travel companion, " + group_text + age_text + "."
    end

  end
  
  def age_text(group_age_min, group_age_max)
    if group_age_min == "any" && group_age_max == "any"
      age_text = "Any"
    elsif group_age_min != "any" && group_age_max != "any"
      age_text = "#{group_age_min}-#{group_age_max}"
    elsif group_age_min != "any" && group_age_max == "any"
      age_text = "#{group_age_min} & up"
    elsif group_age_min == "any" && group_age_max != "any"
      age_text = "18-#{group_age_max}"
    end
    return age_text
  end
  
  def spot_count(group_count_id)
    # GROUP_COUNT = {"1" => "1", "2" => "2", "3" => "3", "4" => "4", "5" => "5", 
    #   "6" => "6-10", "7" => "11-15", "8" => "16+", "9" => "tbd"}
    
    case group_count_id
    when "1"
      group_count_text = group_count_id + " SPOT"
    when "2", "3", "4", "5"
      group_count_text = group_count_id + " SPOTS"
    when "6"
      group_count_text = "10 SPOTS"
    when "7"
      group_count_text = "15 SPOTS"
    when "8"
      group_count_text = "UNLIMITTED"
    when "9"
      group_count_text = "TBD"
    end
    return group_count_text
  end
  
  def get_tab_class(query_param, link)
    if query_param == link
      return "on"
    else
      return ""
    end
  end
end

module TripsHelper
  
  def gender_nationality_text(group_dynamic_id, nationality_id)
    nationality = User::NATIONALITIES[nationality_id].capitalize
    if nationality_id == "0"
      nationality_text = "Any"
    else
      nationality_text = "<span class='dots'>#{nationality}</span>"
    end

    case group_dynamic_id
    when "1"
      group_text = " <span class='dots'>males</span> and <span class='dots'>females</span>"
    when "2"
      group_text = " <span class='dots'>females</span>"
    when "3"
      group_text = " <span class='dots'>males</span>"
    when "4"
      group_text = " <span class='dots'>couples</span>"
    end
    
    return nationality_text + group_text

  end
end

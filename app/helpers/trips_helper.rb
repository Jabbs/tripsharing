module TripsHelper
  
  def gender_text(group_dynamic)
    
    case group_dynamic
    when "1"
      "Any"
    when "2"
      "Female"
    when "3"
      "Male"
    when "4"
      "Couples"
    end

  end
end

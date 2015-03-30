module MessagesHelper
  
  def get_active_class(tab, name)
    if tab == name
      return "active"
    else
      return ""
    end
  end
end

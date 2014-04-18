module TimeAgo

  def ago(attribute = "created_at")

    if attributes[attribute].nil?
        return nil
    else
        seconds = Time.now - attributes[attribute]
    end

    case seconds
    when 0..3600
      ago = (seconds / 60.0).round.to_s + "m"
    when 3600..86400
      ago = (seconds / 3600.0).round.to_s + "h"
    else 
      ago = (seconds / 86400.0).round.to_s + "d"
    end

    ago
    
  end

end
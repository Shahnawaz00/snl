require 'gosu'

def choose_color(x, y)
    color = Gosu::Color::WHITE
    case x
    when 0 
      case y
       when 0
        color = Gosu::Color::RED
       when 1
        color = Gosu::Color::BLACK
       when 2 
        color =  Gosu::Color::YELLOW
       when 3 
        color = Gosu::Color::BLACK
       when 4
        color = Gosu::Color::FUCHSIA
       when 5
        color = Gosu::Color::BLACK
       when 6
        color = Gosu::Color::GREEN
       when 7 
        color =  Gosu::Color::BLACK
       when 8 
        color = Gosu::Color::CYAN
       when 9 
        color = Gosu::Color::BLACK
      end
    when 1   
        case y
        when 0
         color = Gosu::Color::BLACK
        when 1
         color = Gosu::Color::RED
        when 2 
         color =  Gosu::Color::BLACK
        when 3 
         color = Gosu::Color::YELLOW
        when 4
         color = Gosu::Color::BLACK
        when 5
         color = Gosu::Color::FUCHSIA
        when 6
         color = Gosu::Color::BLACK
        when 7 
         color =  Gosu::Color::GREEN
        when 8 
         color = Gosu::Color::BLACK
        when 9 
         color = Gosu::Color::CYAN
       end
    when 2
      case y
       when 0
        color = Gosu::Color::RED
       when 1
        color = Gosu::Color::BLACK
       when 2 
        color =  Gosu::Color::YELLOW
       when 3 
        color = Gosu::Color::BLACK
       when 4
        color = Gosu::Color::FUCHSIA
       when 5
        color = Gosu::Color::BLACK
       when 6
        color = Gosu::Color::GREEN
       when 7 
        color =  Gosu::Color::BLACK
       when 8 
        color = Gosu::Color::CYAN
       when 9 
        color = Gosu::Color::BLACK
      end
    when 3  
        case y
        when 0
         color = Gosu::Color::BLACK
        when 1
         color = Gosu::Color::RED
        when 2 
         color =  Gosu::Color::BLACK
        when 3 
         color = Gosu::Color::YELLOW
        when 4
         color = Gosu::Color::BLACK
        when 5
         color = Gosu::Color::FUCHSIA
        when 6
         color = Gosu::Color::BLACK
        when 7 
         color =  Gosu::Color::GREEN
        when 8 
         color = Gosu::Color::BLACK
        when 9 
         color = Gosu::Color::CYAN
       end
    when 4 
      case y
       when 0
        color = Gosu::Color::RED
       when 1
        color = Gosu::Color::BLACK
       when 2 
        color =  Gosu::Color::YELLOW
       when 3 
        color = Gosu::Color::BLACK
       when 4
        color = Gosu::Color::FUCHSIA
       when 5
        color = Gosu::Color::BLACK
       when 6
        color = Gosu::Color::GREEN
       when 7 
        color =  Gosu::Color::BLACK
       when 8 
        color = Gosu::Color::CYAN
       when 9 
        color = Gosu::Color::BLACK
      end
    when 5   
        case y
        when 0
         color = Gosu::Color::BLACK
        when 1
         color = Gosu::Color::RED
        when 2 
         color =  Gosu::Color::BLACK
        when 3 
         color = Gosu::Color::YELLOW
        when 4
         color = Gosu::Color::BLACK
        when 5
         color = Gosu::Color::FUCHSIA
        when 6
         color = Gosu::Color::BLACK
        when 7 
         color =  Gosu::Color::GREEN
        when 8 
         color = Gosu::Color::BLACK
        when 9 
         color = Gosu::Color::CYAN
       end
    when 6 
      case y
       when 0
        color = Gosu::Color::RED
       when 1
        color = Gosu::Color::BLACK
       when 2 
        color =  Gosu::Color::YELLOW
       when 3 
        color = Gosu::Color::BLACK
       when 4
        color = Gosu::Color::FUCHSIA
       when 5
        color = Gosu::Color::BLACK
       when 6
        color = Gosu::Color::GREEN
       when 7 
        color =  Gosu::Color::BLACK
       when 8 
        color = Gosu::Color::CYAN
       when 9 
        color = Gosu::Color::BLACK
      end
    when 7   
        case y
        when 0
         color = Gosu::Color::BLACK
        when 1
         color = Gosu::Color::RED
        when 2 
         color =  Gosu::Color::BLACK
        when 3 
         color = Gosu::Color::YELLOW
        when 4
         color = Gosu::Color::BLACK
        when 5
         color = Gosu::Color::FUCHSIA
        when 6
         color = Gosu::Color::BLACK
        when 7 
         color =  Gosu::Color::GREEN
        when 8 
         color = Gosu::Color::BLACK
        when 9 
         color = Gosu::Color::CYAN
       end
    when 8 
        case y
        when 0
         color = Gosu::Color::RED
        when 1
         color = Gosu::Color::BLACK
        when 2 
         color =  Gosu::Color::YELLOW
        when 3 
         color = Gosu::Color::BLACK
        when 4
         color = Gosu::Color::FUCHSIA
        when 5
         color = Gosu::Color::BLACK
        when 6
         color = Gosu::Color::GREEN
        when 7 
         color =  Gosu::Color::BLACK
        when 8 
         color = Gosu::Color::CYAN
        when 9 
         color = Gosu::Color::BLACK
       end
    when 9   
        case y
        when 0
         color = Gosu::Color::BLACK
        when 1
         color = Gosu::Color::RED
        when 2 
         color =  Gosu::Color::BLACK
        when 3 
         color = Gosu::Color::YELLOW
        when 4
         color = Gosu::Color::BLACK
        when 5
         color = Gosu::Color::FUCHSIA
        when 6
         color = Gosu::Color::BLACK
        when 7 
         color =  Gosu::Color::GREEN
        when 8 
         color = Gosu::Color::BLACK
        when 9 
         color = Gosu::Color::CYAN
       end
    end
    return color
end


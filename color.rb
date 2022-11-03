require 'gosu'

def choose_color(x, y)
    grey = Gosu::Color.argb(0xff_404042)
    red = Gosu::Color.argb(0xff_E31E25)
    orange = Gosu::Color.argb(0xff_EF7F1B)
    yellow = Gosu::Color.argb(0xff_FFEB00)
    lgreen = Gosu::Color.argb(0xff_6AA33A)
    dgreen = Gosu::Color.argb(0xff_5C8737)
    purple = Gosu::Color.argb(0xff_562581)
    pink = Gosu::Color.argb(0xff_C10075)
    lblue = Gosu::Color.argb(0xff_019BD7)
    dblue = Gosu::Color.argb(0xff_232D82)
    color = Gosu::Color::WHITE   # default color

    case x
    when 0 
      case y
       when 0
        color = red
       when 1
        color = grey
       when 2 
        color = orange
       when 3 
        color = grey
       when 4
        color = yellow
       when 5
        color = grey
       when 6
        color = lgreen
       when 7 
        color =  grey
       when 8 
        color = dgreen
       when 9 
        color = grey 
      end
    when 1   
        case y
        when 0
         color = dgreen
        when 1
         color = grey
        when 2 
         color = lgreen
        when 3 
         color = grey
        when 4
         color = yellow
        when 5
         color = grey
        when 6
         color = orange
        when 7 
         color = grey
        when 8 
         color = red
        when 9 
         color = grey
       end
    when 2
      case y
       when 0
        color = purple
       when 1
        color = grey
       when 2 
        color = red
       when 3 
        color = grey
       when 4
        color = orange
       when 5
        color = grey 
       when 6
        color = yellow 
       when 7 
        color = grey 
       when 8 
        color = lgreen 
       when 9 
        color = grey
      end
    when 3  
        case y
        when 0
         color = lgreen
        when 1
         color = grey 
        when 2 
         color = yellow 
        when 3 
         color = grey
        when 4
         color = orange
        when 5
         color = grey
        when 6
         color = red 
        when 7 
         color = grey 
        when 8 
         color = purple 
        when 9 
         color = grey
       end
    when 4 
      case y
       when 0
        color = pink
       when 1
        color = grey 
       when 2 
        color = purple
       when 3 
        color = grey 
       when 4
        color = red 
       when 5
        color = grey 
       when 6
        color =  orange
       when 7 
        color = grey 
       when 8 
        color = yellow 
       when 9 
        color = grey
      end
    when 5   
        case y
        when 0
         color = yellow
        when 1
         color = grey 
        when 2 
         color = orange 
        when 3 
         color = grey 
        when 4
         color = red 
        when 5
         color = grey
        when 6
         color = purple
        when 7 
         color = grey 
        when 8 
         color = pink
        when 9 
         color = grey
       end
    when 6 
      case y
       when 0
        color = lblue
       when 1
        color = grey 
       when 2 
        color = pink 
       when 3 
        color = grey 
       when 4
        color = purple
       when 5
        color = grey 
       when 6
        color = red 
       when 7 
        color = grey 
       when 8 
        color = orange 
       when 9 
        color = grey
      end
    when 7   
        case y
        when 0
         color = orange
        when 1
         color = grey 
        when 2 
         color = red  
        when 3 
         color =  grey 
        when 4
         color = purple 
        when 5
         color =  grey 
        when 6
         color = pink 
        when 7 
         color =  grey 
        when 8 
         color = lblue 
        when 9 
         color = grey
       end
    when 8 
        case y
        when 0
         color = dblue
        when 1
         color = grey 
        when 2 
         color = lblue
        when 3 
         color = grey
        when 4
         color = pink 
        when 5
         color = grey
        when 6
         color = purple
        when 7 
         color = grey 
        when 8 
         color =  red 
        when 9 
         color = grey
       end
    when 9   
        case y
        when 0
         color = red 
        when 1
         color = grey
        when 2 
         color = purple 
        when 3 
         color = grey 
        when 4
         color = pink 
        when 5
         color = grey 
        when 6
         color = lblue
        when 7 
         color = grey 
        when 8 
         color = dblue 
        when 9 
         color = grey
       end
    end
    return color
end


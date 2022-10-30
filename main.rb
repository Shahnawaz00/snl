require 'gosu'
require 'rubygems'
require './color'

# enumeration for z order 
module ZOrder
  BACKGROUND, MIDDLE, TOP = *0..2
end


# record for tiles 
class Tile 
    attr_accessor :number, :snl, :snl_goto, :dimension, :color

    def initialize(number,snl, snl_goto, x_loc, y_loc, color)
        @number = number      #time number
        @snl = snl            #if snake or ladder is there on the tile
        @snl_goto = snl_goto  #go to tile number if snake or ladder is there
        @dimension = Dimension.new(x_loc, y_loc, x_loc + 100, y_loc + 100)  #dimension of the tile
        @color =  color  #color of the tile
    end 
end

# record for dimensions of any image or shape 
class Dimension
	attr_accessor :leftX, :topY, :rightX, :bottomY

	def initialize(leftX, topY, rightX, bottomY)
		@leftX = leftX  
		@topY = topY
		@rightX = rightX
		@bottomY = bottomY
	end
end

# record for player pieces 
class Piece 
    attr_accessor :image, :dimension, :number, :goto_number, :inOrigin

    def initialize(image, leftX, topY, number)
        @image = Gosu::Image.new(image)    #image of the piece
        @dimension =  Dimension.new(leftX, topY, leftX + @image.width(), topY + @image.height()) #dimension of the piece
        @number = number    # tile number that the piece is on 
        @goto_number = nil  # tile number that the piece is going to because of snl
        @inOrigin = true    #if the piece is in the original position
    end
end

# record for all the dice numbers
class Dice 
    attr_accessor :dice_0, :dice_1, :dice_2, :dice_3, :dice_4, :dice_5, :dice_6, :dimension, :dimension_0

    def initialize()
        @dice_0 = Gosu::Image.new("images/dice_0.png")
        @dice_1 = Gosu::Image.new("images/dice_1.png")
        @dice_2 = Gosu::Image.new("images/dice_2.png")
        @dice_3 = Gosu::Image.new("images/dice_3.png")
        @dice_4 = Gosu::Image.new("images/dice_4.png")
        @dice_5 = Gosu::Image.new("images/dice_5.png")
        @dice_6 = Gosu::Image.new("images/dice_6.png")
        @dimension = Dimension.new(1300, 780, 1300 * 3, 780 * 3)  #dimension of the dice
        @dimension_0 = Dimension.new(1130, 610, 1130 + @dice_0.width(), 610 + @dice_0.height()) #dimension of the dice 0
    end
end

# functions to run during initialize 

# make each tile 
def make_tiles(board, snl_array, snl_goto_array, x_loc, y_loc, tile_number, row_index, column_index)
    # choose color of tile
    color = choose_color(row_index, column_index)

    # check if snake or ladder is there on the tile 
    snl = false
    snl_goto = nil
    if snl_array.include?(tile_number)
        snl = true
        snl_goto = snl_goto_array[snl_array.index(tile_number)]
    end

    tile = Tile.new(tile_number ,snl, snl_goto, x_loc, y_loc, color)
    board[row_index][column_index] = tile 
 
end

# make the array for the board 
def board_array(board)
    snl_array =      [94, 84, 68, 47, 32, 22, 10, 23, 33, 45, 79]  # tile numbers where snake or ladder is present
    snl_goto_array = [ 88, 62, 50, 3, 14, 4, 29, 42, 52, 75, 81]  # tile numbers where snake or ladder goes to

    row_index = 0
    tile_number = 1 # track tile number
    y_loc = 900 # to change the location of the tile, 900 to start from bottom
    # make 2d array 
    while(row_index < 10)
        board[row_index] = []
        column_index = 0
        if row_index % 2 == 0  # alternate rows to start tile from left or right
            x_loc = 0
            while(column_index < 10)
                make_tiles(board, snl_array, snl_goto_array, x_loc, y_loc, tile_number, row_index, column_index)
                column_index += 1
                tile_number += 1
                x_loc += 100     
            end
        else
            x_loc = 900
            while(column_index < 10)
                make_tiles(board, snl_array, snl_goto_array, x_loc, y_loc, tile_number, row_index, column_index)
                column_index += 1
                tile_number += 1
                x_loc -= 100
            end
        end
        y_loc -= 100
        row_index += 1
    end
end

def make_player_pieces(player_pieces)
    i = 0
    x_loc = 0  # to change the origin location of the piece 
    while i < 4 # hard coded value to make pieces for 4 players
        # hold the number of pieces per player
        pieces = []
        player = i + 1
        n = 0
        while n < 1  # hard coded value to make 1 piece per player
            piece = Piece.new("images/player#{player}.png", 1050 + (n * 100), 100 + x_loc,0)
            pieces << piece
            n += 1
        end
        player_pieces << pieces  # add the pieces to the player_pieces array
        i += 1
        x_loc += 200
   end
end
   
class GameWindow < Gosu::Window

# initialize 
  def initialize
    super(1500, 1000, false)
    self.caption = "Snakes & Ladder"

    @number_text = Gosu::Font.new(20)

    @start = false
    @time = 0

    # dice 
    @dice = Dice.new()
    @dice_number = 0       #current dice number
    @roll_dice = false     # if dice is clicked, this variable is used to trigger dice rolling 

    # number of players playing 
    @player_number = 0
    # track current player 
    @player_turn = 1

    # player pieces 
    @player_pieces = []    #number of pieces per player
    @player_moving = false    #if any player is currently moving their piece 

    @move_piece_up = false    # used to trigger function that moves the piece up
    @move_piece_down = false  # used to trigger function that moves the piece down
    @move_piece_left = false  # used to trigger function that moves the piece left
    @move_piece_right = false  # used to trigger function that moves the piece right
    @moving_x_time = 0  # how long the piece should be moving in x direction
    @moving_y_time = 0  # how long the piece should be moving in y direction
    @moving_piece = 0   # which piece number of the player is currently moving 
    @moving_player = 0   # which player is currently moving

    @snl_trigger = false  # used to trigger function that will move the piece if tile has snake or ladder
    @snl_moving = false  #  this triggers the actual movement of the piece to the new tile

    @board_leftX = 0  #  x coordinate of the the tile to which the piece will move towards 
    @board_topY = 0  #  y coordinate of the the tile to which the piece will move towards
    @player_leftX = 0   # x coordinate of the current piece that is set to move
    @player_topY = 0  # y coordinate of the current piece that is set to move

    # background song
    @song = Gosu::Song.new("sounds/background.mp3")
    @song.play

    # samples 
    @fail = Gosu::Sample.new("sounds/fail.mp3")
    @success = Gosu::Sample.new("sounds/success.mp3")
    @rolling = Gosu::Sample.new("sounds/rolling.mp3")
    @moving = Gosu::Sample.new("sounds/moving.mp3")

    # snake and ladder images 
    @board_image = Gosu::Image.new("images/board2.jpg")
    @snake_1 = Gosu::Image.new("images/snake1.png")
    @snake_2 = Gosu::Image.new("images/snake2.png")

    @ladder_1 = Gosu::Image.new("images/ladder1.png")
    @ladder_2 = Gosu::Image.new("images/ladder2.png")
    @ladder_3 = Gosu::Image.new("images/ladder3.png")
    @ladder_4 = Gosu::Image.new("images/ladder4.png")
    
    # make player pieces
    make_player_pieces(@player_pieces)

    # main board array 
    @board = []
    board_array(@board)
   
  end 

#   draw board 
  def draw_board 
    # @board_image.draw(0, 0, 0)
    row_index = 0
    while row_index < 10

            column_index = 0
            while column_index < 10
                number = @board[row_index][column_index].number
                x_loc = @board[row_index][column_index].dimension.leftX
                y_loc = @board[row_index][column_index].dimension.topY
                color = @board[row_index][column_index].color
                Gosu.draw_rect(x_loc,y_loc, 100, 100, color, ZOrder::BACKGROUND, mode=:default)     
                if color == Gosu::Color::BLACK
                    @number_text.draw_text(number, x_loc + 10, y_loc + 10, ZOrder::BACKGROUND, 1.0, 1.0, Gosu::Color::WHITE)
                else 
                    @number_text.draw_text(number, x_loc + 10, y_loc + 10, ZOrder::BACKGROUND, 1.0, 1.0, Gosu::Color::BLACK)
                end
                column_index += 1
            end

        row_index += 1
    end

    # @board do |row|
    #     row do |tile|
    #             number = tile.number
    #             x_loc = tile.dimension.leftX
    #             y_loc = tile.dimension.topY
    #             color = tile.color
    #             Gosu.draw_rect(x_loc,y_loc, 100, 100, color, ZOrder::BACKGROUND, mode=:default)     
    #             if color == Gosu::Color::BLACK
    #                 @number_text.draw_text(number, x_loc + 10, y_loc + 10, ZOrder::BACKGROUND, 1.0, 1.0, Gosu::Color::WHITE)
    #             else 
    #                 @number_text.draw_text(number, x_loc + 10, y_loc + 10, ZOrder::BACKGROUND, 1.0, 1.0, Gosu::Color::BLACK)
    #             end
    #     end
    # end
  end
#   choose number of players 
  def choose_players
    w_dim = 1500 / 3
    h_dim = 1000 / 3
    Gosu.draw_rect(w_dim, h_dim, w_dim, h_dim, Gosu::Color::BLUE, ZOrder::MIDDLE, mode=:default)
    @number_text.draw_text(" NUMBER OF PLAYERS", w_dim + 100, h_dim + 10, ZOrder::TOP, 1.5, 1.5, Gosu::Color::WHITE )
    
    # player 1 
    Gosu.draw_rect(w_dim + 90, h_dim + 60, 130, 70, Gosu::Color::WHITE, ZOrder::MIDDLE, mode=:default)
    @number_text.draw_text("1", w_dim + 150, h_dim + 85, ZOrder::TOP, 1.5, 1.5, Gosu::Color::BLUE)
    # player 2 
    Gosu.draw_rect(w_dim + 280, h_dim + 60, 130, 70, Gosu::Color::WHITE, ZOrder::MIDDLE, mode=:default)
    @number_text.draw_text("2", w_dim + 340, h_dim + 85, ZOrder::TOP, 1.5, 1.5, Gosu::Color::BLUE)
    # player 3 
    Gosu.draw_rect(w_dim + 90, h_dim + 200, 130, 70, Gosu::Color::WHITE, ZOrder::MIDDLE, mode=:default)
    @number_text.draw_text("3", w_dim + 150, h_dim + 225, ZOrder::TOP, 1.5, 1.5, Gosu::Color::BLUE)
    # player 4 
    Gosu.draw_rect(w_dim + 280, h_dim + 200, 130, 70, Gosu::Color::WHITE, ZOrder::MIDDLE, mode=:default)
    @number_text.draw_text("4", w_dim + 340, h_dim + 225, ZOrder::TOP, 1.5, 1.5, Gosu::Color::BLUE)
    
  end

#   draw player sections 
  
  def player_sections
    i = 0
    x_loc = 0
    while i < @player_number
        if i % 2 == 1  # for alternate color sections
           Gosu.draw_rect(1000, 0 + x_loc, 500, 200, Gosu::Color::WHITE, ZOrder::MIDDLE, mode=:default)  # player section  
           @number_text.draw_text("Player #{i + 1}", 1050, 20 + x_loc, ZOrder::TOP, 1.5, 1.5, Gosu::Color::BLACK)  # player number
        else 
            Gosu.draw_rect(1000, 0 + x_loc, 500, 200, Gosu::Color::GRAY, ZOrder::MIDDLE, mode=:default)
            @number_text.draw_text("Player #{i + 1}", 1050, 20 + x_loc, ZOrder::TOP, 1.5, 1.5, Gosu::Color::BLACK)
        end
        # place pieces 
        n = 0
        while n < 1
            @player_pieces[i][n].image.draw(@player_pieces[i][n].dimension.leftX, @player_pieces[i][n].dimension.topY, ZOrder::TOP ) 
            n += 1
        end
        i += 1
        x_loc += 200
   end

  end 

#   draw snakes 
  def draw_snakes_ladders
    # snake 1
    @snake_1.draw(500, 500, ZOrder::MIDDLE, 1, 1)
    @snake_1.draw(0, 200, ZOrder::MIDDLE, 2, 2)
    @snake_1.draw(0, 0, ZOrder::MIDDLE, 1, 1)
    # snake 2 (flipped)
    @snake_2.draw(600, 200, ZOrder::MIDDLE, 1, 1)
    @snake_2.draw(600, 0, ZOrder::MIDDLE, 0.5, 0.5)
    @snake_2.draw(0, 600, ZOrder::MIDDLE, 1, 1)

    # ladder 1 
    @ladder_2.draw(40, 390, ZOrder::MIDDLE, 0.13, 0.13)
    @ladder_2.draw(730, 570, ZOrder::MIDDLE, 0.13, 0.13)
    @ladder_2.draw(0, 30, ZOrder::MIDDLE, 0.08, 0.08)

    @ladder_1.draw(260, 0, ZOrder::MIDDLE, 0.18, 0.18)
    @ladder_1.draw(630, 270, ZOrder::MIDDLE, 0.13, 0.13)
  end
 

#   draw dice 
  def draw_dice
    Gosu.draw_rect(1000, 800, 500, 200, Gosu::Color::BLACK, ZOrder::TOP, mode=:default)
    @number_text.draw_text("Player #{@player_turn}'s turn", 1050, 860, ZOrder::TOP, 2, 2, Gosu::Color::WHITE)
    
    case @dice_number
    when 0
        @dice.dice_0.draw(@dice.dimension_0.leftX, @dice.dimension_0.topY, ZOrder::TOP, 3, 3)
    when 1
        @dice.dice_1.draw(@dice.dimension.leftX, @dice.dimension.topY, ZOrder::TOP, 3, 3)
    when 2
        @dice.dice_2.draw(@dice.dimension.leftX, @dice.dimension.topY, ZOrder::TOP, 3, 3)
    when 3
        @dice.dice_3.draw(@dice.dimension.leftX, @dice.dimension.topY, ZOrder::TOP, 3, 3)
    when 4
        @dice.dice_4.draw(@dice.dimension.leftX, @dice.dimension.topY, ZOrder::TOP, 3, 3)
    when 5
        @dice.dice_5.draw(@dice.dimension.leftX, @dice.dimension.topY, ZOrder::TOP, 3, 3)
    when 6
        @dice.dice_6.draw(@dice.dimension.leftX, @dice.dimension.topY, ZOrder::TOP, 3, 3)
    end
    
  end

#   draw music button 
    def draw_music
        Gosu.draw_rect(1380, 20, 100, 40, Gosu::Color::BLACK, ZOrder::TOP, mode=:default)
        if @song.playing? 
            Gosu.draw_rect(1480, 20, 40, 40, Gosu::Color::GREEN, ZOrder::TOP, mode=:default)
            @number_text.draw_text("Music: ON", 1385, 30, ZOrder::TOP, 1, 1, Gosu::Color::WHITE)
        else 
            Gosu.draw_rect(1480, 20, 40, 40, Gosu::Color::RED, ZOrder::TOP, mode=:default)
            @number_text.draw_text("Music: OFF", 1385, 30, ZOrder::TOP, 1, 1, Gosu::Color::WHITE) 
        end
    end

    # draw new position of player piece after snl 
    def draw_snl_position(i)
        
    end

  def update
    if @roll_dice 
       if Gosu.milliseconds - @time < 1000
            @dice_number = rand(1..6)
       else
            @roll_dice = false
            i = 0
            while i < @player_pieces[@player_turn - 1].length
                if @player_pieces[@player_turn - 1][i].inOrigin == true && @dice_number != 6
                    @player_turn == @player_number ? @player_turn = 1 : @player_turn += 1
                    @dice_number = 0
                    @fail.play
                else
                    @player_moving = true 
                    @success.play
                end
                i += 1
            
         end
    end
  end


    if !@song.playing? && !@song.paused?
        @song.play
    end

    if @move_piece_right
        
        if Gosu.milliseconds - @time <  @moving_x_time
          @player_pieces[@moving_player][@moving_piece].dimension.leftX += 5
          @player_moving = true
        else 
            @player_pieces[@moving_player][@moving_piece].dimension.leftX = @board_leftX
            @move_piece_right = false
            @player_moving = false
            if @moving_x_time > @moving_y_time
                @snl_moving = @snl_trigger
                @snl_trigger = false
                @moving_x_time = 0
                @moving_y_time = 0

            end
        end
    end
    if @move_piece_left
       
        if Gosu.milliseconds - @time < @moving_x_time
            @player_pieces[@moving_player][@moving_piece].dimension.leftX -= 5
            @player_moving = true
        else
            @player_pieces[@moving_player][@moving_piece].dimension.leftX = @board_leftX
            @move_piece_left = false
            @player_moving = false
            if @moving_x_time > @moving_y_time
                @snl_moving = @snl_trigger
                @snl_trigger = false
                @moving_x_time = 0
                @moving_y_time = 0

            end
        end
    end

    if @move_piece_up
        if Gosu.milliseconds - @time < @moving_y_time
            @player_pieces[@moving_player][@moving_piece].dimension.topY -= 5
            @player_moving = false
        else
            @player_pieces[@moving_player][@moving_piece].dimension.topY = @board_topY
            @move_piece_up = false
            @player_moving = false
            if @moving_x_time < @moving_y_time
                @snl_moving = @snl_trigger
                @snl_trigger = false
                @moving_x_time = 0
                @moving_y_time = 0

            end
        end

    end

    if @move_piece_down
        
        if Gosu.milliseconds - @time < @moving_y_time
            @player_pieces[@moving_player][@moving_piece].dimension.topY += 5
            @player_moving = true
        else
            @player_pieces[@moving_player][@moving_piece].dimension.topY = @board_topY
            @move_piece_down = false
            @player_moving = false
            if @moving_x_time < @moving_y_time
                @snl_moving = @snl_trigger
                @snl_trigger = false
                @moving_x_time = 0
                @moving_y_time = 0
            end
        end

    end
    
    if @snl_moving
      
        number = @player_pieces[@moving_player][@moving_piece].number    
        
        row_index = 0
        while row_index < 10
        col_index = 0
        while col_index < 10
         if @board[row_index][col_index].number  == number

            @board_leftX = @board[row_index][col_index].dimension.leftX + 25
            @board_topY = @board[row_index][col_index].dimension.topY + 25
            @player_leftX = @player_pieces[@moving_player][@moving_piece].dimension.leftX
            @player_topY = @player_pieces[@moving_player][@moving_piece].dimension.topY

            if @player_leftX < @board_leftX
                @time = Gosu.milliseconds
                difference = @board_leftX - @player_leftX
                @moving_x_time = difference.to_f / 265 * 1000
                @move_piece_right = true 
                
            elsif @player_leftX > @board_leftX
                @time = Gosu.milliseconds
                difference = @player_leftX - @board_leftX
                @moving_x_time = difference.to_f / 265 * 1000
                @move_piece_left = true
            end

            if @player_topY < @board_topY
                @time = Gosu.milliseconds
                difference = @board_topY - @player_topY
                @moving_y_time = difference.to_f / 265 * 1000
                @move_piece_down = true

            elsif @player_topY > @board_topY
                @time = Gosu.milliseconds
                difference = @player_topY - @board_topY
                @moving_y_time = difference.to_f / 265 * 1000
                @move_piece_up = true
            end

            @player_pieces[@moving_player][@moving_piece].dimension.rightX = @board[row_index][col_index].dimension.rightX+ 25
            @player_pieces[@moving_player][@moving_piece].dimension.bottomY = @board[row_index][col_index].dimension.bottomY + 25
         end
     
             col_index += 1
         end
         row_index += 1
        end
        if @moving_x_time == 0 && @moving_y_time == 0
            @snl_moving = false
            puts "snl moving false"
        end
    
    end

  end


  def draw
    
    if @start 
        if @player_number != 0
            draw_board() 
            player_sections()
            draw_dice()
            draw_snakes_ladders()
            draw_music()
        else 
            choose_players() 

        end
    elsif !@start
        @number_text.draw_text("CLICK ANYWHERE TO START", 350, 450, ZOrder::BACKGROUND, 3.0, 3.0, Gosu::Color::WHITE)
    end
  end

  def area_clicked(leftX, topY, rightX, bottomY)
    if mouse_x > leftX && mouse_x < rightX && mouse_y > topY && mouse_y < bottomY
        return true
    else
        return false
    end
   end 

  def needs_cursor?; true; end

  def button_down(id)
      case id
      when Gosu::MsLeft
        # check if started 
        if area_clicked(0, 0, 1500, 1000)
            @start = true
        end
        # check number of players chosen 
        if @player_number == 0 && @start
            if area_clicked(590, 400, 720, 460)
                @player_number = 1
            elsif area_clicked(780, 400, 910, 460)
                @player_number = 2
            elsif area_clicked(590, 540, 720, 600)
                @player_number = 3
            elsif area_clicked(780, 540, 910, 600)
                @player_number = 4
            end
        end

        # check if dice is clicked 
        if area_clicked(@dice.dimension.leftX,@dice.dimension.topY, @dice.dimension.rightX,@dice.dimension.bottomY) && @player_number != 0
            
            # roll dice only if its no ones turn 
            if !@player_moving
                
                @time = Gosu.milliseconds
                @roll_dice = true
                @rolling.play

            end
            
        end

        # move pieces 
       
        if @player_pieces.length != 0 
            i = 0
            while i < @player_pieces[@player_turn - 1].length
              if area_clicked(@player_pieces[@player_turn - 1][i].dimension.leftX, @player_pieces[@player_turn - 1][i].dimension.topY, @player_pieces[@player_turn - 1][i].dimension.rightX, @player_pieces[@player_turn - 1][i].dimension.bottomY) && @player_moving
                if @player_pieces[@player_turn - 1][i].inOrigin == false || @dice_number == 6 
                    @moving_piece = i
                    @moving_player = @player_turn - 1
                    @player_pieces[@player_turn - 1][i].number += @dice_number
                    number = @player_pieces[@player_turn - 1][i].number
                    row_index = 0
                    while row_index < 10
                      col_index = 0
                      while col_index < 10
                       if @board[row_index][col_index].number  == number
       
       
                           @board_leftX = @board[row_index][col_index].dimension.leftX + 25
                           @board_topY = @board[row_index][col_index].dimension.topY + 25
                           @player_leftX = @player_pieces[@player_turn - 1][i].dimension.leftX 
                           @player_topY = @player_pieces[@player_turn - 1][i].dimension.topY
                           if @player_leftX < @board_leftX
                               @time = Gosu.milliseconds
                               difference = @board_leftX - @player_leftX
                               @moving_x_time = difference.to_f / 265 * 1000
                               @move_piece_right = true 
                               
       
                           elsif @player_leftX > @board_leftX
                               @time = Gosu.milliseconds
                               difference = @player_leftX - @board_leftX
                               @moving_x_time = difference.to_f / 265 * 1000
                               @move_piece_left = true
                           end
       
                           if @player_topY < @board_topY
                               @time = Gosu.milliseconds
                               difference = @board_topY - @player_topY
                               @moving_y_time = difference.to_f / 265 * 1000
                               @move_piece_down = true
       
                           elsif @player_topY > @board_topY
                               @time = Gosu.milliseconds
                               difference = @player_topY - @board_topY
                               @moving_y_time = difference.to_f / 265 * 1000
                               @move_piece_up = true
                           end
  
                           @player_pieces[@player_turn - 1][i].dimension.rightX = @board[row_index][col_index].dimension.rightX+ 25
                           @player_pieces[@player_turn - 1][i].dimension.bottomY = @board[row_index][col_index].dimension.bottomY + 25
                       
       
                           if @board[row_index][col_index].snl == true 
                               
                               @player_pieces[@player_turn - 1][i].number = @board[row_index][col_index].snl_goto 
                               @time = Gosu.milliseconds
                               @snl_trigger = true
                               puts "snl #{@snl_trigger}" 
                               puts @player_pieces[@player_turn - 1][i].number
                           end
       
                           @player_pieces[@player_turn - 1][i].inOrigin = false
                           @moving.play
                           
            
                           if @dice_number != 6
                               @player_turn == @player_number ? @player_turn = 1 : @player_turn += 1   
                           end
                           @player_moving = false
                           @dice_number = 0
           
                           end
                   
                           col_index += 1
                       end
                       row_index += 1
                    end
                    
                else 
                    @player_turn == @player_number ? @player_turn = 1 : @player_turn += 1
                    @player_moving = false
                end
              end
              i += 1
           end
        end

        # check if music is clicked
        if area_clicked(1380, 20, 1500, 60)
            @song.playing? ? @song.pause : @song.play
        end

      end
  end
end

GameWindow.new.show if __FILE__ == $0


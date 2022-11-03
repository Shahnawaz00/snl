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
    snl_goto_array = [88, 62, 50, 3, 14, 4, 29, 42, 52, 75, 81]  # tile numbers where snake or ladder goes to

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
    @moving_piece = nil   # which piece number of the player is currently moving 
    @moving_player = 0   # which player is currently moving

    @snl_trigger = false  # used to trigger function that will move the piece if tile has snake or ladder
    @snl_moving = false  #  this triggers the actual movement of the piece to the new tile

    @tile_leftX = 0  #  x coordinate of the the tile to which the piece will move towards 
    @tile_topY = 0  #  y coordinate of the the tile to which the piece will move towards
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

    # board wood
    @wood = Gosu::Image.new("images/backwood.png")
    
    # make player pieces
    make_player_pieces(@player_pieces)

    # main board array 
    @board = []
    board_array(@board)
   
  end 
  
#   draw functions 

#   draw the board
  def draw_board 
    @wood.draw(1000, 0, ZOrder::MIDDLE)  # side wood background
    # @board_image.draw(0, 0, 0)
    @board.each do |row|
        row.each do |tile|
                number = tile.number
                x_loc = tile.dimension.leftX
                y_loc = tile.dimension.topY
                color = tile.color
                Gosu.draw_rect(x_loc,y_loc, 100, 100, color, ZOrder::BACKGROUND, mode=:default)      

                # draw the number on the tile with black color on yellow for better visibility, and some padding from the corners 
                if color == Gosu::Color.argb(0xff_FFEB00)
                    @number_text.draw_text(number, x_loc + 10, y_loc + 10, ZOrder::BACKGROUND, 1.0, 1.0, Gosu::Color::BLACK)
                else 
                    @number_text.draw_text(number, x_loc + 10, y_loc + 10, ZOrder::BACKGROUND, 1.0, 1.0, Gosu::Color::WHITE)
                end
        end
    end
  end

#   choose number of players 
  def choose_players
    w_dim = 1500 / 3  # width of the window divided by 3
    h_dim = 1000 / 3  # height of the window divided by 3
    Gosu.draw_rect(w_dim, h_dim, w_dim, h_dim, Gosu::Color.argb(0xff_232D82), ZOrder::MIDDLE, mode=:default)  # draw a blue rectangle in the middle of the window
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

  
#   draw sections for each player with their pieces 
  def player_sections
    i = 0
    y_loc = 0   # y coordinate of the player section, will be incremented for each player so it moves down 
    while i < @player_number
        if i % 2 == 1  # for alternate color sections
           @number_text.draw_text("Player #{i + 1}", 1050, 20 + y_loc, ZOrder::TOP, 1.5, 1.5, Gosu::Color::BLACK)  # player number
        else 
            @number_text.draw_text("Player #{i + 1}", 1050, 20 + y_loc, ZOrder::TOP, 1.5, 1.5, Gosu::Color::BLACK)
        end
        i += 1
        y_loc += 200
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
    @ladder_1.draw(260, 0, ZOrder::MIDDLE, 0.18, 0.18)
    @ladder_1.draw(630, 270, ZOrder::MIDDLE, 0.13, 0.13)
    # ladder 2 (flipped)
    @ladder_2.draw(40, 390, ZOrder::MIDDLE, 0.13, 0.13)
    @ladder_2.draw(730, 570, ZOrder::MIDDLE, 0.13, 0.13)
    @ladder_2.draw(0, 30, ZOrder::MIDDLE, 0.08, 0.08)
  end
 

#   draw dice 
  def draw_dice
    @number_text.draw_text("Player #{@player_turn}'s turn", 1050, 860, ZOrder::TOP, 2, 2, Gosu::Color::BLACK) # show the player's turn
    
    # draw the dice image based on the number currently rolled ------ currently using case statement to iterate through all dice numbers, but if variable can be inserted into another one (like #{} with string) then it can be simplified 
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

   # draw music button 
  def draw_music 
       Gosu.draw_rect(1380, 20, 100, 40, Gosu::Color::BLACK, ZOrder::TOP, mode=:default) # draw a black rectangle for the music button
       if @song.playing?  # if the song is playing, show ON with green bar
           Gosu.draw_rect(1480, 20, 40, 40, Gosu::Color::GREEN, ZOrder::TOP, mode=:default)
           @number_text.draw_text("Music: ON", 1385, 30, ZOrder::TOP, 1, 1, Gosu::Color::WHITE)
       else  # if the song is not playing, show OFF with red bar
           Gosu.draw_rect(1480, 20, 40, 40, Gosu::Color::RED, ZOrder::TOP, mode=:default)
           @number_text.draw_text("Music: OFF", 1385, 30, ZOrder::TOP, 1, 1, Gosu::Color::WHITE) 
       end
  end   

   # draw the pieces based on dimensions assigned 
  def draw_player_pieces
       @player_pieces.each do |player|
           if @player_pieces.index(player) < @player_number  # only draw the pieces for the number of players
              player.each do |piece|
                  piece.image.draw(piece.dimension.leftX, piece.dimension.topY, ZOrder::TOP)
              end
            end
       end
  end

#   update functions 

  #on dice click
  def dice_roll
    if @roll_dice   # checks if dice roll has been triggered
        #rolls the dice for 1 second and assigns a random number to the dice 
        if Gosu.milliseconds - @time < 1000
             @dice_number = rand(1..6)
        else
            # after 1 second has passed 
            @roll_dice = false  # stops the dice roll

        # insert code here to check if the player has won/about to win
            @player_pieces[@player_turn -1].each do |piece|  # iterates through the pieces of the current player 
                # if the piece is in the origin and the dice number is not 6, then the turn is skipped. else the player can move their piece 
                if piece.inOrigin == true && @dice_number != 6  
                    @player_turn == @player_number ? @player_turn = 1 : @player_turn += 1
                    @dice_number = 0
                    @fail.play
                else  
                    @player_moving = true 
                    @success.play
                end
            end
        end
      end
  end

  #   play song on loop 
  def loop_song 
    if !@song.playing? && !@song.paused? # if the song is not playing and not paused either, play the song again
        @song.play
    end
  end

#   move pieces 
  def move_pieces

    # move piece towards the right side of the board
    if @move_piece_right
        if Gosu.milliseconds - @time <  @moving_x_time  # keep moving piece for the set time 
          @moving_piece.dimension.leftX += 5  # add to the x coordinate of the piece so it moves to the right
          @player_moving = true  # keeps the player moving until the piece has reached the destination, this prevents dice from being rolled
        else 
            # once piece has moved for the set time
            @moving_piece.dimension.leftX = @tile_leftX   # set the piece's dimension to the destination tile to confirm its on the desired spot
            @move_piece_right = false  #remove the move piece right trigger
            @player_moving = false  # ensure player is not moving anymore so dice can be rolled 

            # check which direction the piece will move for a longer time
            # if x is moving for longer, then trigger snl movement - this prevents snl movement from being triggered too early (before the piece has reached the initial tile), else  the piece would move directly to the snl tile
            if @moving_x_time > @moving_y_time  
                @snl_moving = @snl_trigger  # trigger snl movement if tile is a snl tile
                @snl_trigger = false  # reset the snl trigger
            end
            @moving_x_time = 0  # reset the moving x time so it can be reused for the next piece movement
        end
    end

    # move piece towards the left side of the board
    if @move_piece_left
        #same logic as above
        if Gosu.milliseconds - @time < @moving_x_time
            @moving_piece.dimension.leftX -= 5
            @player_moving = true
            puts @moving_piece.number
        else
            @moving_piece.dimension.leftX = @tile_leftX
            @move_piece_left = false
            @player_moving = false
            if @moving_x_time > @moving_y_time
                @snl_moving = @snl_trigger
                @snl_trigger = false
            end
            @moving_x_time = 0
        end
    end

    # move piece towards the top of the board
    if @move_piece_up
        #same logic as above
        if Gosu.milliseconds - @time < @moving_y_time
            @moving_piece.dimension.topY -= 5
            @player_moving = false
        else
            @moving_piece.dimension.topY = @tile_topY
            @move_piece_up = false
            @player_moving = false
            if @moving_x_time < @moving_y_time
                @snl_moving = @snl_trigger
                @snl_trigger = false
            end
            @moving_y_time = 0
        end

    end

    # move piece towards the bottom of the board
    if @move_piece_down
        # same logic as above 
        if Gosu.milliseconds - @time < @moving_y_time
            @moving_piece.dimension.topY += 5
            @player_moving = true
        else
            @moving_piece.dimension.topY = @tile_topY
            @move_piece_down = false
            @player_moving = false
            if @moving_x_time < @moving_y_time
                @snl_moving = @snl_trigger
                @snl_trigger = false
            end
            @moving_y_time = 0
        end

    end
  end

  def set_piece_destination(tile, piece)
     # set variables for the destination tile and piece dimensions 
     @tile_leftX = tile.dimension.leftX + 25  
     @tile_topY = tile.dimension.topY + 25
     @player_leftX = piece.dimension.leftX
     @player_topY = piece.dimension.topY

     # check if piece dimension is greater or less than destination tile to determine which direction the piece will move
     if @player_leftX < @tile_leftX
         @time = Gosu.milliseconds
         difference = @tile_leftX - @player_leftX  
         @moving_x_time = difference.to_f / 265 * 1000  # set the moving time to the time it will take for the piece to reach the destination tile on the x axis
         @move_piece_right = true  # trigger piece movement 
         
     elsif @player_leftX > @tile_leftX
         # same logic as above
         @time = Gosu.milliseconds
         difference = @player_leftX - @tile_leftX
         @moving_x_time = difference.to_f / 265 * 1000
         @move_piece_left = true
   end

     # same logic as above for the y axis
     if @player_topY < @tile_topY
         @time = Gosu.milliseconds
         difference = @tile_topY - @player_topY
         @moving_y_time = difference.to_f / 265 * 1000
         @move_piece_down = true

     elsif @player_topY > @tile_topY
         @time = Gosu.milliseconds
         difference = @player_topY - @tile_topY
         @moving_y_time = difference.to_f / 265 * 1000
         @move_piece_up = true
     end

     # set the rest of the piece dimensions, this is done here since they are for detecting click events and do not have effect on the movement of the piece 
     piece.dimension.rightX = tile.dimension.rightX + 25  
     piece.dimension.bottomY = tile.dimension.bottomY + 25
  end

#   move pieces on snake and ladder tiles
  def move_snl 
    if @snl_moving  # if snl movement has been triggered
        # put sound here 
        @moving_piece.number = @moving_piece.goto_number # set the piece number to the snake or ladder number
        # iterate through each tile to find the tile that the piece is set to move towards
        @board.each do |row|  
            row.each do |tile|
                if tile.number == @moving_piece.number  
                    set_piece_destination(tile, @moving_piece )  # set the piece's destination to the tile's destination
                end
            end
        end

        #once the moving times are reset, remove the snl movement trigger. this is done to ensure the piece has reached the destination tile before the trigger is removed
        if @moving_x_time == 0 && @moving_y_time == 0
            @snl_moving = false  
        end
    end
  end

  def update
    dice_roll()
    loop_song()
    move_pieces()
    move_snl()
  end


  def draw
    if @start 
        if @player_number != 0
            draw_board() 
            player_sections()
            draw_dice()
            draw_snakes_ladders()
            draw_music()
            draw_player_pieces()
        else 
            choose_players() 

        end
    else
        # draw the start screen
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

#   mouse click functions 

  # check whcih button is clicked on the choose player screen
  def choose_player_number
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
  end

  # check if the dice is clicked
  def dice_click 
    if area_clicked(@dice.dimension.leftX,@dice.dimension.topY, @dice.dimension.rightX,@dice.dimension.bottomY) && @player_number != 0
        # roll dice only if its no ones turn 
        if !@player_moving
            
            @time = Gosu.milliseconds
            @roll_dice = true
            @rolling.play

        end
    end
  end

#   start moving the piece towards the destination tile
  def piece_click_move(piece)

    @board.each do |row|
        row.each do |tile|
            if tile.number == piece.number
                set_piece_destination(tile, piece)

                # check if the piece is on a snake or ladder tile
                if tile.snl == true
                    piece.goto_number = tile.snl_goto  # set the piece's goto number to where the snake or ladder leads to, this is done so the main number only changes when the actual snl movement is triggered 
                    #reset time for piece movement and set trigger to indicate piece should move on snake or ladder tile

                    @snl_trigger = true
                end

                piece.inOrigin = false # set the piece's inOrigin to false to indicate it is no longer in its origin tile
                @moving.play # play the moving sound

                # if the player rolls a 6 they get another turn, otherwise it is the next player's turn
                if @dice_number != 6
                    @player_turn == @player_number ? @player_turn = 1 : @player_turn += 1   
                end

                @player_moving = false # set player moving to false to indicate the player has finished moving
                @dice_number = 0  # reset the dice number to 0
            end
        end
    end
  end

  def piece_click
      if @player_pieces.length != 0 
        # iterate through each player piece to check if it is clicked
        @player_pieces.each do |player|
            player.each do |piece|
                if area_clicked(piece.dimension.leftX, piece.dimension.topY, piece.dimension.rightX, piece.dimension.bottomY)
                    # if the piece is clicked, check if the piece is either in its original location, or if the player rolled a 6. -- this is done because piece can only be moved out of its original location if the player rolls a 6
                    if piece.inOrigin == false || @dice_number == 6 
                        @moving_piece = piece   
                        piece.number += @dice_number  # set the piece's number to the number of the tile it is moving towards
                        piece_click_move(piece) 
                    else 
                        # next player's turn  
                        @player_turn == @player_number ? @player_turn = 1 : @player_turn += 1
                        @player_moving = false
                    end
                end
            end
        end

      end
  end

  def button_down(id)
      case id
      when Gosu::MsLeft
        # check if started 
        if area_clicked(0, 0, 1500, 1000)
            @start = true
        end

        choose_player_number()
        dice_click()
        piece_click()

        # check if music button is clicked
        if area_clicked(1380, 20, 1500, 60)
            @song.playing? ? @song.pause : @song.play
        end

      end
  end
  

end

GameWindow.new.show if __FILE__ == $0


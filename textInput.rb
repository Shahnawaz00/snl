
require "gosu"

class TextField < Gosu::TextInput
  FONT = Gosu::Font.new(20)
  WIDTH = 350
  LENGTH_LIMIT = 20
  PADDING = 5

  INACTIVE_COLOR  = 0xcc_666666
  ACTIVE_COLOR    = 0xcc_ff6666
  SELECTION_COLOR = 0xcc_0000ff
  CARET_COLOR     = 0xff_ffffff

  attr_reader :x, :y

  def initialize(window, x, y)
    super()

    @window, @x, @y = window, x, y

    self.text = "Click to edit"
  end

  def draw(z)
    if @window.text_input == self
      color = ACTIVE_COLOR
    else
      color = INACTIVE_COLOR
    end
    Gosu.draw_rect x - PADDING, y - PADDING, WIDTH + 2 * PADDING, height + 2 * PADDING, color, z

    pos_x = x + FONT.text_width(self.text[0...self.caret_pos])
    sel_x = x + FONT.text_width(self.text[0...self.selection_start])
    sel_w = pos_x - sel_x

    Gosu.draw_rect sel_x, y, sel_w, height, SELECTION_COLOR, z

    if @window.text_input == self
      Gosu.draw_line pos_x, y, CARET_COLOR, pos_x, y + height, CARET_COLOR, z
    end

    FONT.draw_text self.text, x, y, z
  end

  def height
    FONT.height
  end

  def under_mouse?
    @window.mouse_x > x - PADDING and @window.mouse_x < x + WIDTH + PADDING and
      @window.mouse_y > y - PADDING and @window.mouse_y < y + height + PADDING
  end

  def move_caret_to_mouse
    1.upto(self.text.length) do |i|
      if @window.mouse_x < x + FONT.text_width(text[0...i])
        self.caret_pos = self.selection_start = i - 1;
        return
      end
    end
    self.caret_pos = self.selection_start = self.text.length
  end
end

class TextInputDemo < (Example rescue Gosu::Window)
  def initialize
    super 640, 480
    self.caption = "Text Input Demo"

    # Set up an array of three text fields.
    @text_fields = Array.new(3) { |index| TextField.new(self, 50, 300 + index * 50) }
  end

  def needs_cursor?
    true
  end

  def draw
    @text_fields.each { |tf| tf.draw(0) }
  end

  def button_down(id)
    if id == Gosu::KB_TAB

      index = @text_fields.index(self.text_input) || -1
      self.text_input = @text_fields[(index + 1) % @text_fields.size]
    elsif id == Gosu::KB_ESCAPE
      # Escape key will not be 'eaten' by text fields; use for deselecting.
      if self.text_input
        self.text_input = nil
      else
        close
      end
    elsif id == Gosu::MS_LEFT
      # Mouse click: Select text field based on mouse position.
      self.text_input = @text_fields.find { |tf| tf.under_mouse? }
      # Also move caret to clicked position
      self.text_input.move_caret_to_mouse unless self.text_input.nil?
    else
      super
    end
  end
end

TextInputDemo.new.show if __FILE__ == $0
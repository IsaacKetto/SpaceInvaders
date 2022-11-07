require 'Gosu'
require 'debug'
require_relative 'paddle'
require_relative 'ball'

class Pong < Gosu::Window

    def initialize
        super(1920, 1080)
        self.caption = "Bongaren"
        @point_left = 9
        @point_right = 9
        @reset_button = Gosu::Image.new('./media/images/reset_button.png')
        @button_x = self.width/2 - 350
        @button_y = self.height/2
        @font = Gosu::Font.new(self, Gosu.default_font_name, 100)
        @ball = Ball.new(self.width / 2, self.height / 2, self)
        @left_paddle = Paddle.new(40, self.height / 2, self)
        @right_paddle = Paddle.new(self.width - 40, self.height / 2, self)
        @ball_bounce = Gosu::Sample.new(Dir.glob("./media/sounds/bounce.mp3").sample)
        @point_sound = Gosu::Sample.new(Dir.glob("./media/sounds/point_won.mp3").sample)
        @game_won = Gosu::Song.new(Dir.glob("./media/sounds/chad_music.mp3").sample)
        @background_music = Gosu::Song.new(Dir.glob("./media/sounds/STANDING_HERE.mp3").sample)
        @game_over = false
        @background_music.play
    end

    def touching?(x1, y1, x2, y2)
        return (x2 - x1).abs < 28 && (y2 - y1).abs < 60
    end

    def button_pressed?(mouse_x, mouse_y, button_x, button_y, button_width, button_height)
        return mouse_x > button_x && mouse_x < (button_x + button_width) && mouse_y > button_y && mouse_y < (button_y + button_height)
    end

    def reset_button
        @game_over = false
        @point_left = 0
        @point_right = 0
    end

    def update 
        if @point_left == 10 || @point_right == 10
            @background_music.pause
            @game_won.play
            @game_over = true
            if button_down?(Gosu::MsLeft) && button_pressed?(self.mouse_x, self.mouse_y, @button_x, @button_y, @reset_button.width, @reset_button.height)
                reset_button
                @background_music.play
                @game_over = false
            end
        end

        if !@game_over

            if touching?(@ball.x, @ball.y, @left_paddle.x, @left_paddle.y)
                @ball.vel_x *= -1
                @ball_bounce.play
            elsif touching?(@ball.x, @ball.y, @right_paddle.x, @right_paddle.y)
                @ball.vel_x *= -1
                @ball_bounce.play
            end

            if button_down?(Gosu::KbW)
                @left_paddle.move_up
            elsif button_down?(Gosu::KbS)
                @left_paddle.move_down
            end

            if button_down?(Gosu::KbUp)
                @right_paddle.move_up
            elsif button_down?(Gosu::KbDown)
                @right_paddle.move_down
            end

            if @ball.x == 0
                @point_right += 1
                @point_sound.play
                @ball.reset
            elsif @ball.x == self.width
                @point_left += 1
                @point_sound.play
                @ball.reset
            end

            @ball.update
        end
    end

    def draw

        if @point_left == 10
            @font.draw("Left Wins!", (self.width/2) - 175, (self.height/2) - 150, 0)
            @reset_button.draw(@button_x, @button_y, 0)
        elsif @point_right == 10
            @font.draw("Right Wins!", (self.width/2) - 175, (self.height/2) - 150, 0)
            @reset_button.draw(@button_x, @button_y, 0)
        end

        if @point_left == 10 || @point_right == 10
            @reset_button.draw(@button_x, @button_y,0)
        end

        @left_paddle.draw
        @right_paddle.draw
        @ball.draw
        @font.draw("#{@point_left} : #{@point_right}", (self.width/2 - 50), 50, 0) 
    end 
end


pong = Pong.new
pong.show

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
        @button_x = self.width/2
        @button_y = self.height/2 + 50
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

    def touching?(x1, y1, width1, height1, x2, y2, width2, height2)
        return (x1 - x2).abs < (width1 + width2)/2 && (y1 - y2).abs < (height1 + height2)/2
    end

    def reset_button
        @game_over = false
        @point_left = 0
        @point_right = 0
    end

    def update
        if !@game_over
            if @point_left == 10 || @point_right == 10
                @game_over = true
                @background_music.pause
                @game_won.play
                if button_down?(Gosu::MsLeft) && 
            end
            
            if touching?(@ball.x, @ball.y, 20, 20, @left_paddle.x, @left_paddle.y, 20, 60)
                @ball.vel_x *= -1
                @ball_bounce.play
            elsif touching?(@ball.x, @ball.y, 20, 20, @right_paddle.x, @right_paddle.y, 20, 60)
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
            
            # @left_paddle.update
            # @right_paddle.update
        end
    end

    def draw
        if @point_left == 10
            @font.draw("Left Wins!", (self.width/2), (self.height/2), 0)
        elsif @point_right == 10
            @font.draw("Right Wins!", (self.width/2), (self.height/2), 0)
        end

        if @point_left == 10 || @point_right == 10
            @reset_button.draw(@button_x, @button_y,0)
        end

        @left_paddle.draw
        @right_paddle.draw
        @ball.draw
        @font.draw("#{@point_left}", (self.width/2 - 50), 50, 0) 
        @font.draw("#{@point_right}", (self.width/2 + 50), 50, 0)
    end 
end


pong = Pong.new
pong.show

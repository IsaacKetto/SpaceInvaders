class Ball

    attr_accessor :x, :y
    attr_accessor :vel_x, :vel_y

    def initialize(x, y, window)
        @image = Gosu::Image.new('./media/images/ball.png') 
        @window = window
        @vel_x = 8
        if rand <= 0.5
            @vel_x *= -1
        end
        @vel_y = 6
        @x = x
        @y = y
    end

    def reset
        @x = @window.width/2
        @y = @window.height/2
        @vel_x *= -1
    end 

    def update
        
        if @y >= @window.height || @y <= @vel_y.abs
            @vel_y *= -1
        end

        @x += @vel_x
        @y += @vel_y
        
    end

    def draw
        @image.draw(@x,@y,0)
    end
end
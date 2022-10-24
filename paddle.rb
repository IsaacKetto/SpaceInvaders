class Paddle

    attr_reader :x, :y

    def initialize(x, y, window)
        @image = Gosu::Image.new('./media/images/paddle.png')
        @window = window
        @x = x
        @y = y
    end


    def move_up
        if @y > 30
            @y -= 5
        end
    end

    def move_down
        if @y < @window.height - 30
            @y += 5
        end
    end

    def draw
        @image.draw(@x,@y, 0)
    end


end
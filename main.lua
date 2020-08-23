math.randomseed(os.time())

function isInside(x,y,tile)
    local distance = math.sqrt( (tile.x-x)^2 + (tile.y-y)^2 ) - tile.size
    if distance <= 0 then
        return true
    end
end

function inBox( x , y , obj )
    if x >= obj.x and x <= obj.x + obj.w and y >= obj.y and y <= obj.y + obj.h then
        return true
    end
end

function newBase() -- TODO
    baseList[#baseList+1] = base:new()
    tileList[i].base = baseList[#baseList]
    baseList[#baseList].x = tileList[i].x - 25
    baseList[#baseList].y = tileList[i].y - 25
end

function love.load()
    font = love.graphics.newFont(24)
    miniFont = love.graphics.newFont(14)
    screenSize = love.window.setMode( 1360 , 600)
    backgroundColor = {29/255, 11/255, 30/255}
    love.graphics.setBackgroundColor( 1,1,1 )

    ship = {
        w = 20,
        h = 30,
        x = 60,
        y = 60,
        img = love.graphics.newImage('images/ship.png'),
        draw = function(self)
            love.graphics.draw(self.img,self.x,self.y)
        end,
        new = function(self)
            local instance = {}
            for k , v in pairs(self) do
                instance[k] = v
            end
            return instance
        end
    }

    base = {
        w = 50,
        h = 50,
        x = 160,
        y = 160,
        img = love.graphics.newImage('images/base.png'),
        draw = function(self)
            love.graphics.draw(self.img,self.x,self.y)
        end,
        new = function(self)
            local instance = {}
            for k , v in pairs(self) do
                instance[k] = v
            end
            return instance
        end,
        HP = 100,
        attack = 10,
        cost = 2,
        energy = 2
    }
    baseList = {}

    player = {
        coins = 10,
        energy = 0
    }

    toolbar = {
        h = 600,
        w = 360,
        x = 1000,
        y = 0,
        color = {1,1,1},
        draw = function(self)
            love.graphics.setColor( {160/255, 200/255, 230/255} )
            love.graphics.rectangle( 'fill', self.x, self.y, self.w, self.h )
            love.graphics.setColor( 0,0,0 )
            love.graphics.draw(love.graphics.newText(font,'COINS: '..player.coins),self.x + 20,self.y + 20)
            love.graphics.draw(love.graphics.newText(font,'ENERGY: '..player.energy),self.x + 20,self.y + 60)
        end
    }

    clickBox = {
        x = 1010,
        y = 200,
        w = 340,
        h = 390,
        name = '',
        icons = {},
        draw = function(self)
            love.graphics.setColor( 1,1,1 )
            love.graphics.rectangle('fill',self.x,self.y,self.w,self.h)
            love.graphics.setColor( 0,0,0 )
            love.graphics.draw(love.graphics.newText(font,self.name),self.x+100,self.y)
            for i = 1 , #self.icons do
                if self.icons[i] then
                    love.graphics.draw(self.icons[i].img,self.x,self.y+50)
                    love.graphics.draw(self.icons[i].text,self.x+50,self.y+50)
                    love.graphics.draw(self.icons[i].cost,self.x+50,self.y+70)
                end
            end
        end
    }

iconBox = {x = 1010,y=250,w=500,h=500}

    tile = {
        size = 40,
        color = {160/255, 200/255, 230/255}, 
        img = love.graphics.newImage('images/tile.png'),
        draw = function(self)
            love.graphics.draw(self.img,self.x-60,self.y-45)
            local x, y = love.mouse.getPosition( )
            if self.base then
                self.base:draw()
            elseif self.planet then
                love.graphics.setColor( self.color )
                love.graphics.circle('fill',self.x,self.y,self.size)
                if love.mouse.isDown(1) and isInside(x,y,self) then
                    clickBoxIsOpen = true
                    clickBox.name = 'planet'
                    clickBox.icons = {
                        {
                            img = love.graphics.newImage('images/base.png'),
                            text = love.graphics.newText(miniFont,'Build a base'),
                            cost = love.graphics.newText(miniFont,'Cost: 2')
                        }
                    }
                    if love.mouse.isDown(1) and inBox(x,y,iconBox) then
                        print('ok')
                        self.base = base:new()
                    end
                    
                end
            else
                if love.mouse.isDown(1) and isInside(x,y,self) then
                    clickBoxIsOpen = nil
                end
            end
        end,
        new = function(self)
            local instance = {}
            for k , v in pairs(self) do
                instance[k] = v
            end
            return instance
        end
    }
    tileList = {}
    for j = 1 , 5 do
        for i = 1 , 6 do
            -- places tile
            tileList[#tileList+1] = tile:new()
            tileList[#tileList].x = j*180-20
            tileList[#tileList].y = i*90

            -- decides if tile has planet
            local r = math.random(1,100)
            if r >= 40 then
                tileList[#tileList].planet = true
            end
        end
    end
    for j = 1 , 5 do
        for i = 1 , 6 do
            -- places tile
            tileList[#tileList+1] = tile:new()
            tileList[#tileList].x = j*180-110
            tileList[#tileList].y = i*90-40

            -- decides if tile has planet
            local r = math.random(1,100)
            if true then
                tileList[#tileList].planet = true
            end
        end
    end

end

function love.draw()

    toolbar:draw()

    for i = 1 , #tileList do
        tileList[i]:draw()
        if tileList[i].base then
            tileList[i].base:draw()
        end
    end

    if clickBoxIsOpen == true then
        clickBox:draw()
    end

end

function love.update(dt)
end


                          

                        

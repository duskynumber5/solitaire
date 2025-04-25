require "vector"

CardClass = {}

CARD_STATE = {
    IDLE = 0,
    MOUSE_OVER = 1,
    GRABBED = 2,
}

function CardClass:new(xPos, yPos, faceUp, counter)
    local card = {}
    local metadata = {__index = CardClass}
    setmetatable(card, metadata)

    card.position = Vector(xPos, yPos)
    card.size = Vector(70, 90)

    card.faceUp = faceUp
    card.grabbable = true
    card.counter = counter

    return card
end

function CardClass:update()
    
end

function CardClass:draw()
    width = cards[3]:getWidth()
    height = cards[3]:getHeight()

    -- NEW: drop shadow for non-idle cards
    if self.state ~= CARD_STATE.IDLE and self.faceUp == 1 then
        love.graphics.setColor(0, 0, 0, 0.8) -- color values [0, 1]
        local offset = 18 * (self.state == CARD_STATE.GRABBED and 2 or 1)
        love.graphics.rectangle("fill", self.position.x + offset, (self.position.y - 12) + offset, width + 10, height + 30, 6, 6)
    end

    love.graphics.setColor(1, 1, 1 ,1)
    --love.graphics.rectangle("fill", self.position.x, self.position.y, self.size.x, self.size.y, 6 ,6)

    if self.faceUp == 0 then
        love.graphics.draw(cardBack, self.position.x, self.position.y, 0, 1.5, 1.5)
    end

    if self.faceUp == 1 then
        love.graphics.draw(cards[self.counter], self.position.x, self.position.y, 0, 1.5, 1.5)
    end

    love.graphics.print(tostring(self.state), self.position.x + 20, self.position.y - 20)
end

function CardClass:checkForMouseOver()
    if self.state == CARD_STATE.GRABBED then
        return
    end

    local mousePos = grabber.currentMousePos
    local isMouseOver =
        mousePos.x > self.position.x and
        mousePos.x < self.position.x + self.size.x and 
        mousePos.y > self.position.y and
        mousePos.y < self.position.y + self.size.y

    self.state = isMouseOver and CARD_STATE.MOUSE_OVER or CARD_STATE.IDLE

    if self.state == CARD_STATE.MOUSE_OVER then
        if grabber.heldObject and self.faceUp == 1 then
    
            local hasCardOnTop = false
            for _, other in ipairs(cardTable) do
                if other ~= self and
                   other.position.x == self.position.x and
                   other.position.y > self.position.y and
                   (other.position.y - self.position.y) <= 35 and
                   other.faceUp == 1 then
                    hasCardOnTop = true
                    break
                end
            end
    
            if not hasCardOnTop then
                grabber.stackCard = self
            end
        end
    end
end

-- simple array shuffle :) https://gist.github.com/Uradamus/10323382 
function shuffle()
    for i = #cards, 2, -1 do
        local random = math.random(i)
        cards[i], cards[random] = cards[random], cards[i]
    end
    return cards
end

--[[
function CardClass:draw3()
    local stackX = 740
    local stackY = 50
    if stackTraverse <= #cardStack then
        for i = 1, 3, 1 do
            table.insert(extraCards, CardClass:new(stackX, stackY, 1, cardStack[stackTraverse]))
            stackX = stackX - (100)
            counter = counter + 1
            stackTraverse = stackTraverse + 1
            if i < 3 then
                self.grabbable = false
            end
        end
    end
    stackX = 540
    return true
end
]]

require "vector"
require "card"

GrabberClass = {}

function GrabberClass:new()
    local grabber = {}
    local metadata = {__index = GrabberClass}
    setmetatable(grabber, metadata)

    grabber.previousMousePos = nil
    grabber.currentMousePos = nil

    grabber.grabPos = nil
  
    grabber.heldObject = nil

    grabber.stackCard = nil
    grabber.cardUnder = nil

    return grabber
end

function GrabberClass:update()
    self.currentMousePos = Vector(
        love.mouse.getX(),
        love.mouse.getY()
    )
    
    -- click
    if love.mouse.isDown(1) and self.heldObject then
        self.heldObject.position.x = self.currentMousePos.x - 25
        self.heldObject.position.y = self.currentMousePos.y - 25
    end
    -- release
    if not love.mouse.isDown(1) and self.grabPos ~= nil then
        self:release()
    end

end

function GrabberClass:grab(card)
    self.grabPos = self.currentMousePos
    self.heldObject = card

    self.heldObject.state = CARD_STATE.GRABBED
    
    self.heldObject.start = Vector(
        self.heldObject.position.x,
        self.heldObject.position.y
    )

    for i, c in ipairs(cardTable) do
        if c == card then
            table.remove(cardTable, i)
            table.insert(cardTable, card)
            break
        end
    end
    
    checkForCardOn()
end

function GrabberClass:release()

    if self.heldObject == nil then 
        return
    end
    
    local isValidReleasePosition = false

    if self.stackCard then
        if self.stackCard.position.x < 500 and self.stackCard.position.y == 50 then
            isValidReleasePosition = true
            self.heldObject.position.x = self.stackCard.position.x
            self.heldObject.position.y = self.stackCard.position.y
        elseif self.stackCard.position.x > 500 and self.stackCard.position.y == 50 then
            isValidReleasePosition = false
        else 
            isValidReleasePosition = true
            self.heldObject.position.x = self.stackCard.position.x
            self.heldObject.position.y = self.stackCard.position.y + 25
            self.stackCard.grabbable = false
        end
    else 
        isValidReleasePosition = false
    end

    local pos = checkForCardOver()
    if pos and not self.stackCard then
        isValidReleasePosition = true
        self.heldObject.position.x = pos.x
        self.heldObject.position.y = pos.y
    end

    if isValidReleasePosition == false then
        self.heldObject.position = self.heldObject.start
    end

    if self.cardUnder and isValidReleasePosition then
        local hasCardOnTop = false
        for _, other in ipairs(cardTable) do
            if other ~= self.cardUnder and other.faceUp == 1 and
               other.position.x == self.cardUnder.position.x and
               other.position.y > self.cardUnder.position.y and
               (other.position.y - self.cardUnder.position.y) <= 35 then
                hasCardOnTop = true
                break
            end
        end
    
        if not hasCardOnTop then
            if self.cardUnder.faceUp == 0 then
                self.cardUnder.faceUp = 1
            end
    
            if self.cardUnder.faceUp == 1 and not self.cardUnder.grabbable then
                self.cardUnder.grabbable = true
            end
        end

    end    

    self.heldObject.state = 0

    self.stackCard = nil
    self.cardUnder = nil
    
    self.heldObject = nil
    self.grabPos = nil
end

function checkForCardOver()    
    for _, pos in ipairs(validPos) do
        local mousePos = grabber.currentMousePos
        if mousePos.x > pos.x and mousePos.x < pos.x + 70 and
        mousePos.y > pos.y and mousePos.y < pos.y + 90 then
            
            local occupied = false

            for _, card in ipairs(cardTable) do
                if card ~= grabber.heldObject and
                   card.position.x == pos.x and
                   card.position.y == pos.y then
                    occupied = true
                    break
                end
            end

            if not occupied then
                return pos
            end

        end
    end
    return nil
end

function checkForCardOn()
    grabber.cardUnder = nil
    for _, c in ipairs(cardTable) do
        if c ~= grabber.heldObject and
        math.abs(c.position.x - grabber.heldObject.position.x) < 5 and
        math.abs(c.position.y - grabber.heldObject.position.y + 30) <= 5 then
            grabber.cardUnder = c
            break
        end
    end
end
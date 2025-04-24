
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
  
    -- NEW: we'll want to keep track of the object (ie. card) we're holding
    grabber.heldObject = nil

    grabber.stackCard = nil

    return grabber
end

function GrabberClass:update()
    self.currentMousePos = Vector(
        love.mouse.getX(),
        love.mouse.getY()
    )
    
    -- Click
    if love.mouse.isDown(1) and self.heldObject then
        self.heldObject.position.x = self.currentMousePos.x - 25
        self.heldObject.position.y = self.currentMousePos.y - 25
    end
    -- Release
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
end

function GrabberClass:release()

        -- NEW: some more logic stubs here
    if self.heldObject == nil then -- we have nothing to release
        return
    end
    
    -- TODO: eventually check if release position is invalid and if it is
    -- return the heldObject to the grabPosition
    local isValidReleasePosition = false

    if self.stackCard then
        isValidReleasePosition = true
        self.stackCard.grabbable = false
    else 
        isValidReleasePosition = false
    end

    local pos = checkForCardOver()
    if pos and not self.stackCard then
        isValidReleasePosition = true
        self.heldObject.position.x = pos.x
        self.heldObject.position.y = pos.y
    end

    --if not isValidReleasePosition then
    if isValidReleasePosition == false then
        self.heldObject.position = self.heldObject.start
    end

    self.heldObject.state = 0 -- it's no longer grabbed

    self.stackCard = nil
    
    self.heldObject = nil
    self.grabPos = nil
end

function checkForCardOver()    
    for _, pos in ipairs(validPos) do
        local mousePos = grabber.currentMousePos
        if mousePos.x > pos.x and mousePos.x < pos.x + 70 and
        mousePos.y > pos.y and mousePos.y < pos.y + 90 then
            return pos
        end
    end
    return nil
end
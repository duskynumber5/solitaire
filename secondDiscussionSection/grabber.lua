
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
end

function GrabberClass:release()
    print("RELEASE - ")

        -- NEW: some more logic stubs here
    if self.heldObject == nil then -- we have nothing to release
        return
    end
    
    -- TODO: eventually check if release position is invalid and if it is
    -- return the heldObject to the grabPosition
    local isValidReleasePosition = nil

    -- if posiiton not valid
    if not validPos[self.heldObject.position] then
        isValidReleasePosition = false
    end

    -- if position is valid
    if validPos[self.heldObject.position] then
        -- if position is taken, its not valid
        if validPos[self.heldObject.position] == true then
            isValidReleasePosition = false
        end

        -- if position is not taken, it is valid
        if validPos[self.heldObject.position] == false then
            isValidReleasePosition = true
            validPos[self.heldObject.position] = true
        end
    end

    --if not isValidReleasePosition then
    if isValidReleasePosition == false then
        self.heldObject.position = self.heldObject.start
    end
    
    self.heldObject.state = 0 -- it's no longer grabbed

    self.heldObject.position = Vector(
    self.heldObject.start.x,
    self.heldObject.start.y
    )
    
    self.heldObject = nil
    self.grabPos = nil

end
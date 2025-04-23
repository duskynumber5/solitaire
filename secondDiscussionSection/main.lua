-- Maddison Lobo
-- CMPM 121 - Pickup
-- 4-11-25
io.stdout:setvbuf("no")

require "card"
require "grabber"

function love.load()
    love.window.setMode(960, 640)
    love.graphics.setBackgroundColor(0, 0.7, 0.2, 1)
    math.randomseed(os.time())

    cards = {}

    local suits = {"S", "H", "D", "C"}
    local ranks = {"A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"}
    
    for i=1,4 do
        for j=1,13 do
            table.insert(cards, love.graphics.newImage("sprites/" .. suits[i] .. ranks[j] .. ".png"))
        end
    end

    cardBack = love.graphics.newImage("sprites/cardBack.png")

    grabber = GrabberClass:new()
    cardTable = {}
    cardStack = {}

    validPos = {}

    -- stacks
    x = 740
    y = 250
    faceUp = 0
    counter = 1
    shuffle(cards)
    for i = 7, 1, -1 do
            for j = i, 1, -1 do
                if j == 1 then
                    faceUp = 1
                end
                table.insert(cardTable, CardClass:new(x, y, faceUp, counter))
                y = y + (30) -- print next row of cards
                counter = counter + 1
            end
        faceUp = 0
        y = 250 -- reset to stack y
        x = x - (100 + i) -- print cards from right to left
    end

    --draw
    table.insert(cardTable, CardClass:new(840, 50, 0, counter, "stackCard"))
    counter = counter + 1
    for i = counter, #cards do
        table.insert(cardStack, i)
    end

    --suit stacks
    love.graphics.rectangle("fill", 100, 100, x, y)

end

function love.update()
    grabber:update()

    checkForMouseMoving()

    for _, card in ipairs(cardTable) do
        card:update() 
        if card.state == CARD_STATE.MOUSE_OVER and love.mouse.isDown(1) and grabber.heldObject == nil and card.faceUp == 1 then
            grabber:grab(card)
        end
        if card.tag == "stackCard" and card.state == CARD_STATE.MOUSE_OVER then
            if love.mouse.isDown(1) then
                card:draw3()
            end
        end
    end
end

function love.draw()
    for _, card in ipairs(cardTable) do
        card:draw()  -- card.draw(card)
    end

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("Mouse: " .. tostring(grabber.currentMousePos.x) .. ", " .. tostring(grabber.currentMousePos.y))
end

function checkForMouseMoving()
    if grabber.currentMousePos == nil then
        return
    end

    for _, card in ipairs(cardTable) do
        card:checkForMouseOver(grabber)
    end
end
-- Maddison Lobo
-- CMPM 121 - Pickup
-- 4-11-25
io.stdout:setvbuf("no")

require "card"
require "grabber"

function love.load()
    love.window.setMode(960, 640)
    love.graphics.setBackgroundColor(0, 0.7, 0.2, 1)
    love.window.setTitle("solitaire!")
    math.randomseed(os.time())

    cards = {}

    local suits = {"S", "H", "D", "C"}
    local ranks = {"A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"}
    
    for i=1, #suits do
        for j=1, #ranks do
            table.insert(cards, love.graphics.newImage("sprites/" .. suits[i] .. ranks[j] .. ".png"))
        end
    end

    cardBack = love.graphics.newImage("sprites/cardBack.png")

    grabber = GrabberClass:new()
    cardTable = {}
    cardStack = {}

    extraCards = {}

    validPos = {
        {x = 740, y = 250, w = cards[3]:getWidth() + 5, h = cards[3]:getHeight() + 32},
        {x = 630, y = 250, w = cards[3]:getWidth() + 5, h = cards[3]:getHeight() + 32},
        {x = 520, y = 250, w = cards[3]:getWidth() + 5, h = cards[3]:getHeight() + 32},
        {x = 410, y = 250, w = cards[3]:getWidth() + 5, h = cards[3]:getHeight() + 32},
        {x = 300, y = 250, w = cards[3]:getWidth() + 5, h = cards[3]:getHeight() + 32},
        {x = 190, y = 250, w = cards[3]:getWidth() + 5, h = cards[3]:getHeight() + 32},
        {x = 80, y = 250, w = cards[3]:getWidth() + 5, h = cards[3]:getHeight() + 32},

        {x = 36, y = 50, w = cards[3]:getWidth() + 5, h = cards[3]:getHeight() + 32},
        {x = 146, y = 50, w = cards[3]:getWidth() + 5, h = cards[3]:getHeight() + 32},
        {x = 256, y = 50, w = cards[3]:getWidth() + 5, h = cards[3]:getHeight() + 32},
        {x = 366, y = 50, w = cards[3]:getWidth() + 5, h = cards[3]:getHeight() + 32},
    }

    -- stacks
    x = 740
    y = 250
    faceUp = 0
    counter = 1
    shuffle(cards)
    for i = 7, 1, -1 do
        table.insert(validPos, Vector(x, y))
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
        x = x - (110) -- print cards from right to left
    end

    --draw
    table.insert(cardTable, CardClass:new(840, 50, 0, 0, "drawCard"))
    for i = counter, #cards do
        table.insert(cardStack, i)
    end

end

function love.update()
    grabber:update()

    grabber.stackCard = nil

    checkForMouseMoving()

    for _, card in ipairs(cardTable) do
        card:update() 
        if card.state == CARD_STATE.MOUSE_OVER and love.mouse.isDown(1) and grabber.heldObject == nil and card.faceUp == 1 and card.grabbable == true then
            grabber:grab(card)
        end
        if card.tag == "drawCard" and card.state == CARD_STATE.MOUSE_OVER then
            if love.mouse.isDown(1) then
                card:draw3()
            end
        end
    end
end

function love.draw()
    -- 7 stack placements
    x = 740
    y = 250
    for i = 7, 1, -1 do
        love.graphics.rectangle("line", x + 14, y, cards[3]:getWidth() + 5, cards[3]:getHeight() + 32, 6 ,6)
        x = x - (110) -- print cards from right to left
    end

    -- suit stacks
    x = 50
    for i = 4, 1, -1 do
        love.graphics.rectangle("line", x, 50, cards[3]:getWidth() + 5, cards[3]:getHeight() + 32, 6, 6)
        x = x + (110)
    end

--[[
    for _, card in ipairs(extraCards) do
        card:draw() 
    end
]]
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

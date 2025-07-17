--Simple hangman game in lua (LOVE2D)
--MIT Lisence, more in the LISENCE file in the root

local words = {"apple", "banana", "cherry", "grape", "orange", "peach", "strawberry", "toilet", "tree", "window", "computer", "smartphone", "plant", "speaker", "headphones", "waterfall", "clock", "door", "couch", "lamp", "light", "garden", "shadow", "sunlight", "breeze", "forest", "desert", "mountain", "river", "ocean", "island", "rainbow", "butterfly", "castle", "bridge", "village", "city", "country", "school", "library", "hospital", "stadium", "museum", "kitchen", "bedroom", "bathroom", "playground", "airport", "station", "park", "zoo", "market", "shop", "office", "factory", "garage", "basement", "attic", "balcony", "terrace", "corridor", "hallway", "lobby", "reception", "theater", "cinema", "restaurant", "cafe", "bakery", "pizzeria", "hotel", "motel", "guesthouse", "hostel", "farm", "barn", "stable", "garden", "patio", "pool", "fountain", "fireplace", "chimney", "well", "ladder", "rope", "chair", "table", "desk", "cabinet", "shelf", "carpet", "curtain", "pillow", "blanket", "mirror", "painting"}

local word
local guessed = {}
local usedLetters = {}
local lives = 7

math.randomseed(os.clock())

function resetGame()
    word = words[math.random(#words)]
    guessed = {}
    usedLetters = {}
    lives = 6
    for i = 1, #word do
        table.insert(guessed, "_")
    end
end

function isAlpha(char)
    return char:match("%a")
end

function love.load()
    love.window.setTitle("Hangman")
    love.window.setMode(400, 500)
    bg = love.graphics.newImage("chalkboard.png")
    music = love.audio.newSource("bgmusic.wav", "stream")
    music:setLooping(true)
    music:play()
    chalkSound = love.audio.newSource("chalk.wav", "static")
    winSound = love.audio.newSource("youwin.wav", "static")
    loseSound = love.audio.newSource("lost.mp3", "static")
    love.graphics.setFont(love.graphics.newFont(24))
    resetGame()
end

function love.keypressed(key)
    if lives > 0 and table.concat(guessed) ~= word and isAlpha(key) and #key == 1 then
        chalkSound:play()
        if not usedLetters[key] then
            usedLetters[key] = true
            local found = false
            for i = 1, #word do
                if word:sub(i, i) == key then
                    guessed[i] = key
                    found = true
                end
            end
            if not found then
                lives = lives - 1
            end
        end
    end
end

function love.draw()
    love.graphics.draw(bg, 0, 0)
    love.graphics.setFont(love.graphics.newFont(17))
    love.graphics.setFont(love.graphics.newFont(24))
    love.graphics.printf("word: " .. table.concat(guessed, " "), 0, 100, love.graphics.getWidth(), "center")
    love.graphics.printf("hearts: " .. lives, 0, 160, love.graphics.getWidth(), "center")
    love.graphics.printf("tried: " .. table.concat(getUsedLetters(), ", "), 0, 220, love.graphics.getWidth(), "center")
    if lives == 0 then
        loseSound:play()
        love.graphics.printf("you lost! the word was: " .. word .. ". restart to play again", 0, 280, love.graphics.getWidth(), "center")
    elseif table.concat(guessed) == word then
        winSound:play()
        love.graphics.printf("you won congrats, restart to play again!", 0, 280, love.graphics.getWidth(), "center")
    end
end

function getUsedLetters()
    local letters = {}
    for key, _ in pairs(usedLetters) do
        table.insert(letters, key)
    end
    return letters
end
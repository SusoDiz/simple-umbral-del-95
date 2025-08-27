local button = require("button")

local game = {}
local counter = 100
local gameWon = false
local gameLost = false
local probability = 100
local maxProbability = 100
local roundsPlayed = 0
local screenWidth, screenHeight
local backgroundImage

function game.load()
    screenWidth, screenHeight = love.graphics.getDimensions()
    button.load(screenWidth / 2, screenHeight / 2, 150)
    
    -- Crear imagen de fondo procedural
    game.createBackground()
end

function game.setWindowIcon()
    -- Intentar cargar icono desde archivo
    local iconPath = "assets/images/icon.png"
    local success, iconImageData = pcall(love.image.newImageData, iconPath)
    
    if success then
        -- Si existe el archivo, usarlo como icono
        love.window.setIcon(iconImageData)
    else
        -- Si no existe, crear un icono procedural
        local iconData = game.createProceduralIcon()
        love.window.setIcon(iconData)
    end
end

function game.createProceduralIcon()
    -- Crear un icono procedural de 32x32 píxeles
    local size = 32
    local imageData = love.image.newImageData(size, size)
    
    -- Crear un icono simple con el tema del juego
    for x = 0, size - 1 do
        for y = 0, size - 1 do
            local centerX, centerY = size / 2, size / 2
            local distance = math.sqrt((x - centerX)^2 + (y - centerY)^2)
            
            if distance < size / 2 - 2 then
                -- Círculo exterior azul
                local intensity = 1 - (distance / (size / 2))
                local r = 0.2 + intensity * 0.3
                local g = 0.4 + intensity * 0.4
                local b = 0.8 + intensity * 0.2
                local a = 1
                
                imageData:setPixel(x, y, r, g, b, a)
            elseif distance < size / 2 then
                -- Borde del círculo
                imageData:setPixel(x, y, 0.9, 0.9, 1, 1)
            else
                -- Fondo transparente
                imageData:setPixel(x, y, 0, 0, 0, 0)
            end
        end
    end
    
    -- Agregar un punto central brillante
    local centerX, centerY = math.floor(size / 2), math.floor(size / 2)
    imageData:setPixel(centerX, centerY, 1, 1, 1, 1)
    imageData:setPixel(centerX + 1, centerY, 0.8, 0.9, 1, 1)
    imageData:setPixel(centerX, centerY + 1, 0.8, 0.9, 1, 1)
    imageData:setPixel(centerX - 1, centerY, 0.8, 0.9, 1, 1)
    imageData:setPixel(centerX, centerY - 1, 0.8, 0.9, 1, 1)
    
    return imageData
end

function game.createBackground()
    -- Crear una imagen de fondo procedural usando Canvas
    backgroundImage = love.graphics.newCanvas(screenWidth, screenHeight)
    love.graphics.setCanvas(backgroundImage)
    
    -- Fondo con gradiente
    for i = 0, screenHeight do
        local t = i / screenHeight
        local r = 0.1 + t * 0.1 -- De azul oscuro a azul más claro
        local g = 0.1 + t * 0.2
        local b = 0.2 + t * 0.3
        love.graphics.setColor(r, g, b)
        love.graphics.rectangle("fill", 0, i, screenWidth, 1)
    end
    
    -- Agregar algunas "estrellas" o puntos decorativos
    love.graphics.setColor(1, 1, 1, 0.3)
    for i = 1, 50 do
        local x = math.random(screenWidth)
        local y = math.random(screenHeight)
        local size = math.random(1, 3)
        love.graphics.circle("fill", x, y, size)
    end
    
    -- Agregar algunos círculos decorativos grandes
    love.graphics.setColor(0.3, 0.5, 0.7, 0.1)
    for i = 1, 5 do
        local x = math.random(screenWidth)
        local y = math.random(screenHeight)
        local radius = math.random(50, 150)
        love.graphics.circle("line", x, y, radius)
    end
    
    love.graphics.setCanvas()
end

function game.update(dt)
    button.update(dt)
    button.setCounter(counter)
    if counter <= 0 then
        gameWon = true
    end
end

function game.draw()
    -- Dibujar fondo
    if backgroundImage then
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(backgroundImage, 0, 0)
    else
        love.graphics.clear(0.2, 0.2, 0.2)
    end
    
    if gameWon then
        -- Cuadro centrado para el mensaje de victoria
        local messageWidth = 400
        local messageHeight = 80
        local messageX = (screenWidth - messageWidth) / 2
        local messageY = 40
        
        love.graphics.setColor(0, 0, 0, 0.8)
        love.graphics.rectangle("fill", messageX, messageY, messageWidth, messageHeight)
        love.graphics.setColor(0, 1, 0)
        love.graphics.setLineWidth(2)
        love.graphics.rectangle("line", messageX, messageY, messageWidth, messageHeight)
        
        love.graphics.printf("¡Ganaste!", messageX, messageY + 20, messageWidth, "center")
        love.graphics.printf("Haz clic para reiniciar", messageX, messageY + 45, messageWidth, "center")
    elseif gameLost then
        -- Cuadro centrado para el mensaje de derrota
        local messageWidth = 400
        local messageHeight = 80
        local messageX = (screenWidth - messageWidth) / 2
        local messageY = 40
        
        love.graphics.setColor(0, 0, 0, 0.8)
        love.graphics.rectangle("fill", messageX, messageY, messageWidth, messageHeight)
        love.graphics.setColor(1, 0, 0)
        love.graphics.setLineWidth(2)
        love.graphics.rectangle("line", messageX, messageY, messageWidth, messageHeight)
        
        love.graphics.printf("¡Perdiste!", messageX, messageY + 20, messageWidth, "center")
        love.graphics.printf("Haz clic para reiniciar", messageX, messageY + 45, messageWidth, "center")
    else
        -- Cuadro para las estadísticas del juego
        local statsWidth = 500
        local statsHeight = 80
        local statsX = (screenWidth - statsWidth) / 2
        local statsY = 10
        
        love.graphics.setColor(0, 0, 0, 0.7)
        love.graphics.rectangle("fill", statsX, statsY, statsWidth, statsHeight)
        love.graphics.setColor(1, 1, 1, 0.5)
        love.graphics.setLineWidth(1)
        love.graphics.rectangle("line", statsX, statsY, statsWidth, statsHeight)
        
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Probabilidad de perder: " .. (100 - probability) .. "%", statsX, statsY + 15, statsWidth, "center")
        love.graphics.printf("Mayor probabilidad de perder: " .. (100 - maxProbability) .. "%", statsX, statsY + 35, statsWidth, "center")
        love.graphics.printf("Rondas jugadas: " .. roundsPlayed, statsX, statsY + 55, statsWidth, "center")
        button.draw()
    end
end

function game.mousepressed(x, y, mouseButton, istouch, presses)
    if mouseButton == 1 then
        if gameWon or gameLost then
            game.reset()
        elseif button.isClicked(x, y) then
            button.press()
            counter = counter - 1
            probability = probability - 1
            if probability < maxProbability then
                maxProbability = probability
            end
            if math.random(100) > probability then
                gameLost = true
            end
        end
    end
end

function game.reset()
    counter = 100
    probability = 100
    gameWon = false
    gameLost = false
    roundsPlayed = roundsPlayed + 1
    button.setCounter(counter)
end

return game
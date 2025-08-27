local game = require("game")
local settings = require("settings")

local backgroundMusic

function love.load()
    love.window.setTitle("Simple umbral del 95%")
    
    -- Forzar modo ventana (desactivar pantalla completa)
    love.window.setFullscreen(false, "desktop")
    
    -- Configurar tamaño fijo de ventana (evitar maximizar)
    love.window.setMode(800, 600, {
        resizable = false,
        fullscreen = false,
        fullscreentype = "desktop",
        vsync = true
    })
    
    -- Configurar icono de la ventana
    game.setWindowIcon()
    
    settings.load()
    game.load()
    
    -- Cargar y reproducir música de fondo
    backgroundMusic = love.audio.newSource("assets/music/background.mp3", "stream")
    backgroundMusic:setLooping(true)
    backgroundMusic:setVolume(settings.getMusicVolume())
    love.audio.play(backgroundMusic)
end

function love.update(dt)
    -- Mantener tamaño fijo de ventana (prevenir maximización)
    local currentWidth, currentHeight = love.graphics.getDimensions()
    if currentWidth ~= 800 or currentHeight ~= 600 then
        love.window.setMode(800, 600, {
            resizable = false,
            fullscreen = false,
            fullscreentype = "desktop",
            vsync = true
        })
    end
    
    settings.update(dt)
    game.update(dt)
    backgroundMusic:setVolume(settings.getMusicVolume())
end

function love.draw()
    game.draw()
    settings.draw()
end

function love.mousepressed(x, y, button, istouch, presses)
    -- Primero intentar con el menú de ajustes
    if not settings.mousepressed(x, y, button) then
        -- Si el menú no manejó el clic, pasarlo al juego
        game.mousepressed(x, y, button, istouch, presses)
    end
end

function love.mousemoved(x, y, dx, dy, istouch)
    settings.mousemoved(x, y, dx, dy)
end

function love.mousereleased(x, y, button, istouch, presses)
    settings.mousereleased(x, y, button)
end

function love.keypressed(key)
    -- Bloquear teclas de pantalla completa
    if key == "f11" or (key == "return" and love.keyboard.isDown("lalt", "ralt")) then
        -- Forzar que permanezca en modo ventana
        love.window.setFullscreen(false, "desktop")
        return
    end
    
    -- Primero intentar con el menú de ajustes
    if not settings.keypressed(key) then
        -- Si el menú no manejó la tecla, se puede agregar otras funciones aquí
    end
end
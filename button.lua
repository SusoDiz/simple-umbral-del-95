local button = {}
local buttonX, buttonY, buttonRadius
local isPressed = false
local scale = 1
local idleTime = 0
local idlePulse = 0
local counterValue = 100

function button.load(x, y, radius)
    buttonX, buttonY, buttonRadius = x, y, radius
end

function button.update(dt)
    -- Actualizar tiempo para animación idle
    idleTime = idleTime + dt
    idlePulse = math.sin(idleTime * 1.5) * 0.05 -- Pulsación lenta y sutil
    
    if isPressed then
        scale = scale - dt * 3
        if scale <= 0.7 then
            scale = 0.7
            isPressed = false
        end
    else
        scale = scale + dt * 4
        if scale >= 1 then
            scale = 1
        end
    end
end

function button.draw()
    -- Aplicar el efecto idle al tamaño base
    local finalScale = scale + idlePulse
    
    -- Sombra del botón
    love.graphics.setColor(0.1, 0.1, 0.1, 0.3)
    love.graphics.circle("fill", buttonX + 5, buttonY + 5, buttonRadius * finalScale)
    
    -- Botón principal con gradiente visual
    love.graphics.setColor(0.3, 0.5, 0.9)
    love.graphics.circle("fill", buttonX, buttonY, buttonRadius * finalScale)
    
    -- Borde del botón
    love.graphics.setColor(0.5, 0.7, 1)
    love.graphics.setLineWidth(3)
    love.graphics.circle("line", buttonX, buttonY, buttonRadius * finalScale)
    
    -- Brillo interno
    love.graphics.setColor(0.7, 0.8, 1, 0.6)
    love.graphics.circle("fill", buttonX - buttonRadius * 0.3, buttonY - buttonRadius * 0.3, buttonRadius * finalScale * 0.3)
    
    -- Texto con animación
    love.graphics.push()
    -- Aplicar la misma escala que el botón al texto
    love.graphics.translate(buttonX, buttonY)
    love.graphics.scale(finalScale, finalScale)
    love.graphics.translate(-buttonX, -buttonY)
    
    -- El texto también cambia de color según el estado del botón
    if isPressed then
        love.graphics.setColor(0.8, 0.9, 1) -- Más brillante cuando está presionado
    else
        love.graphics.setColor(1, 1, 1)
    end
    
    -- Hacer el texto más grande según el contador para crear más dinamismo
    local fontSize = love.graphics.getFont():getHeight()
    local textScale = 1 + (counterValue / 200) -- El texto se hace más grande con números más altos
    love.graphics.push()
    love.graphics.translate(buttonX, buttonY - 10)
    love.graphics.scale(textScale, textScale)
    love.graphics.printf(tostring(counterValue), -buttonRadius / textScale, 0, (buttonRadius * 2) / textScale, "center")
    love.graphics.pop()
    
    love.graphics.pop()
end

function button.isClicked(x, y)
    local dx = x - buttonX
    local dy = y - buttonY
    return dx * dx + dy * dy <= buttonRadius * buttonRadius
end

function button.press()
    isPressed = true
end

function button.setCounter(value)
    counterValue = value
end

return button
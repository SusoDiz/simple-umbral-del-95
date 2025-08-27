local settings = {}

local showSettings = false
local sliders = {}
local dragging = nil

-- Configuración de los sliders
local sliderWidth = 200
local sliderHeight = 20
local sliderX = 50
local sliderStartY = 80
local sliderSpacing = 60

function settings.load()
    -- Slider para música
    sliders.music = {
        x = sliderX,
        y = sliderStartY,
        width = sliderWidth,
        height = sliderHeight,
        value = 1.0,
        label = "Volumen Música",
        knobX = sliderX + sliderWidth -- Posición inicial del botón
    }
end

function settings.update(dt)
    -- Actualizar posición de los botones de los sliders basado en su valor
    for name, slider in pairs(sliders) do
        slider.knobX = slider.x + (slider.value * slider.width)
    end
end

function settings.draw()
    if not showSettings then
        -- Mostrar solo indicación de cómo abrir ajustes
        love.graphics.setColor(1, 1, 1, 0.7)
        love.graphics.print("ESC - Ajustes", 10, 10)
        return
    end
    
    -- Fondo del menú (más pequeño ya que solo hay música)
    love.graphics.setColor(0, 0, 0, 0.9)
    love.graphics.rectangle("fill", 20, 20, 320, 140)
    
    -- Borde del menú
    love.graphics.setColor(1, 1, 1)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", 20, 20, 320, 140)
    
    -- Título
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("AJUSTES", 30, 30)
    love.graphics.print("ESC - Cerrar", 250, 30)
    
    -- Dibujar sliders
    for name, slider in pairs(sliders) do
        -- Etiqueta
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(slider.label .. ": " .. math.floor(slider.value * 100) .. "%", slider.x, slider.y - 25)
        
        -- Línea del slider
        love.graphics.setColor(0.5, 0.5, 0.5)
        love.graphics.setLineWidth(4)
        love.graphics.line(slider.x, slider.y + slider.height/2, slider.x + slider.width, slider.y + slider.height/2)
        
        -- Parte llena del slider
        love.graphics.setColor(0.2, 0.8, 0.2)
        love.graphics.setLineWidth(6)
        love.graphics.line(slider.x, slider.y + slider.height/2, slider.knobX, slider.y + slider.height/2)
        
        -- Botón del slider
        love.graphics.setColor(1, 1, 1)
        love.graphics.circle("fill", slider.knobX, slider.y + slider.height/2, 12)
        love.graphics.setColor(0.2, 0.2, 0.2)
        love.graphics.circle("fill", slider.knobX, slider.y + slider.height/2, 8)
    end
    
    -- Instrucciones
    love.graphics.setColor(0.8, 0.8, 0.8)
    love.graphics.print("Usa las teclas Q/A o arrastra el botón", 30, 120)
end

function settings.mousepressed(x, y, button)
    if not showSettings or button ~= 1 then
        return false
    end
    
    -- Verificar si se hizo clic en algún slider
    for name, slider in pairs(sliders) do
        local knobDistance = math.sqrt((x - slider.knobX)^2 + (y - (slider.y + slider.height/2))^2)
        if knobDistance <= 15 then -- Radio del botón + margen
            dragging = name
            return true
        end
        
        -- También permitir clic directo en la línea del slider
        if x >= slider.x and x <= slider.x + slider.width and
           y >= slider.y and y <= slider.y + slider.height then
            local newValue = math.max(0, math.min(1, (x - slider.x) / slider.width))
            settings.setSliderValue(name, newValue)
            dragging = name
            return true
        end
    end
    
    return false
end

function settings.mousemoved(x, y, dx, dy)
    if not showSettings or not dragging then
        return
    end
    
    local slider = sliders[dragging]
    if slider then
        local newValue = math.max(0, math.min(1, (x - slider.x) / slider.width))
        settings.setSliderValue(dragging, newValue)
    end
end

function settings.mousereleased(x, y, button)
    if button == 1 then
        dragging = nil
    end
end

function settings.keypressed(key)
    if key == "escape" then
        showSettings = not showSettings
        return true
    elseif not showSettings then
        return false
    end
    
    -- Controles de teclado para ajustar sliders
    if key == "q" then
        settings.setSliderValue("music", math.min(1, sliders.music.value + 0.05))
        return true
    elseif key == "a" then
        settings.setSliderValue("music", math.max(0, sliders.music.value - 0.05))
        return true
    end
    
    return false
end

function settings.setSliderValue(name, value)
    if sliders[name] then
        sliders[name].value = value
        sliders[name].knobX = sliders[name].x + (value * sliders[name].width)
    end
end

function settings.getMusicVolume()
    return sliders.music.value
end

function settings.isVisible()
    return showSettings
end

return settings

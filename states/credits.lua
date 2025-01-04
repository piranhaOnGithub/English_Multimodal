local credits = {}

function credits:init()
    self.buttons = {
        Button(30, 30, 100, 30, 'back', function()
            State.pop()
        end),
    }
end

function credits:enter()
    lg.setBackgroundColor(Colors[3])
end

function credits:update(dt)
    for _, b in ipairs(self.buttons) do
        b:update(dt)
    end
    self.offset_x = math.cos(lt.getTime() * 2) * 5
    self.offset_y = math.sin(lt.getTime() * 2) * 2
end

function credits:keypressed(key, code)

end

function credits:mousepressed(x, y, mbutton)
    local mx, my = Resolution.toGame(x, y)
    for _, b in ipairs(self.buttons) do
        b:click(mx, my, mbutton)
    end
end

function credits:draw()

    Resolution.start()

    lg.setColor(Colors[1])
    lg.setFont(Fonts.display[18])
    lg.printf('PROGRAMMING:\nKalan Wolfe\n\nSFX:\n(WALK, JUMP, LAND) - JiggleSticks\n(ITEM PICKUP) - IENBA\n(GLASS) - GN2013\n(LADDER) - alec_mackay\n\nMUSIC:\n(MENU) "soft music box" - ZHRO\n(GAME) "Not To Notice" - Andrewkn\n\nREFERENCE ART:\n(LEMON) - Shutterstock\n(ANVIL) - Xiori on Pixilart.com\n\nCOLOR PALETTE:\n"Fading 16" - CopheeMoth on Lospec.com', 30 + self.offset_x, VIRT_HEIGHT / 4 + self.offset_y, VIRT_WIDTH, 'left')

    lg.setFont(Fonts.display[24])
    lg.printf('All audio from Freesound.org', 30 + self.offset_x, 550 - self.offset_y, VIRT_WIDTH / 2, 'left')

    for _, b in ipairs(self.buttons) do
        b:render()
    end

    Resolution.stop()
end

return credits

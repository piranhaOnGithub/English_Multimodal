

LemonadeMan = Class{}

function LemonadeMan:init(x, y, target)
    self.x      = x
    self.y      = y
    self.w      = 10
    self.h      = 15
    self.arm_dn = 0.3
    self.arm_up = 1.45
    self.target = target
    self.opacity= 0
    self.name   = 'Bartholomew Jones'
    self.lemons = 'Infinity'
    self.limes  = 'Infinity'
end

function LemonadeMan:render()

    if DEBUG then
        lg.setColor(Colors[9])
        lg.rectangle('line', self.x, self.y, self.w, self.h)
    else

        -- Cloak
        lg.setColor(Colors[3][1], Colors[3][2], Colors[3][3], self.opacity)
        lg.polygon('fill', self.x, self.y + self.h - 2, self.x + 1, self.y, self.x + self.w - 1, self.y, self.x + self.w, self.y + self.h - 2)

        -- Body
        lg.setColor(Colors[4][1], Colors[4][2], Colors[4][3], self.opacity)
        lg.rectangle('fill', self.x + 2.5, self.y, 5, 8)

        -- Leg
        lg.push()
        lg.translate(self.x + 3.5, self.y + 7)
        lg.rectangle('fill', -1.5, 0, 3, 8)
        lg.pop()

        -- Other leg
        lg.push()
        lg.translate(self.x + 6.5, self.y + 7)
        lg.rectangle('fill', -1.5, 0, 3, 8)
        lg.pop()

        -- Arm
        lg.push()
        if self.target.x >= self.x then
            lg.translate(self.x + 3, self.y)
            lg.rotate(((math.cos(lt.getTime() * 1.5) * 0.2 + math.pi * 2) % (math.pi * 2)) + self.arm_dn)
            lg.rectangle('fill', -1.5, 0, 3, 7)
        else
            lg.translate(self.x + 3, self.y)
            lg.rotate(((math.cos(lt.getTime() * 1.5) * 0.2 + math.pi * 2) % (math.pi * 2)) + self.arm_up)
            lg.rectangle('fill', -1.5, 0, 3, 7)
        end
        lg.pop()

        -- Other arm
        lg.push()
        if self.target.x >= self.x then
            lg.translate(self.x + 7, self.y)
            lg.rotate(((math.cos(lt.getTime() * 1.5)) * -0.1 % (math.pi * 2)) - self.arm_up)
            lg.rectangle('fill', -1.5, 0, 3, 7)
        else
            lg.translate(self.x + 7, self.y)
            lg.rotate(((math.cos(lt.getTime() * 1.5)) * -0.1 % (math.pi * 2)) - self.arm_dn)
            lg.rectangle('fill', -1.5, 0, 3, 7)
        end
        lg.pop()

        -- Head
        lg.push()
        lg.translate(self.x + self.w / 2, self.y - 3)
        lg.circle('fill', 0, 0, 4)
        lg.pop()

        -- Beard
        lg.setColor(Colors[2][1], Colors[2][2], Colors[2][3], self.opacity)
        if self.target.x >= self.x then
            lg.polygon('fill', self.x + 3, self.y - 1, self.x + self.w / 2 + 1, self.y + self.h * 2 / 3, self.x + self.w - 2, self.y - 1)
        else
            lg.polygon('fill', self.x + 2, self.y - 1, self.x + self.w / 2 - 1, self.y + self.h * 2 / 3, self.x + self.w - 3, self.y - 1)
        end

        -- Staff
        lg.setColor(Colors[8][1], Colors[8][2], Colors[8][3], self.opacity)
        lg.push()
        if self.target.x >= self.x then
            lg.translate(self.x + 3, self.y)
            lg.rotate(((math.cos(lt.getTime() * 1.5) * -0.1 + math.pi * 2) % (math.pi * 2)) - self.arm_up)
            lg.rectangle('fill', -10, 9, 15, 1)
        else
            lg.translate(self.x + 3, self.y)
            lg.rotate(((math.cos(lt.getTime() * 1.5) * 0.1 + math.pi * 2) % (math.pi * 2)) + self.arm_up)
            lg.rectangle('fill', 10, 5, -15, 1)
        end
        lg.pop()
    end
end
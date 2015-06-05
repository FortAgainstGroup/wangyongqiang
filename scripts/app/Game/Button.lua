local button = class("button", function()
    return display.newScene("button")
end)

function button:ctor()
    -- self._clicked = false
end

--传入的参数分别为：单位信息，接受的命令，位置
function button:init( node,cmd,pos,label )
	self._node = node
	self._cmd = cmd ----------指令

	self._img = display.newSprite(node.name)
	self._r=GameButton.radius
	self._scale=GameButton.scale
	self:setScale(self._scale)
    self:setAnchorPoint(ccp(0,0))
    self:addChild(self._img)

    local label = cc.ui.UILabel.new({text = label, size = 50}) 		----------显示指令
    			:align(display.CENTER, 0, -self._r-50)
    			:addTo(self)
    -- if cmd == GameTouch.addUnitAlert then
    -- 	label:setString("巡逻")
    -- else
    -- 	label:setString("进攻")
    -- end

	self:setPosition(pos)
end

function button:setState( state )
	self._state = state
end

function button:update()
	
end

function button:onTouch(name,x,y,prevX,prevY)
	if getDistanceN2P(self, ccp(x, y))<self._r then
		if name == TouchEventString.began then
	        click(self)
	        -- self._clicked = not self._clicked
		elseif name == TouchEventString.ended then
	        
		end
		return true	
	else 
		return false
	end
end



return button
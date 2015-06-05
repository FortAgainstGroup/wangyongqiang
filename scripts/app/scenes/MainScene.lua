require("app.GameFunction")
require("app.GameData")
ClassGameDirectort = require("app.Game.GameDirector")

local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
    self:initControl()
    self:initBack()
    g_director = ClassGameDirectort.new()
    g_director:init(self)
    self:initUpdate()

    self._state = State.alive

end

function MainScene:initControl()
    local layer = display.newLayer() ----------鼠标点击控件
    layer:setTouchEnabled(true)
    layer:addNodeEventListener(cc.NODE_TOUCH_EVENT, 
        function(event)
            return self:onTouch(event.name, event.x, event.y, event.prevX, event.prevY)
        end
        )
    layer:setTouchSwallowEnabled(false)
    self:addChild(layer)
end

function MainScene:initBack()
    local imgBack = display.newSprite("back3.jpg")
    imgBack:setAnchorPoint(ccp(0,0))
    self:addChild(imgBack) 
end

function MainScene:initUpdate()
    self._scheduler = require("framework.scheduler")
    self._scheduler.scheduleGlobal(handler(self, self.update), 1/GameData.fps)
end

function MainScene:update()
    if self._state ~= State.null then
        if g_director:update() then
            self:gameOver() ----------游戏结束
        end
    end
end

function MainScene:onTouch(name,x,y,prevX,prevY)
    if self._state ~= State.null then
        if g_director:onTouch(name, x, y, prevX, prevY) then
                
    	end
    end
    return true
end

function MainScene:gameOver(  )                                                     ----------游戏结束
    self._state = State.null
    self._label = cc.ui.UILabel.new({text = "游戏结束", size = 50})                     
                :align(display.CENTER, CONFIG_SCREEN_WIDTH/2, CONFIG_SCREEN_HEIGHT/2)
                :addTo(self)

end

return MainScene

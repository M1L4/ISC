Class = require "libs.util.inheritance"
local API = Class:new()

--bot controls
function API:onStart()  end
function API:onStop()   end
function API:onPause()  end
function API:onResume() end

--actions
function API:onPathAction()                     end
function API:onBattleAction()                   end
function API:onLearningMove(moveName, PKMIndex) end

--messages
function API:onDialogMessage(msg)   end
function API:onBattleMessage(msg)   end
function API:onSystemMessage(msg)   end

return API

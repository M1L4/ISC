local API = require "libs.util.api"

--bot controls
function onStart()
    if not script or not type(script) == type(API) then
        fatal("Api Executionor expects a Subclass of API")
    end

    script:onStart()
end
function onStop()   script:onStop()    end
function onPause()  script:onPause()   end
function onResume() script:onResume()  end

--actions
function onPathAction()     script:onPathAction()      end
function onBattleAction()   script:onBattleAction()    end
function onLearningMove(moveName, PKMIndex)
    script:onLearningMove(moveName, PKMIndex)
end

--messages
function onDialogMessage(msg)   script:onDialogMessage(msg)    end
function onBattleMessage(msg)   script:onBattleMessage(msg)    end
function onSystemMessage(msg)   script:onSystemMessage(msg)    end
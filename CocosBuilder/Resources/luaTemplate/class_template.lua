local CCBHelper = import("Utils.CCBHelper")
local Oop = import("Oop.init")

local funcs = {
    __FUNC_NAMES__
}

local __CLASS_NAME__ = Oop.class("__CLASS_NAME__", function(owner)
    return CCBHelper:create("__CLASS_NAME__", "__CCBI_FILE_PATH__", funcs, owner)
end)

function __CLASS_NAME__:ctor()
    -- @TODO: constructor
end

__FUNC_IMPLEMENTS__

return __CLASS_NAME__
require("import_sibling")
require("subDir.import_child")

--log("test")
--for dir in io.popen([[dir "C:/Program Files/" /b /ad]]):lines() do log(dir) end

--local function rmDot2(str) return str:match(".+[%.]"):sub(1,-2) end
--
--path = "C:/Program Files/test_import.lua"
--print(rmDot2(path))
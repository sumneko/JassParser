local parser = require 'parser'
local writer = require 'writer'
local uni    = require 'unicode'

require 'test.unit_test'
require 'test.ast_test'

trequire 'test.Type'
trequire 'test.Globals'
trequire 'test.Function'
trequire 'test.Logic'
trequire 'test.Exp'
trequire 'test.Value'

require 'test.fail_test'

print('语法测试通过')

package.preload['core.const'] = (function (...)
local const = {}

function const.start()
  HELLO_WORLD = 'Hello world!'
end

return const
 end)
package.preload['core'] = (function (...)
local core = {}

local const = require('core.const')

function core.start()
  const.start()
end

return core
 end)
local core = require('core')

function main()
  repeat wait(0) until isSampAvailable() -- этот цикл использовать только для moonly

  core.start()

  print(HELLO_WORLD)
end

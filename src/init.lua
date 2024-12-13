local core = require('core')

function main()
  repeat wait(0) until isSampAvailable() -- этот цикл использовать только для moonly

  core.start()

  print(HELLO_WORLD)
end

local settings = require('settings_squish')

local lfs = require('lfs')

local _files = {}

local regexPathFiles = string.format('^%s/', settings.pathFiles)

local PATTERN = {
  MAIN = 'Main "%s"',
  MODULE = 'Module "%s" "%s"',
  OUTPUT = 'Output "%s/%s"'
}

local function isNotIgnoreDir(dirPath)
  for _, value in ipairs(settings.ignoreDirs) do
    if value == dirPath then
      return false
    end
  end
  return true
end

local function attrdir(path)
  for file in lfs.dir(path) do
    if file ~= '.' and file ~= '..' then
      local filePath = path .. '/' .. file
      local fg = filePath:gsub(regexPathFiles, '')
      local attr = lfs.attributes(filePath)
      assert(type(attr) == 'table')
      if file:find('%.lua$') and fg ~= settings.mainFile then
        table.insert(_files, fg)
      end
      if attr.mode == 'directory' and isNotIgnoreDir(fg) then
        attrdir(filePath)
      end
    end
  end
end


local function getFilesInPathFiles(pathFiles)
  attrdir(pathFiles)
  return _files
end

local function convertModulesToSquishFile(fs)
  local modules = {}
  for i, filename in ipairs(fs) do
    local pathRequire = filename
        :gsub('/init%.lua$', ''):gsub('%.lua$', '')
        :gsub('/', '.')
    modules[#modules + 1] = string.format(PATTERN.MODULE, pathRequire, filename)
  end

  local main = string.format(PATTERN.MAIN, settings.mainFile)
  local output = string.format(PATTERN.OUTPUT, settings.outputFolder, settings.outputFile)
  local squishy = string.format(
    '%s\n\n%s\n\n%s',
    main,
    table.concat(modules, '\n'),
    output
  )

  local file = io.open('src/squishy', 'w')
  file:write(squishy)
  file:close()
end

local function main()
  local files = getFilesInPathFiles(settings.pathFiles)
  convertModulesToSquishFile(files)
  lfs.mkdir(settings.outputFolder)
end

main()

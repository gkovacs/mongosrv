
{existsSync} = require 'fs'
{exec, which} = require 'shelljs'

require! {
  yamlfile
  mkdirp
  optionator
}

option_parser = optionator {
  options:
    * option: 'port'
      alias: 'p'
      type: 'Int'
      description: 'port number'
      default: '27017'
    * option: 'dbpath'
      alias: 'd'
      type: 'String'
      description: 'path to mongodata directory'
      default: 'mongodata'
    * option: 'help'
      alias: 'h'
      type: 'Boolean'
      description: 'display help'
}

options = option_parser.parseArgv process.argv
if options.help?
  console.log option_parser.generateHelp!
  process.exit!

portnum = options.port
mongodir = options.dbpath

if not which 'mongod'
  console.log 'missing mongod command'
  process.exit()

if existsSync '.mongosrv.yaml'
  hostname = exec('hostname').output.trim()
  new_mongodir = yamlfile.readFileSync('.mongosrv.yaml')[hostname]
  if new_mongodir?
    mongodir = new_mongodir

if not existsSync mongodir
  console.log 'creating mongodata directory'
  mkdirp.sync mongodir

exec "mongod --dbpath #{mongodir} --port #{portnum}", {async: true}

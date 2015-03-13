
{existsSync} = require 'fs'
{exec, which} = require 'shelljs'

require! {
  yamlfile
  mkdirp
}

if not which 'mongod'
  console.log 'missing mongod command'
  process.exit()

mongodir = 'mongodata'
if existsSync '.mongosrv.yaml'
  hostname = exec('hostname').output.trim()
  new_mongodir = yamlfile.readFileSync('.mongosrv.yaml')[hostname]
  if new_mongodir?
    mongodir = new_mongodir

if not existsSync mongodir
  console.log 'creating mongodata directory'
  mkdirp.sync mongodir

exec "mongod --dbpath #{mongodir}", {async: true}

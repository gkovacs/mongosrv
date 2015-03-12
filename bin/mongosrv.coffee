{existsSync, mkdirSync} = require 'fs'
{exec, which} = require 'shelljs'

if not which 'mongod'
  console.log 'missing mongod command'
  process.exit()

if not existsSync 'mongodata'
  console.log 'creating mongodata directory'
  mkdirSync 'mongodata'

exec 'mongod --dbpath ./mongodata', {async: true}

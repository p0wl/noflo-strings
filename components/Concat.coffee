noflo = require("noflo")

class Concat extends noflo.Component

  description: "Join all values of a passed packet together as a
  string with a predefined delimiter"

  buffer: []

  constructor: ->
    @delimiter = ","

    @inPorts =
      in: new noflo.Port
      delimiter: new noflo.Port
    @outPorts =
      out: new noflo.Port

    @inPorts.delimiter.on "data", (@delimiter) =>

    @inPorts.in.on "begingroup", (group) =>
      @outPorts.out.beginGroup(group)

    @inPorts.in.on "data", (data) =>
      @buffer.push data

    @inPorts.in.on "endgroup", (group) =>
      @outPorts.out.endGroup()

    @inPorts.in.on "disconnect", =>
      @outPorts.out.send @buffer.join(@delimiter)
      @buffer = []
      @outPorts.out.disconnect()

exports.getComponent = -> new Concat

#!/usr/bin/env ruby

require "json"

def readFromFile(filePath)
  File.open(filePath, "r") do |f|
    file = File.read(filePath)
    return JSON.parse(file)
  end
end
#!/usr/bin/env ruby

require "json"

def writeToFile(filePath, data)
  File.open(filePath, "w") do |f|
    f.write(JSON.pretty_generate data)
  end
end
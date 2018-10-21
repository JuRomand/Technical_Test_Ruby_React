#!/usr/bin/env ruby

require "json"

def readFromFile(filePath)
  File.open(filePath, "r") do |f|
    file = File.read(filePath)
    return JSON.parse(file)
  end
end

def writeToFile(filePath, data)
  File.open(filePath, "w") do |f|
    f.write(JSON.pretty_generate data)
  end
end

def getProgressRecordsPercentages(data)
  progressRecords = data["progress_records"]
  objectives = data["objectives"]
  progressRecordsPercentages = []

  progressRecords.each do |progressRecord|
    correspondingObjective = objectives.select{ |objective| progressRecord["objective_id"] == objective["id"] }.first
    if (correspondingObjective["start"] - correspondingObjective["target"] != 0)
      progress = ((progressRecord["value"] - correspondingObjective["start"]).to_f * 100 / (correspondingObjective["target"] - correspondingObjective["start"])).to_f
      progressRecordsPercentages.push({ id: progressRecord["id"], "progress": progress.ceil})
    else
      puts "No progression is expected for objective with id #{correspondingObjective["id"].to_s}."
    end
  end
  return {"progress_records": progressRecordsPercentages}
end

if __FILE__ == $0
  input = readFromFile("data/input.json")
  output = getProgressRecordsPercentages(input)
  writeToFile("data/ouput.json", output)
end

#!/usr/bin/env ruby

require "json"
require "date"

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

def handleErrors(errorType, value)
  case errorType
  when "noFlatProgressionExpected"
    puts "No progression is expected for objective with id #{value.to_s}."
  when "noEndDateAnteriorOrEqualToStartDate"
    puts "End date is anterior or equal to start date for objective with id #{value.to_s}."
  when "noEndDateAnteriorToCurrentDate"
    puts "End date has already been reached for objective with id #{value.to_s}."
  when "noStartDatePosteriorToCurrentDate"
    puts "Start date has not been reached yet for objective with id #{value.to_s}."
  when "wrongProcessInput"
    puts "The process with id #{value.to_s} contains an invalid value"
  when "wrongObjectiveInput"
    puts "The objective with id #{value.to_s} contains an invalid value"
  end
end

def checkProgressValuesTypesAndFormat(progress)
  case
  when (progress["objective_id"].kind_of? Integer) == false
    handleErrors("wrongProcessInput", progress["id"])
    return false
  when (Date.parse(progress["date"]) rescue nil) == nil
    handleErrors("wrongProcessInput", progress["id"])
    return false
  when (progress["value"].kind_of? Integer) == false
    handleErrors("wrongProcessInput", progress["id"])
    return false
  end
  return true
end

def checkObjectivesValuesTypesAndFormat(objective)
  case
  when (objective["id"].kind_of? Integer) == false
    handleErrors("wrongObjectiveInput", objective["id"])
    return false
  when (Date.parse(objective["start_date"]) rescue nil) == nil
    handleErrors("wrongObjectiveInput", objective["id"])
    return false
  when (Date.parse(objective["end_date"]) rescue nil) == nil
    handleErrors("wrongObjectiveInput", objective["id"])
    return false
  when (objective["start"].kind_of? Integer) == false
    handleErrors("wrongObjectiveInput", objective["id"])
    return false
  when (objective["target"].kind_of? Integer) == false
    handleErrors("wrongObjectiveInput", objective["id"])
    return false
  when objective["start"] - objective["target"] == 0
    handleErrors("noFlatProgressionExpected", objective["id"])
    return false
  when Date.parse(objective["end_date"]) <= Date.parse(objective["start_date"])
    handleErrors("noEndDateAnteriorOrEqualToStartDate", objective["id"])
    return false
  end
  return true
end

def checkDatesCompatibility(progressRecord, correspondingObjective)
  noEndDateAnteriorToCurrentDate = Date.parse(correspondingObjective["end_date"]) >= Date.parse(progressRecord["date"])
  noStartDatePosteriorToCurrentDate = Date.parse(progressRecord["date"]) >= Date.parse(correspondingObjective["start_date"])
  case
  when !noEndDateAnteriorToCurrentDate
    handleErrors("noEndDateAnteriorToCurrentDate", correspondingObjective["id"])
    return false
  when !noStartDatePosteriorToCurrentDate
    handleErrors("noStartDatePosteriorToCurrentDate", correspondingObjective["id"])
    return false
  end
  return true
end

def getExpectedProgressValue(objective, date)
  startDate = Date.parse(objective["start_date"])
  endDate = Date.parse(objective["end_date"])
  date = Date.parse(date)
  if endDate - startDate > 0
    expectedDailyProgression = (objective["target"] - objective["start"]).to_f / (endDate - startDate).to_f
    expectedProgression = expectedDailyProgression * (date - startDate).to_f
    return expectedProgression
  end
end

def getProgressExcessValue(data)
  progressRecords = data["progress_records"]
  objectives = data["objectives"]
  progressExcessValues = []

  progressRecords.each do |progressRecord|
    correspondingObjective = objectives.select{ |objective| progressRecord["objective_id"] == objective["id"] }.first
    if !correspondingObjective
      handleErrors("wrongProcessInput", progressRecord["id"])
    else
      canProceed = (
        checkProgressValuesTypesAndFormat(progressRecord) &&
        checkObjectivesValuesTypesAndFormat(correspondingObjective) &&
        checkDatesCompatibility(progressRecord, correspondingObjective)
      )
      if canProceed
        expectedProgress = getExpectedProgressValue(correspondingObjective, progressRecord["date"]);
        excess = (progressRecord["value"].to_f - correspondingObjective["start"].to_f - expectedProgress) * 100 / expectedProgress
        excess = excess >= 0 ? excess.ceil : excess.round
        progressExcessValues.push({ id: progressRecord["id"], "excess": excess})
      end
    end
  end
  return {"progress_records": progressExcessValues}
end

if __FILE__ == $0
  input = readFromFile("data/input.json")
  output = getProgressExcessValue(input)
  writeToFile("data/ouput.json", output)
end
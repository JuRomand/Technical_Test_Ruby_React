#!/usr/bin/env ruby

def handleErrors(errorType, value)
  case errorType
  when "noFlatProgressionExpected"
    puts "No progression is expected for objective with id #{value.to_s}."
  when "noEndDateAnteriorOrEqualToStartDate"
    puts "End date is anterior or equal to start date for objective with id #{value.to_s}."
  when "wrongProcessInput"
    puts "The process with id #{value.to_s} contains an invalid value"
  when "wrongObjectiveInput"
    puts "The objective with id #{value.to_s} contains an invalid value"
  when "wrongMilestoneInput"
    puts "The milestone with id #{value.to_s} contains an invalid value"
  when "noObjectiveFound"
    puts "Objective with id #{value.to_s} can't be found."
  when "noMilestoneFound"
    puts "Milestone with id #{value.to_s} can't be found."
  when "noProgressRecordFound"
    puts "ProgressRecord with id #{value.to_s} can't be found."
  end
end
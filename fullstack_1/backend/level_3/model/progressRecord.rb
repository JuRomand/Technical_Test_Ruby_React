#!/usr/bin/env ruby

require "date"
require_relative "dataBase"
require_relative "objective"
require_relative "../utils/validateDate"
require_relative "../utils/handleErrors"

class ProgressRecord

  def self.get(id)
    progressRecord = DataBase.getProgressRecords.select{ |progressRecord| progressRecord["id"] == id }.first
    return self.isValid(progressRecord, id) ? progressRecord : nil
  end

  def self.isValid(progressRecord, id)
    correspondingObjective = Objective.get(progressRecord["objective_id"])
    case
    when progressRecord == nil
      handleErrors("noProgressRecordFound", id)
      return false
    when !validateDate(progressRecord["date"])
      handleErrors("wrongProgressRecordInput", progressRecord["id"])
      return false
    when (progressRecord["value"].kind_of? Integer) == false
      handleErrors("wrongpPogressRecordInput", progressRecord["id"])
      return false
    when correspondingObjective == nil
      handleErrors("wrongProgressRecordInput", progressRecord["id"])
      return false
    when (Date.parse(correspondingObjective["start_date"]) >= Date.parse(progressRecord["date"]) || 
      Date.parse(correspondingObjective["end_date"]) <= Date.parse(progressRecord["date"]))
      handleErrors("wrongProgressRecordInput", progressRecord["id"])
      return false
    end
    return true
  end
  
end
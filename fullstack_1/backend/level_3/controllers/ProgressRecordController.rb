#!/usr/bin/env ruby

require "date"
require_relative "../model/progressRecord"
require_relative "ObjectiveController"

class ProgressRecordController
  attr_reader :id, :objectiveId, :date, :value, :isValid
  
  def initialize(id)
    @id = id
    @data = ProgressRecord.get(@id)
    @isValid = @data != nil ? true : false
    @objectiveId = @data["objective_id"]
    @date = Date.parse(@data["date"])
    @value = @data["value"]
  end

  def getExcessValue
    objective = ObjectiveController.new(@objectiveId)
    if objective.isValid
      expectedProgress = objective.getExpectedProgressValue(@date);
      excess = (@value.to_f - expectedProgress - objective.start) * 100 / expectedProgress
      return excess = excess >= 0 ? excess.ceil : excess.round
    end
    return nil
  end

end
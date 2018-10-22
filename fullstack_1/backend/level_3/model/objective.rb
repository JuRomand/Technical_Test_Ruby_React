#!/usr/bin/env ruby

require "date"
require_relative "dataBase"
require_relative "../utils/validateDate"
require_relative "../utils/handleErrors"

class Objective

  def self.get(id)
    objective = DataBase.getObjectives.select{ |objective| objective["id"] == id }.first
    return self.isValid(objective, id) ? objective : nil
  end

  def self.isValid(objective, id)
    case
    when objective == nil
      handleErrors("noObjectiveFound", id)
      return false
    when !validateDate(objective["start_date"])
      handleErrors("wrongObjectiveInput", objective["id"])
      return false
    when !validateDate(objective["end_date"])
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

end
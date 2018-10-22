#!/usr/bin/env ruby

require "date"
require_relative "dataBase"
require_relative "objective"
require_relative "../utils/validateDate"
require_relative "../utils/handleErrors"

class Milestone

  def self.get(id)
    milestone = DataBase.getMilestones.select{ |milestone| milestone["id"] == id }.first
    return self.isValid(milestone, id) ? milestone : nil
  end

  def self.isValid(milestone, id)
    correspondingObjective = Objective.get(milestone["objective_id"])
    case
    when milestone == nil
      handleErrors("noMilestoneFound", id)
      return false
    when !validateDate(milestone["date"])
      handleErrors("wrongMilestoneInput", milestone["id"])
      return false
    when (milestone["target"].kind_of? Integer) == false
      handleErrors("wrongMilestoneInput", milestone["id"])
      return false
    when correspondingObjective == nil
      handleErrors("wrongMilestoneInput", milestone["id"])
      return false
    when (Date.parse(correspondingObjective["start_date"]) >= Date.parse(milestone["date"]) || Date.parse(correspondingObjective["end_date"]) <= Date.parse(milestone["date"]))
      handleErrors("wrongMilestoneInput", milestone["id"])
      return false
    end
    return true
  end
  
end
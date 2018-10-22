#!/usr/bin/env ruby

require "date"
require_relative "../model/objective"
require_relative "../model/milestone"

class ObjectiveController
  attr_reader :id, :startDate, :enDate, :start, :target, :isValid
  
  def initialize(id)
    @id = id
    @data = Objective.get(@id)
    @isValid = @data != nil ? true : false
    @startDate = Date.parse(@data["start_date"])
    @endDate = Date.parse(@data["end_date"])
    @start = @data["start"]
    @target = @data["target"]
  end

  def getMilestones
    milestones = DataBase.getMilestones.select{ |milestone| @id == milestone["objective_id"] }
    validMilestones = []
    milestones.each do |milestone|
      Milestone.get(milestone["id"]) != nil ? validMilestones.push(milestone) : nil
    end
    return validMilestones
  end

  def getExpectedProgressValue(date)
    milestones = getMilestones
    date = date.is_a?(Date) ? date : Date.parse(date)
    expectedProgression = 0
    if date.between?(@startDate, @endDate)
      if milestones.length == 0
        expectedDailyProgression = (@target - @start).to_f / (@endDate - @startDate).to_i
        expectedProgression = expectedDailyProgression * (date - @startDate).to_i
      else
        sectionStartDate = @startDate
        sectionEndDate = @endDate
        milestones.each_with_index do |milestone,index|
          if date >= Date.parse(milestone["date"])
            sectionStartDate = Date.parse(milestone["date"])
          end
          if date < Date.parse(milestone["date"])
            sectionEndDate = Date.parse(milestone["date"])
          end
        end
        if(sectionStartDate == date)
          expectedProgression = milestones.select{|milestone| sectionStartDate == milestone["date"]}["target"]
        else
          target = sectionEndDate == @endDate ? @target : milestones.select{|milestone| sectionEndDate == Date.parse(milestone["date"])}.first["target"]
          start = sectionStartDate == @startDate ? @start : milestones.select{|milestone| sectionStartDate == Date.parse(milestone["date"])}.first["target"]
          expectedDailyProgression = (target - start).to_f / (sectionEndDate - sectionStartDate).to_i
          expectedProgression = expectedDailyProgression * (date - sectionStartDate).to_i + start - @start
        end
      end
      return expectedProgression
    end
    return nil
  end
end

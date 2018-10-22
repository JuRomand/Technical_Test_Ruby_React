#!/usr/bin/env ruby

require "singleton"
require_relative "../utils/readFromFile"

class DataBase
  include Singleton

  attr_reader :objectives, :milestones, :progressRecords
  def initialize()
    @data = readFromFile(("data/input.json"));
    if !data
      puts "No data registered."
    end
    @objectives = @data["objectives"]
    @milestones = @data["milestones"]
    @progressRecords = @data["progress_records"]
  end

  def self.get
    return DataBase.instance
  end

  def self.getObjectives
    objectives = DataBase.get.objectives != nil ? DataBase.get.objectives : false
    if !objectives
      puts "No objectives registered."
    end
    return objectives 
  end

  def self.getMilestones
    milestones = DataBase.get.milestones != nil ? DataBase.get.milestones : false
    if !milestones
      puts "No milestones registered."
    end
    return milestones
  end

  def self.getProgressRecords
    progressRecords = DataBase.get.progressRecords != nil ? DataBase.get.progressRecords : false
    if !progressRecords
      puts "No Progress Records registered."
    end
    return progressRecords
  end
end


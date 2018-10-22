#!/usr/bin/env ruby

require_relative "model/dataBase"
require_relative "controllers/ProgressRecordController"
# require_relative "classes/ObjectiveFollowUpHandler"
require_relative "utils/writeToFile"

if __FILE__ == $0
  progressRecords =  DataBase.getProgressRecords
  excessValues = []
  progressRecords.each do |item|
    record = ProgressRecordController.new(item["id"])
    if record.isValid
      excessValues.push({"id": record.id, "excess": record.getExcessValue})
    end
  end
  output = {"progress_records": excessValues}
  writeToFile("data/ouput.json", output)
end
#!/usr/bin/env ruby

require 'date'

def validateDate(string)
  format_ok = string.match(/\d{4}-\d{2}-\d{2}/)
  parseable = Date.strptime(string, '%Y-%m-%d') rescue false

  if format_ok && parseable
    return true
  else
    return false
  end
end
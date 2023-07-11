require 'fintoc/version'
require 'fintoc/errors'
require 'fintoc/client'

#Name API resources
require 'fintoc/resources'

#Support classes
require 'fintoc/resource'


#API Operations
require 'fintoc/api_operations/request'
require 'fintoc/api_operations/delete'


module Fintoc
  class << self
    attr_accessor :api_key
  end
end

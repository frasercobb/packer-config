# Encoding: utf-8
# Copyright 2014 Ian Chesal
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.

module Packer
  class Variable

    attr_reader :data

    def initialize
      self.data = {}
    end

    def add(key, value)
      self.data[key] = value
    end

    def deep_copy
      Marshal.load(Marshal.dump(self.data))
    end

    class UndefinedVariableError < StandardError
    end

    def method_missing(method_name, *args)
      if self.data.has_key? method_name.to_s
        # Return a packer.io variable reference
        "{{user `#{method_name}`}}"
      else
        raise UndefinedVariableError.new("No variable named #{method_name} has been defined -- did you forget to call #add?")
      end
    end

    def respond_to?(symbol, include_private=false)
      return true if self.data.has_key? symbol.to_s
      case symbol.to_s
      when 'initialize', 'add', 'deep_copy'
        return true
      end
      super
    end

    private
    attr_writer :data
  end
end
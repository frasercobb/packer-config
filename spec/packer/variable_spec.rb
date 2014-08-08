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
require 'spec_helper'
require 'packer/variable'

RSpec.describe Packer::Variable do
  let(:var) do
    Packer::Variable.new
  end

  describe '#add' do
    it 'can store a new variable definition' do
      var.add 'foo', 'bar'
      expect(var.data['foo']).to eq('bar')
    end
  end

  describe '#method_missing' do
    it 'returns a packer.io variable reference string' do
      var.add 'foo', 'bar'
      expect(var.foo).to eq('{{user `foo`}}')
    end

    it 'raises an error if the variable does not exist' do
      expect { var.doesnotexist }.to raise_error
    end
  end

  describe '#deep_copy' do
    it 'retuns a full copy of the data structure' do
      var.add 'foo', 'bar'
      copy = var.deep_copy
      expect(copy).to eq(var.data)
      expect(copy).not_to be(var.data)
      copy['foo'] << 'bar'
      expect(copy).not_to eq(var.data)
    end
  end
end
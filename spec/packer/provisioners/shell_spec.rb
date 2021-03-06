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

RSpec.describe Packer::Provisioner::Shell do
  let(:provisioner) do
    Packer::Provisioner.get_provisioner('shell')
  end

  let(:some_string) do
    'some string'
  end

  let(:some_array_of_strings) do
    %w[commmand1 command2]
  end

  let(:some_array_of_ints) do
    [1, 2, 3]
  end

  describe '#initialize' do
    it 'has a type of shell' do
      expect(provisioner.data['type']).to eq('shell')
    end
  end

  describe '#inline' do
    it 'accepts an array of commands' do
      provisioner.inline(some_array_of_strings)
      expect(provisioner.data['inline']).to eq(some_array_of_strings)
      provisioner.data.delete('inline')
    end

    it 'converts all commands to strings' do
      provisioner.inline(some_array_of_ints)
      expect(provisioner.data['inline']).to eq(some_array_of_ints.map(&:to_s))
      provisioner.data.delete('inline')
    end

    it 'raises an error if the commands argument cannot be made an Array' do
      expect { provisioner.inline(some_string) }.to raise_error
    end

    it 'raises an error if #script or #scripts method was already called' do
      provisioner.data['script'] = 1
      expect { provisioner.inline(some_array_of_strings) }.to raise_error
      provisioner.data.delete('script')
      provisioner.data['scripts'] = 1
      expect { provisioner.inline(some_array_of_strings) }.to raise_error
      provisioner.data.delete('scripts')
    end
  end

  describe '#script' do
    it 'accepts a string' do
      provisioner.script(some_string)
      expect(provisioner.data['script']).to eq(some_string)
      provisioner.data.delete('script')
    end

    it 'converts any argument passed to a string' do
      provisioner.script(some_array_of_ints)
      expect(provisioner.data['script']).to eq(some_array_of_ints.to_s)
      provisioner.data.delete('script')
    end

    it 'raises an error if #inline or #scripts method was already called' do
      provisioner.data['inline'] = 1
      expect { provisioner.script(some_string) }.to raise_error
      provisioner.data.delete('inline')
      provisioner.data['scripts'] = 1
      expect { provisioner.script(some_string) }.to raise_error
      provisioner.data.delete('scripts')
    end
  end

  describe '#scripts' do
    it 'accepts an array of commands' do
      provisioner.scripts(some_array_of_strings)
      expect(provisioner.data['scripts']).to eq(some_array_of_strings)
      provisioner.data.delete('scripts')
    end

    it 'converts all commands to strings' do
      provisioner.scripts(some_array_of_ints)
      expect(provisioner.data['scripts']).to eq(some_array_of_ints.map(&:to_s))
      provisioner.data.delete('scripts')
    end

    it 'raises an error if the commands argument cannot be made an Array' do
      expect { provisioner.scripts(some_string) }.to raise_error
    end

    it 'raises an error if #inline or #script method was already called' do
      provisioner.data['script'] = 1
      expect { provisioner.scripts(some_array_of_strings) }.to raise_error
      provisioner.data.delete('scripts')
      provisioner.data['inline'] = 1
      expect { provisioner.scripts(some_array_of_strings) }.to raise_error
      provisioner.data.delete('scripts')
    end
  end
end

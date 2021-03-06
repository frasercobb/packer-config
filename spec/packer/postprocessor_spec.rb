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

RSpec.describe Packer::PostProcessor do
  POSTPROCESSOR_TYPE = 'vagrant'

  let(:postprocessor) do
    Packer::PostProcessor.new
  end

  let(:overrides) do
    {
      "key1" => "value1",
      "key2" => "value2"
    }
  end

  describe '.get_postprocessor' do
    it 'returns a post-processor' do
      expect(Packer::PostProcessor.get_postprocessor(POSTPROCESSOR_TYPE)).to be_a_kind_of(Packer::PostProcessor)
    end

    it 'raises an error when the post-processor type is not recognized' do
      expect { Packer::PostProcessor.get_postprocessor('unknown-type') }.to raise_error
    end
  end

  describe '#only' do
    it 'adds an only exception' do
      postprocessor.only('thing1')
      expect(postprocessor.data['only']).to eq(%w[thing1])
      postprocessor.only('thing2')
      expect(postprocessor.data['only']).to eq(%w[thing1 thing2])
    end
  end

  describe '#except' do
    it 'adds an execpt exception' do
      postprocessor.except('thing3')
      expect(postprocessor.data['except']).to eq(%w[thing3])
      postprocessor.except('thing4')
      expect(postprocessor.data['except']).to eq(%w[thing3 thing4])
    end
  end

  describe '#keep_input_artifact' do
    it 'accepts any truthy value and converts it to true' do
      postprocessor.keep_input_artifact('this is true')
      expect(postprocessor.data['keep_input_artifact']).to be_truthy
      postprocessor.data.delete('keep_input_artifact')
    end

    it 'accepts any non-truthy value and converts it to false' do
      postprocessor.keep_input_artifact(false)
      expect(postprocessor.data['keep_input_artifact']).to be_falsey
      postprocessor.data.delete('keep_input_artifact')
    end
  end
end
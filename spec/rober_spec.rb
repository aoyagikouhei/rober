require 'spec_helper'

describe Rober do
  it 'should have a version number' do
    expect(Rober::VERSION).to be
  end

  it 'read edm' do
    ober = Rober::Reader.read(FILE)
    entities = ober[:entities]
    expect(entities.size).to eq(2)
    expect(entities[0].attributes.size).to eq(3)
    expect(entities[1].attributes.size).to eq(2)
    expect(entities[0].comment).to match(/\n/)
  end
end

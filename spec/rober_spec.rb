require 'spec_helper'

describe Rober do
  it 'should have a version number' do
    expect(Rober::VERSION).to be
  end

  it 'read edm' do
    ober = Rober::Reader.read(FILE_EDM)
    entities = ober[:entities]
    expect(entities.size).to eq(2)
    expect(entities[0].attributes.size).to eq(3)
    expect(entities[1].attributes.size).to eq(2)
    expect(entities[0].comment).to match(/\n/)
  end

  it 'read dbm' do
    ober = Rober::Reader.read(FILE_DBM)
    entities = ober[:entities]
    expect(entities.size).to eq(2)
    expect(entities[0].attributes.size).to eq(3)
    expect(entities[1].attributes.size).to eq(4)
    expect(entities[0].comment).to eq("aaa\nbbb")
  end
end

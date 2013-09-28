# -*- coding: utf-8 -*-
require 'spec_helper'

describe Column do
  subject { build(:column)}

  it { should respond_to(:name) }

  it "is valid with name" do
    expect(build(:column, name: '行情')).to be_valid
  end
  it "is invalid without name" do
    expect(build(:column, name: nil)).to have(1).errors_on(:name)
  end
  it "is invalid with duplicate name" do
    create(:column, name:'行情')
    expect(build(:column, name: '行情')).to have(1).errors_on(:name)
  end
  it "its to_param is id-name" do
    column = build(:column)
    expect(column.to_param).to eq "#{column.id}-#{column.name}"
  end

end

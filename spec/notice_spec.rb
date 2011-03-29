# -*- coding: utf-8 -*-
require 'spec_helper'

describe Notice do
  it { should belong_to(:user) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:message) }
  context "помечается как доставленная" do
    subject { Factory :notice }
    it { should_not be_delivered }
  end
end

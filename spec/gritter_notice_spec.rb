# -*- coding: utf-8 -*-
require 'spec_helper'

describe GritterNotice do
  it { should be_fresh }
  it { should_not be_delivered }

  describe '#mark_as_delivered' do
    subject { create :notice }
    it 'destroys after delivering' do
      subject.should_receive(:destroy_after_deliver?) { true }
      subject.mark_as_delivered
      subject.should be_destroyed
    end

    it 'marks as delivered after delivering' do
      subject.should_receive(:destroy_after_deliver?) { false }
      subject.mark_as_delivered
      subject.should be_delivered
    end
  end
end

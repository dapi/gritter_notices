# -*- coding: utf-8 -*-
require 'spec_helper'

describe User do
  specify { User.should respond_to(:has_gritter_notices) }
  it { should have_many(:gritter_notices) }
  it { should respond_to(:gritter_notice) }

  describe '#notice' do
    subject { Factory :user }

    it 'gets message with string' do
      subject.notice 'some text'
      subject.should have_gritter_notice('some text')
      subject.gritter_notices.last.options[:level].should == :notice
      subject.gritter_notices.last.options[:gritter_key].should == nil
    end

    it 'gets message with attribute' do
      subject.notice :text=>'some text2', :level=>:success
      subject.should have_gritter_notice('some text2')
      subject.gritter_notices.last.options[:gritter_key].should be_nil
      subject.gritter_notices.last.options[:level].should == :success
    end

    it 'gets message with symbol' do
      subject.notice :warning
      last = subject.gritter_notices.last
      last.text.should == 'translation missing: en.gritter_notices.warning'
      last.options[:gritter_key].should == :warning
      last.options[:level].should == :warning
    end

    it 'catches messages as missed method' do
      subject.notice_error 'big problem'
      subject.should have_gritter_notice('big problem')
      subject.gritter_notices.last.options[:level].should == :error
    end

    it do
      subject.gritter_notice :progress, :title=>'Supertitle', :text=>'Supertext'
      last = subject.gritter_notices.last
      last.options[:level].should == :progress
      last.options[:title].should == 'Supertitle'
      last.text.should == 'Supertext'
    end

  end
end

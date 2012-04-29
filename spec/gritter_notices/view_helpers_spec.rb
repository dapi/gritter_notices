# -*- coding: utf-8 -*-
require 'spec_helper'

describe GritterNotices::ViewHelpers, :type => :helper  do
  before do
    @user = Factory :user
    helper.stub!(:current_user) { @user }
  end

  let(:current_user) { @user }
  # let(:flash) { {:success=>'Success',:error=>['Error1','Error2']} }

  describe '#gritter_flash_messages' do
    it 'safe run with not current_user defined' do
      helper.unstub :current_user
      expect { helper.gritter_flash_messages }.should_not raise_error
    end

    it 'does not run js() if there it no gritters' do
      helper.should_not_receive(:js)
      helper.gritter_flash_messages
    end

    it 'collects flashes and users notices and run js()' do

      flash[:error]='Error'
      flash[:success]=['Success1','Success2']
      flash[:info]=nil
      current_user.gritter_notice :progress, :title=>'Supertitle', :text=>'Supertext'
      current_user.notice_warning 'Warning Warning'

      compiled_gritters = 
        [
          "jQuery(function(){jQuery.gritter.add({image:'/assets/error.png',title:'translation missing: en.gflash.titles.error',text:'Error'});});",
          "jQuery(function(){jQuery.gritter.add({image:'/assets/progress.png',title:'Supertitle',text:'Supertext'});});",
          "jQuery(function(){jQuery.gritter.add({image:'/assets/success.png',title:'translation missing: en.gflash.titles.success',text:'Success1'});});",
          "jQuery(function(){jQuery.gritter.add({image:'/assets/success.png',title:'translation missing: en.gflash.titles.success',text:'Success2'});});",
          "jQuery(function(){jQuery.gritter.add({image:'/assets/warning.png',title:'translation missing: en.gflash.titles.warning',text:'Warning Warning'});});"
    ].sort
      #helper.should_receive(:js).with(compiled_gritters) { mock :html_safe=>true }
      helper.should_receive(:js) do |args|
        args.sort.should == compiled_gritters
        mock :html_safe=>true
      end
      helper.gritter_flash_messages
    end
  end

  describe '#move_gritter_notices_to_flashes' do
    specify do
      notice = mock :level=>:level, :text=>'text'
      notice.should_receive(:mark_as_delivered).twice
      current_user.stub_chain('gritter_notices.fresh') {[notice,notice]}
      helper.should_receive(:append_flash_message).twice
      helper.move_gritter_notices_to_flashes
    end
  end
end

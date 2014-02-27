# -*- coding: utf-8 -*-
#
# Сообщения от системы пользователю для отображения их через flash. Например:
#
#   :import_contacts - импортированы контакты
#   :import_events - импортированы мероприятия
#
# Сообщения посылаются так:
#
#   user.notice :import_contacts, :provider=>:facebook
#
# Тексты сообщений описываются в локали

class GritterNotice < ActiveRecord::Base
  belongs_to :owner, :polymorphic=>true

  scope :delivered, -> { where("delivered_at is not nul").order('delivered_at') }
  scope :fresh, -> { where("delivered_at is null").order('created_at').limit(5) }

  serialize :options, Hash

  before_validation :set_options
  validates_presence_of :owner, :text

  def fresh?
    delivered_at.blank?
  end

  def delivered?
    not fresh?
  end

  def destroy_after_deliver?
    true
  end

  def mark_as_delivered
    if destroy_after_deliver?
      destroy
    else
      update_attribute :delivered_at, Time.now
    end
  end

  private

  def set_options
    self.options={} unless self.options
  end
end

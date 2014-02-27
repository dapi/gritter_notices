FactoryGirl.define do
  factory :user do |u|
    u.name 'Bob'
  end

  factory :notice, :class=>'GritterNotice' do |f|
    f.association :owner, :factory=>:user
    f.text "MyText"
  end
end

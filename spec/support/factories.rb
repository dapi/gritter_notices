Factory.define :user do |u|
  u.name 'Bob'
end

Factory.define :notice, :class=>'GritterNotice' do |f|
  f.association :user
  f.message "MyText"
end

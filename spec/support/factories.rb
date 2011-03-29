Factory.define :user do |u|
  u.name 'Bob'
end

Factory.define :notice, :class=>'GritterNotice' do |f|
  f.association :owner, :factory=>:user
  f.message "MyText"
end

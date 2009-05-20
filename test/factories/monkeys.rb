Factory.sequence(:name) { |n| "Monkey #{n}" }
Factory.sequence(:age) { |n| n }

Factory.define :monkey do |monkey|
  monkey.name { Factory.next(:name) }
  monkey.age { rand(3) + 1 }
end
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.destroy_all
Challenge.destroy_all
Task.destroy_all
ActionDate.destroy_all


user = User.create!(first_name: "Anders Butzbach", last_name: "Christensen", birthday: "29/01/1993", username: "fyren", phone: "22770695", email: "ak@kviksoft.com", password: "test1234", gender: "male", active: true)

challenge = Challenge.create!(title: "Månedens program", prize: "En tur i biografen", user: user)

task2 = Task.create!(title: "Tirsdag", challenge: challenge)

action2 = Action.create!(name: "Aften", task: task2)

ActionDate.create!(date: "2016-01-01", task: task2)

Actionmodule.create!(text: "Løb 5 km", action:action2)
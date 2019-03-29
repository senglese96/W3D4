# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'

# 50.times do 
#     User.create!(username: Faker::Name.name)
# end

# 50.times do
#     Poll.create!(author_id: User.all.sample.id, title: Faker::Lorem.sentence)
# end

# 50.times do
#     Question.create!(poll_id: Poll.all.sample.id, question: Faker::Shakespeare.hamlet_quote)
# end

50.times do
    AnswerChoice.create!(question_id: Question.all.sample.id, choice: Faker::ChuckNorris.fact)
end

50.times do
    Response.create!(answer_id: AnswerChoice.all.sample.id, user_id: User.all.sample.id)
end
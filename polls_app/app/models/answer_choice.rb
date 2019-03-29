# == Schema Information
#
# Table name: answer_choices
#
#  id          :bigint(8)        not null, primary key
#  question_id :integer          not null
#  choice      :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class AnswerChoice < ApplicationRecord
    validates :question_id, :choice, presence: true

    belongs_to(
        :question,
        class_name: 'Question',
        foreign_key: :question_id,
        primary_key: :id
    )

    has_many(
        :responses,
        class_name: :Response,
        foreign_key: :answer_id,
        primary_key: :id
    )
end

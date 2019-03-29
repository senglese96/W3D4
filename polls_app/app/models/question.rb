# == Schema Information
#
# Table name: questions
#
#  id         :bigint(8)        not null, primary key
#  poll_id    :integer          not null
#  question   :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Question < ApplicationRecord
    validates :poll_id, :question, presence: true

    belongs_to(
        :poll,
        class_name: 'Poll',
        foreign_key: :poll_id,
        primary_key: :id
    )

    has_many(
        :answer_choices,
        class_name: 'AnswerChoice',
        foreign_key: :question_id,
        primary_key: :id
    )

    has_many(
        :responses,
        through: :answer_choices,
        source: :responses
    )

    def results
        answers = answer_choices
        response_counts = Hash.new
        answers.each do |answer|
            response_counts[answer.choice] = answer.responses.count
        end
        response_counts
    end

    def better_results
        answers = answer_choices.includes(:responses)
        response_counts = Hash.new
        answers.each do |answer|
            response_counts[answer.choice] = answer.responses.count
        end
        response_counts
    end

    def penultimate_results
        Question.find_by_sql([<<-SQL, self.id])
            SELECT answer_choices.*, COUNT(responses.answer_id)
            FROM answer_choices
            LEFT OUTER JOIN responses ON responses.answer_id = answer_choices.id
            WHERE answer_choices.question_id = ?
            GROUP BY answer_choices.id
        SQL
    end

    def best_results
        self.answer_choices.select("answer_choices.*, COUNT(responses.answer_id)")
        .left_outer_joins(:responses)
        .where(answer_choices: { question_id: self.id})
        .group(:id)
    end
end

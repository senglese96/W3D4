# == Schema Information
#
# Table name: responses
#
#  id         :bigint(8)        not null, primary key
#  user_id    :integer          not null
#  answer_id  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Response < ApplicationRecord
    validates :user_id, :answer_id, presence: true
    validate :not_duplicate_response, :author_cant_respond

    belongs_to(
        :answer_choice,
        class_name: 'AnswerChoice',
        foreign_key: :answer_id,
        primary_key: :id
    )

    belongs_to(
        :respondent,
        class_name: 'User',
        foreign_key: :user_id,
        primary_key: :id
    )

    has_one(
        :question,
        through: :answer_choice,
        source: :question
    )

    has_one(
        :poll,
        through: :question,
        source: :poll
    )

    def sibling_responses
        question.responses.where.not(responses: {id: self.id})
    end

    def respondent_already_answered?
        sibling_responses.any? do |sibling|
            sibling.user_id == self.user_id
        end
    end

    private
    def not_duplicate_response
        if respondent_already_answered?
            errors[:user_id] << 'repeat user id'
        end
    end

    def author_cant_respond
        if self.question.poll.author_id == self.user_id
            errors[:user_id] << "author can't respond to own poll"
        end
    end
end

# == Schema Information
#
# Table name: users
#
#  id         :bigint(8)        not null, primary key
#  username   :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ApplicationRecord
    validates :username, presence: true, uniqueness: true

    has_many(
        :authored_polls,
        class_name: 'Poll',
        foreign_key: :author_id,
        primary_key: :id
    )

    has_many(
        :responses,
        class_name: :Response,
        foreign_key: :user_id,
        primary_key: :id
    )
end

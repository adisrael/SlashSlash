class PollVote < ApplicationRecord
  belongs_to :poll
  belongs_to :user
  belongs_to :poll_option
end

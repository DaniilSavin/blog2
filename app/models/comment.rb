class Comment < ApplicationRecord
  attr_accessor :username, :body, :mark, :post_id
  validates :username, :body, :mark, :post_id, presence: true
  belongs_to :post
end

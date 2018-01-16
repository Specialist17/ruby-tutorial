class User < ApplicationRecord
    has_many :memos
    validates :name, presence: true
    validates :email, presence: true, uniqueness: true
end

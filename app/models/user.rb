class User < ApplicationRecord
    has_many :memos
    validates :name, presence: true
    validates :email, presence: true, uniqueness: true

    # 1. Hash password before saving a user
    before_save :encrypt_password

    # 2. Generate a token for authentication before creating a User
    before_create :generate_token

    # 3. Adds a virtual password field, which we will use when creating a user
    attribute :password, :string

    # Checks if a user is authenticated
    def self.authentication(email, password)
        user = self.find_by_email(email)
        if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
            user
        else
            nil
        end
    end

    # Salts and hashes a user's password
    def encrypt_password 
        if password.present?
            self.password_salt = BCrypt::Engine.generate_salt
            self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
        end
    end

    #Generates a token for a user
    def generate_token
        token_gen = SecureRandom.hex
        self.token = token_gen
        token_gen
    end
end

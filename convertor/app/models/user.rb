class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
	has_many :requests, dependent: :destroy
	has_many :converter_apis
	belongs_to :level

	def has_requests?
		requests.newest.size < level.max_requests
	end
end

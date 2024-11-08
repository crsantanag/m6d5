class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :offers
  has_many :postulations, dependent: :destroy

  has_one_attached :image

  enum :role, [ :normal, :owner, :admin ]

  validates :name,
    presence: { message: "No puede estar vacío" },
    length: { in: 2..100, message: "debe tener entre 2 y 100 caracteres" }

  validates :curriculum,
    length: { in: 0..2000, message: "debe tener entre 2 y 2000 caracteres" }
end

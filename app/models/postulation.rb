class Postulation < ApplicationRecord
  belongs_to :user
  belongs_to :offer

  validates :message,
  presence: { message: "- no puede estar vacío" },
  length: { in: 1..2000, message: "- debe tener entre 2 y 2000 caracteres" }
end

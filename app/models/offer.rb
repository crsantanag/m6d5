class Offer < ApplicationRecord
  belongs_to :user
  has_many   :postulations, dependent: :destroy

  validates :title,
  presence: { message: "- no puede estar vacío" },
  length: { in: 2..100, message: "- debe tener entre 2 y 100 caracteres" }

  validates :description,
  presence: { message: "- no puede estar vacío" },
  length: { in: 2..1000, message: "- debe tener entre 2 y 1000 caracteres" }

  validate :date_from_tomorrow

  private

  def date_from_tomorrow
    if limit.present? && limit <= Date.today
      errors.add(:date, "- la fecha debe ser a partir de mañana")
    end
  end
end

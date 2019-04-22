class Issue < ApplicationRecord

  # Issue Types - Must correspond with the ones in the Front-End in  >>  "src/constants/IssueTypes.jsx"
  # These ids refer to the custom_id of the model, already set in the seed data.
  CARD_INFORMATION_MISSING = 1

  has_many :issue_solutions, dependent: :delete_all

  def sanitazed_info
    {
        id: id,
        title: title,
        description: description,
        solutions: IssueSolution.where(:issue_id => id)
    }
  end

end

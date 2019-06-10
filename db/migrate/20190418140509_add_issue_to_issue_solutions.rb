class AddIssueToIssueSolutions < ActiveRecord::Migration[5.2]
  def change
    add_reference :issue_solutions, :issue, :foreign_key => true
  end
end

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#

# ADD Initial Issues
#
# #TODO: Add custom ID when creating issue

# 1. Card information NOT added issue
card_issue = Issue.where(
    {title: "Card information is missing",
     description: "In order to process any payment or transaction you'll need this information added in your account.",
     custom_id: 1
    }).first_or_create!

solutions = [
    {description: "Go to your profile settings, click on add payment method. Then, introduce your credit/debit card information and click on Save card", velocity: "FASTEST", issue_id: card_issue[:id]},
    {description: "Send and email to support@pierpontglobal.com requesting to add a new credit/debit card information.", velocity: "FAST", issue_id: card_issue[:id]}
]

to_add_solutions = []
solutions.each do |s|
  existing = IssueSolution.find_by(:description => s[:description], :velocity => s[:velocity], :issue_id => s[:issue_id])
  if !existing.present?
    to_add_solutions.append(IssueSolution.create!(s))
  else
    to_add_solutions.append(existing)
  end
end

card_issue.issue_solutions = to_add_solutions

# 2.
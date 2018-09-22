class RelationQuestionToUser < ActiveRecord::Migration[5.2]
  def change
    create_table :users_questions, id: false do |t|
      t.references :user, foreign_key: true
      t.references :question, foreign_key: true
      t.string :answer
    end

    execute 'ALTER TABLE users_questions ADD PRIMARY KEY (user_id, question_id);'
  end
end

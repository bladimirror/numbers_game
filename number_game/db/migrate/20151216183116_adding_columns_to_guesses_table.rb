class AddingColumnsToGuessesTable < ActiveRecord::Migration
  def change
  	add_column :guesses, :user_guess, :integer
  end
end

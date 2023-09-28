class CreateExcavators < ActiveRecord::Migration[7.0]
  def change
    create_table :excavators do |t|
      t.string :company_name, null: false
      t.string :address, null: false
      t.boolean :crew_on_site, null: false
      t.references :ticket, null: false, foreign_key: true # NOTE: using dependent: :destroy on Ticket model, rather than on delete cascade

      t.timestamps
    end
  end
end

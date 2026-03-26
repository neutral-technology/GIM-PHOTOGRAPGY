class AddFidelityToClients < ActiveRecord::Migration[7.0]
  def change
    add_column :clients, :fidelity_points, :integer
    add_column :clients, :fidelity_level, :string
  end
end

Sequel.migration do
  change do
    alter_table :cars do
      add_index :plate
      add_index :time_start
    end
  end
end

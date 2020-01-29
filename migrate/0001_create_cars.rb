Sequel.migration do
  change do
    create_table(:cars) do
      primary_key :id

      Integer :cam_id
      String  :country, null: false
      String  :plate, null: false
      column  :plates, :jsonb
      String  :vehicle_crop
      String  :plate_crop

      DateTime :time_start
      DateTime :time_end
    end
  end
end

require "oj"

class Car < Sequel::Model
  def self.create_from_feed(data)
    Car.create(
      cam_id: data["camera_id"],
      country: data["country"],
      plate: data.dig("best_plate", "plate"),
      plates: Oj.dump(data["candidates"]),
      vehicle_crop: data["vehicle_crop_jpeg"],
      plate_crop: data.dig("best_plate", "plate_crop_jpeg"),

      time_start: Time.at(0, data["epoch_start"], :millisecond),
      time_end: Time.at(0, data["epoch_end"], :millisecond)
    )
  end

  # Hijack console display since
  # vehicle_crop and plate_crop is too huge (base64)
  def inspect
    "<Car @values=#{values.slice(:cam_id, :country, :plate, :time_start, :time_end)}>"
  end
end

# make_model: data.dig("vehicle", "make_model", 0, "name"),
# make_models: data.dig("vehicle", "make_model").map {|m| m["name"] }.join(","),

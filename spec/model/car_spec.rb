require_relative "spec_helper"
require "oj"

describe Car do
  describe ".create_from_feed" do
    it "should create from data" do
      file = File.open("./sample_data/pretty.json")
      hash = Oj.load(file)

      car = Car.create_from_feed(hash)

      _(car.cam_id).wont_be_nil
      _(car.country).wont_be_nil
      _(car.plate).wont_be_nil
      _(car.plate).must_equal("WC3918Y")
    end
  end
end

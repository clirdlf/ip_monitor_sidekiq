require 'rails_helper'

RSpec.describe Resource, type: :model do

  before(:each) do 
    @resource = create(:resource)
  end

  it "has a valid factory" do
    expect(@resource).to be_valid
  end

  it "has many statuses" do
    should respond_to(:statuses)
  end

  it "has a csv output" do
    # @see https://www.andrewsouthpaw.com/testing-an-attachment-with-rspec-and-controllers/ for controller

    # format.csv { send_data @resources.to_csv, filename: "grant-resources-#{Time.zone.today}.csv" }

  end

end

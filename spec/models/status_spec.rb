require 'rails_helper'

RSpec.describe Status, type: :model do

  before(:each) do 
    # @grant = create(:grant)
    @resource = create(:resource)
    @status = create(:status)
  end

  it "has a valid factory" do
    expect(@resource).to be_valid
  end

  it "gets a latest status" do
    expect(@status.latest).to be_truthy
  end
end

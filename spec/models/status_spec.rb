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

  it "updates its status" do
    # https://gist.github.com/rahsheen/b428cd24f4f4b1141951d9f8f23a972f
    # response = Net::HTTPSuccess.new(1.0, '200', 'OK')
    # expect_any_instance_of(Net::HTTP).to receive(:request) { response }
  end

  it "gets a latest status" do
    @status.latest = true
    expect(@status.latest).to be_truthy
    @status.latest = false
    expect(@status.latest).to be_falsey
  end
end

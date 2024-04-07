require 'rails_helper'

RSpec.describe ResourceValidatorJob, type: :job do

  before(:each) do 
    @resource = create(:resource)
  end

  it "performs a job and returns a status code" do
    # https://gist.github.com/rahsheen/b428cd24f4f4b1141951d9f8f23a972f
    # response = Net::HTTPSuccess.new(1.0, '200', 'OK')
    # expect_any_instance_of(Net::HTTP).to receive(:request) { response }


  end
end

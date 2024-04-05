require 'rails_helper'

RSpec.describe Resource, type: :model do

  before(:each) do 
    @resource = create(:resource)

    # let(:statuses) { create_list(:status, 10)}
    # @invalid_resource = create(:invalid_resource)
  end

  it 'has a valid factory' do
    expect(@resource).to be_valid
  end

  it 'has many statuses' do
    should respond_to(:statuses)
  end

  it 'responds to current status' do
    should respond_to(:current_status)
  end
  it 'has a current status' do
    expect(@resource.current_status).to eq(Status.last)
  end

  it 'has recent status' do
    expect(@resource.recent_status).to have_key(:count)
    expect(@resource.recent_status).to have_key(:ok)
    expect(@resource.recent_status[:count]).to eq(0)

    @resource.statuses.create!(response_code: 200)
    expect(@resource.recent_status[:count]).to eq(1)
  end

  it 'checks for valid URLs' do
    expect(@resource.valid_url?).to be_truthy

    @resource.access_url = 'c:/foo/bar'
    expect(@resource.valid_url?).to be_falsey

    @resource.access_url = 'hello world'
    expect(@resource.valid_url?).to be_falsey
  end

  it 'returns the latest status' do
    expect(@resource.latest_status).to be(nil)
    
    @resource.statuses.create!(response_code: 200)
    expect(@resource.latest_status).to be(nil)

  end

  it 'calculates a recent_status_core' do

    @resource.statuses.create!(response_code: 200)
    expect(@resource.recent_status_score).to eq(1)

    @resource.statuses.create!(response_code: 801)
    expect(@resource.recent_status_score).to eq(0.5)

  end

  it 'has a csv output' do
    # @see https://www.andrewsouthpaw.com/testing-an-attachment-with-rspec-and-controllers/ for controller

    # format.csv { send_data @resources.to_csv, filename: 'grant-resources-#{Time.zone.today}.csv' }

  

  end

end

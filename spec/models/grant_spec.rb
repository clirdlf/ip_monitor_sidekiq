require 'rails_helper'

RSpec.describe Grant, type: :model do

  before(:all) do
    @grant = create(:grant)
  end

  it "has a valid factory" do
    expect(@grant).to be_valid
  end

  it "is not valid without a title" do
    grant2 = build(:grant, title: nil)
    expect(grant2).to_not be_valid
  end

  it "is not valid without an institution" do
    grant2 = build(:grant, institution: nil)
    expect(grant2).to_not be_valid
  end

  it "is not valid without an grant_number" do
    grant2 = build(:grant, grant_number: nil)
    expect(grant2).to_not be_valid
  end

  it "is not valid without a contact" do
    grant2 = build(:grant, contact: nil)
    expect(grant2).to_not be_valid
  end

  it "is not valid without an email" do
    grant2 = build(:grant, email: nil)
    expect(grant2).to_not be_valid
  end

  it "is not valid without a submission date" do
    grant2 = build(:grant, submission: nil)
    expect(grant2).to_not be_valid
  end

  it "has many resources" do 
    should respond_to(:resources)
  end

  it "has many statuses" do
    should respond_to(:statuses)
  end


end

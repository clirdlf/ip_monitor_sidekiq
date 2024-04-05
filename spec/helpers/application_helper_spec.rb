require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#flash_class' do
    it 'returns a message class' do
      expect(helper.flash_class('notice')).to eq('alert alert-info')
    end
  end
end

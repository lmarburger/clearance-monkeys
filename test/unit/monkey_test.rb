require 'test_helper'

class MonkeyTest < ActiveSupport::TestCase
  context 'A monkey' do
    should_belong_to :user
  end
end

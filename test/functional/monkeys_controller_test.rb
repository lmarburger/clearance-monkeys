require 'test_helper'

class MonkeysControllerTest < ActionController::TestCase
  context 'Given monkeys' do
    setup { 3.times { Factory(:monkey) } }

    context 'when viewing' do
      setup { get :index }

      should_assign_to(:monkeys) { Monkey.all }
    end
  end

  context 'Given a monkey' do
    setup { @test_monkey = Factory(:monkey) }

    context 'when viewing' do
      setup { get :show, :id => @test_monkey }
      should_assign_to(:monkey) { @test_monkey }
    end

    context 'when editing' do
      setup { get :edit, :id => @test_monkey }
      should_assign_to(:monkey) { @test_monkey }
    end

    context 'when deleting' do
      setup { delete :destroy, :id => @test_monkey }

      should_assign_to(:monkey) { @test_monkey }
      should_change 'Monkey.count', :from => 1, :to => 0
      should_redirect_to('the monkeys list') { monkeys_url }
    end

    context 'when updating' do
      setup do
        @data = Factory.attributes_for(:monkey)
        put :update, :id => @test_monkey, :monkey => @data
      end

      should_assign_to(:monkey) { @test_monkey }
      should_not_change 'Monkey.count'
      should_redirect_to('the monkey') { monkey_url(@test_monkey) }

      should 'update attributes' do
        @test_monkey.reload

        @test_monkey.name.should == @data[:name]
        @test_monkey.age.should == @data[:age]
      end
    end
  end

  context 'Viewing the creation form' do
    setup { get :new }
    should_assign_to(:monkey)
  end

  context 'Creating a new monkey' do
    setup do
      @data = Factory.attributes_for(:monkey)
      post :create, :monkey => @data

      @new_monkey = Monkey.first
    end

    should_redirect_to('the monkey') { monkey_url(@new_monkey) }

    should 'create attributes' do
      @new_monkey.name.should == @data[:name]
      @new_monkey.age.should == @data[:age]
    end
  end
end

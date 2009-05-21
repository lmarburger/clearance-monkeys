require 'test_helper'

class MonkeysControllerTest < ActionController::TestCase
  context 'Given an anonymous user' do
    context 'when viewing monkeys' do
      setup { get :index }
      should_deny_access
    end

    context 'and a monkey' do
      setup { @test_monkey = Factory :monkey }

      context 'when viewing the monkey' do
        setup { get :show, :id => @test_monkey }
        should_deny_access
      end

      context 'when editing the monkey' do
        setup { get :edit, :id => @test_monkey }
        should_deny_access
      end

      context 'when deleting the monkey' do
        setup { delete :destroy, :id => @test_monkey }
        should_deny_access
      end

      context 'when updating the monkey' do
        setup { put :update, :id => @test_monkey }
        should_deny_access
      end

      context 'when viewing the creation form' do
        setup { get :new }
        should_deny_access
      end

      context 'when creating a monkey' do
        setup { post :create }
        should_deny_access
      end
    end
  end

  context 'Given an authenticated user' do
    setup { @current_user = sign_in }

    context 'and monkeys' do
      setup do
        # Generate some monkeys that belong to the user
        3.times { Factory :monkey, :user => @current_user }

        # Get all the current user's monkeys.
        @users_monkeys = Monkey.all

        # Generate some monkeys belonging to another user
        3.times { Factory :monkey }
      end

      context 'when viewing all' do
        setup { get :index }

        should_respond_with :success
        should_assign_to(:monkeys) { @users_monkeys }
      end
    end

    context 'and a single monkey' do
      setup do
        @their_monkey = Factory :monkey, :user => @current_user
        @other_monkey = Factory :monkey
      end

      context 'when viewing their monkey' do
        setup { get :show, :id => @their_monkey }
        should_assign_to(:monkey) { @their_monkey }
      end

      context 'when viewing another monkey' do
        should 'raise a record not found exception' do
          assert_raise(ActiveRecord::RecordNotFound) { get :show, :id => @other_monkey }
        end
      end

      context 'when editing their monkey' do
        setup { get :edit, :id => @their_monkey }
        should_assign_to(:monkey) { @their_monkey }
      end

      context 'when editing another monkey' do
        should 'raise a record not found exception' do
          assert_raise(ActiveRecord::RecordNotFound) { get :edit, :id => @other_monkey }
        end
      end

      context 'when deleting their monkey' do
        setup { delete :destroy, :id => @their_monkey }

        should_assign_to(:monkey) { @their_monkey }
        should_change 'Monkey.count', :by => -1
        should_redirect_to('the monkeys list') { monkeys_url }
      end

      context 'when deleting another monkey' do
        should 'raise a record not found exception' do
          assert_raise(ActiveRecord::RecordNotFound) { delete :destroy, :id => @other_monkey }
        end
      end

      context 'when updating their monkey' do
        setup do
          @data = Factory.attributes_for :monkey
          put :update, :id => @their_monkey, :monkey => @data
        end

        should_assign_to(:monkey) { @their_monkey }
        should_not_change 'Monkey.count'
        should_redirect_to('the monkey') { monkey_url @their_monkey }

        should 'update attributes' do
          @their_monkey.reload

          @their_monkey.name.should == @data[:name]
          @their_monkey.age.should == @data[:age]
        end
      end

      context 'when updating another monkey' do
        should 'raise a record not found exception' do
          assert_raise(ActiveRecord::RecordNotFound) { put :update, :id => @other_monkey }
        end
      end
    end

    context 'when viewing the creation form' do
      setup { get :new }

      should 'assign a blank monkey belonging to the current user to @monkey' do
        assigns(:monkey).user.should == @current_user
      end
    end

    context 'when creating a new monkey' do
      setup do
        @data = Factory.attributes_for :monkey
        post :create, :monkey => @data

        @new_monkey = Monkey.first
      end

      should_redirect_to('the monkey') { monkey_url @new_monkey }

      should 'create attributes' do
        @new_monkey.name.should == @data[:name]
        @new_monkey.age.should == @data[:age]
      end

      should 'belong to the current user' do
        @new_monkey.user.should == @current_user
      end
    end
  end
end

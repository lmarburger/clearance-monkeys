class MonkeysController < ApplicationController

  before_filter :authenticate
  before_filter :load_monkey, :only => [ :show, :edit, :update, :destroy ]

  def index
    @monkeys = current_user.monkeys
  end

  def show
  end

  def new
    @monkey = current_user.monkeys.new
  end

  def edit
  end

  def create
    monkey = current_user.monkeys.create(params[:monkey])
    redirect_to monkey
  end

  def update
    @monkey.update_attributes(params[:monkey])
    redirect_to @monkey
  end

  def destroy
    @monkey.destroy
    redirect_to monkeys_url
  end

  private

    def load_monkey
      @monkey = current_user.monkeys.find(params[:id])
    end
end

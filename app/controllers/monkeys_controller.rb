class MonkeysController < ApplicationController

  before_filter :load_monkey, :only => [ :show, :edit, :update, :destroy ]

  def index
    @monkeys = Monkey.all
  end

  def show
    @monkey = Monkey.find(params[:id])
  end

  def new
    @monkey = Monkey.new
  end

  def edit
  end

  def create
    monkey = Monkey.create(params[:monkey])
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
      @monkey = Monkey.find(params[:id])
    end
end

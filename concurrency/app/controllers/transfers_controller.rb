class TransfersController < ApplicationController

  respond_to :json

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  before_filter :source_account, :target_account, :amount, only: :create

  def create
    use_case = TransferMoney.call(source_account: source_account, target_account: target_account, amount: amount)
    if use_case.success?
      render json: { success: true }, status: :ok
    else
      render json: { success: false, message: use_case.message }, status: :bad_request
    end
  end

  def show
    account = Account.find(params[:id])
    render json: { balance: account.balance }, status: :ok
  end

  def index
    account_ids = Account.pluck(:id)
    render json: { account_ids: account_ids }, status: :ok
  end

  private

  def source_account
    Account.find(params[:source_account_id])
  end

  def target_account
    Account.find(params[:target_account_id])
  end

  def amount
    params[:amount]
  end

  def record_not_found
    render status: 404
  end

end
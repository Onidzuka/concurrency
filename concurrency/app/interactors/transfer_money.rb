class TransferMoney
  include Interactor

  def call
    begin
      Account.transaction do
        # context.source_account.lock!
        # context.target_account.lock!

        context.source_account.balance -= 50
        context.source_account.save!

        context.target_account.balance += 50
        context.target_account.save!
      end
    rescue Exception => e
      context.message = e
      context.fail!
    end
  end
end
require 'httparty'
require 'pry-byebug'

class ModWallet
  include HTTParty

  base_uri '127.0.0.1:3001'

  def transfer_funds(source, target, amount)
    self.class.post('/transfers', {
      query: {
        source_account_id: source,
        target_account_id: target,
        amount: amount
      }
    })
  end

  def get_balance(account)
    response = self.class.get("/transfers/#{account}")
    response['balance']
  end

  def get_all_accounts_ids
    response = self.class.get('/transfers')
    response['account_ids']
  end

end

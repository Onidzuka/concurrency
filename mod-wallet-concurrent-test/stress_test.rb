require_relative 'mod-wallet'
require 'parallel'

class Application
  attr_accessor :accounts, :wallet

  def initialize
    self.accounts = []
    self.wallet   = ModWallet.new
  end

  def run
    puts 'Accounts balances'
    puts accounts_balances.inspect
    puts "total #{total_money}"
    puts "----------------------------------------------------"

    money_account = accounts.first

    Parallel.map(1..500, in_processes: 4) do
      recipient = (accounts - [money_account]).sample

      puts wallet.transfer_funds(money_account, recipient, 50)
      money_account = recipient
    end

    puts 'Accounts balances'
    puts accounts_balances.inspect
    puts "total #{total_money}"
  end

  def accounts_balances
    self.accounts = wallet.get_all_accounts_ids
    self.accounts.map do |account|
      [account, wallet.get_balance(account)]
    end
  end

  def total_money
    total = 0
    balances = accounts_balances

    balances.each do |b|
      total += b[1]
    end

    total
  end
end

Application.new.run
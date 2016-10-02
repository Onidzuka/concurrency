require 'rails_helper'

describe 'transfer money' do

  it do
    puts 'Account balances'
    total_money = Account.sum('balance')
    puts "Total: #{total_money}"
    puts '-----------------'

    money_account = Account.first
    all_accounts = Account.all

    Parallel.map(1..200, in_threads: 4) do
      Account.transaction do
        recipient = (all_accounts - [money_account]).sample

        begin
          money_account.balance -= 50
          money_account.save!

          recipient.balance += 50
          recipient.save!
        rescue
          raise ActiveRecord::Rollback
        end

        money_account = recipient
      end
    end

    puts 'Accounts balances'
    all_accounts.each do |account|
      puts "Account #{account.id} = #{account.balance}"
    end

    puts "total #{total_money}"
  end

end
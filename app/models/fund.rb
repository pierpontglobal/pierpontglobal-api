# frozen_string_literal: true

class Fund < ApplicationRecord
  belongs_to :user
  belongs_to :payment, optional: true

  def total
    balance
  end

  def holdings
    holding
  end

  def available
    (total - holdings)
  end

  def release_from_bid(bid)
    amount = bid.amount
    bid.update!(
      status: 'inactive'
    )

    Fund.create!(
      payment: nil,
      balance: balance,
      amount: 0,
      credit: false,
      holding: holding - amount,
      user: user,
      source_id: 'Releasing fund'
    )
  end

  private
end

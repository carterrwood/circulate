class MembersController < ApplicationController
  def history
    @loans = current_member.loans.order(ended_at: :desc)
    # This could be appended to only show items that have been checked in
    # if it's decided this page shouldn't show currently checked-out items:
    # .where.not(loans: { ended_at: nil })
  end

  def loans
    @loans = current_member.loans.includes(:item).order(:due_at)
    @holds = current_member.holds.includes(:item)
  end

  def renew
    @loan = Loan.find(params[:id])
    authorize @loan, :renew?

    @loan.renew!
    redirect_to member_loans_path
  end

  def delete_hold
    current_member.holds.find(params[:id]).destroy!
    redirect_to member_loans_path
  end
end

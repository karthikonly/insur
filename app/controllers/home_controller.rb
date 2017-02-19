class HomeController < ApplicationController
  def index
    if current_user.admin?
      @last5_quotes = Quote.all.order(desc: :updated_at).limit(50)
    else
      @last5_quotes = current_user.quotes.order(desc: :updated_at).limit(5)
    end
  end
end

class StaticPagesController < ApplicationController
  def home
  end

  def re_home
    render :layout => 're_application'
  end

  def help
  end

  def about
  end

  def contact
  end
end

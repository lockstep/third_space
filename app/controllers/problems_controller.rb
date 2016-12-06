class ProblemsController < ApplicationController
  PAGES = [
    'home', 'new', 'adaptability', 'cultural', 'empathy', 'intellectual', 'thinking',
    'review', 'review_photo', 'tst_stream'
  ]

  def show
    if !params[:page].blank? && PAGES.include?(params[:page])
      render template: "problems/#{params[:page]}"
    else
      redirect_to root_path
    end
  end
end

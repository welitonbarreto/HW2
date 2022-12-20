# This file is app/controllers/movies_controller.rb
class MoviesController < ApplicationController
  def index
    @all_ratings = Movie.all_ratings

    @applied_sort = params[:sort_by] || session[:sort_by] || ""
    @applied_ratings = params[:ratings] || session[:ratings] || @all_ratings
    
    if @applied_ratings.respond_to?(:keys)
      @applied_ratings = @applied_ratings.keys
    end

    if not session[:sort_by].eql? params[:sort_by]
      session[:sort_by] = @applied_sort
    end

    if not session[:ratings].eql? params[:ratings]
      session[:ratings] = @applied_ratings
    end

    @movies = Movie.where(rating: @applied_ratings).order(@applied_sort)
  end

  def show
    id = params[:id]
    @movie = Movie.find(id)
  end

  def new
    @movie = Movie.new
  end

  def create
    #@movie = Movie.create!(params[:movie]) #did not work on rails 5.
    @movie = Movie.create(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created!"
    redirect_to movies_path
  end

  def movie_params
    params.require(:movie).permit(:title,:rating,:description,:release_date)
  end

  def edit
    id = params[:id]
    @movie = Movie.find(id)
    #@movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    #@movie.update_attributes!(params[:movie])#did not work on rails 5.
    @movie.update(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated!"
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find params[:id]
    @movie.destroy
    flash[:notice] = "#{@movie.title} was deleted!"
    redirect_to movies_path
  end
end
class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # valid sort_by values are "title" or "release_date"
    if params.key?(:sort_by)
      session[:sort_by] = params[:sort_by]
    elsif session.key?(:sort_by)
      params[:sort_by] = session[:sort_by]
    end

    @hilite = sort_by = session[:sort_by]

    # filter by ratings
    @all_ratings = Movie.all_ratings

    if params.key?(:ratings)
      session[:ratings] = params[:ratings]
    elsif session.key?(:ratings)
      params[:ratings] = session[:ratings]
    end

    @selected_ratings = (session[:ratings].keys if session.key?(:ratings)) || @all_ratings

    if params[:sort_by] != session[:sort_by] || params[:ratings] != session[:ratings]
      if session.key?(:sort_by) and session[:sort_by] == 'title'
        flash.keep
        redirect_to :sort_by => 'title', :ratings => session['ratings']
      elsif session.key?(:sort_by) and session[:sort_by] == 'release_date'
        flash.keep
        redirect_to :sort_by => 'release_date', :ratings => session['ratings']
      else
        redirect_to :ratings => session['ratings']
      end
      return
    end

    @movies = Movie.order(sort_by).where(rating: @selected_ratings)
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end

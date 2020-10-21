class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #@movies = Movie.all
    @all_ratings = Movie.all_ratings
    
    #if params[:ratings] == nil and params[:sortByMovieTitle] == nil and params[:sortByReleaseDate] == nil
      if session[:ratings] != nil and params[:home] == nil
        params[:ratings] = session[:ratings]
      end
      if session[:sortByMovieTitle] != nil and params[:sortReleaseDateChange] == nil
        params[:sortByMovieTitle] = session[:sortByMovieTitle]
      end
      if session[:sortByReleaseDate] != nil and params[:sortMovieChange] == nil
        params[:sortByReleaseDate] = session[:sortByReleaseDate]
      end
    #end
    if params[:ratings] == nil
      @ratings_to_show = []
      session[:ratings] = nil
    else 
      @ratings_to_show = params[:ratings].keys
      session[:ratings] = params[:ratings]
    end
    
    if params[:sortByMovieTitle] != nil
      session[:sortByMovieTitle] = 1
      session[:sortByReleaseDate] = nil
      @movies = Movie.with_ratings(@ratings_to_show).order(:title)
      @sortByMovie = 'bg-warning'
    elsif params[:sortByReleaseDate] != nil
      session[:sortByReleaseDate] = 1
      session[:sortByMovieTitle] = nil
      @movies = Movie.with_ratings(@ratings_to_show).order(:release_date)
      @sortByReleaseDate = 'bg-warning'
    else
      @movies = Movie.with_ratings(@ratings_to_show)
    end
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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end

class HomeController < ApplicationController
  before_action :set_game

  def index   
    @next_generation = next_generation(@grid)
  end

  def update_array
    new_array_data = params[:new_array_data]
    local_grid = @game.load_grid(new_array_data)    
    @next_generation = next_generation(local_grid)
    @game.generation = params[:counter].to_i + 1
    render :index,  notice: 'Griglia aggiornata con successo!'
  end
  
  def next_generation(grid)
    next_generation = @game.next_grid(grid)
  end

private
  def set_game
    @game ||=  Game.new()
      @original_grid = @game.read_file
    @grid = @original_grid    
  end

end
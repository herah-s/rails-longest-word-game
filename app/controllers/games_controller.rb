require 'open-uri'

class GamesController < ApplicationController
  def new
    array = Array('A'..'Z') + Array('A'..'Z') + Array('A'..'Z')
    @letters = []
    7.times do
      index = rand(array.size - 1)
      @letters.push(array[index])
    end

    3.times do
      @letters << ['A', 'O', 'E'].sample
    end
    @letters
  end

  def score
    session[:score] = 0 if session[:score].nil?
    if valid?(params['word']) && in_the_grid?(params['word'], params['letters'].chars)
      @result = "Congratulations! #{params['word'].upcase} is a valid English word!"
      user_score = 1 + params['word'].size.fdiv(2)
      session[:score] += user_score
    elsif !valid?(params['word'])
      @result = "Sorry but #{params['word'].upcase} does not seem to be a valid English word..."
    elsif !in_the_grid?(params['word'], params['letters'].chars)
      @result = "Sorry but #{params['word'].upcase} can't be built out of #{params['letters'].chars.join(', ')}"
    end
  end

  def in_the_grid?(attempt, grid)
    attempt.upcase.chars.all? do |char|
      attempt.upcase.count(char) <= grid.count(char)
    end
  end

  def valid?(word)
    search = "https://wagon-dictionary.herokuapp.com/#{word}"
    serialized = URI.open(search).read
    JSON.parse(serialized)['found']
  end
end

# The word can’t be built out of the original grid
# The word is valid according to the grid, but is not a valid English word
# The word is valid according to the grid and is an English word

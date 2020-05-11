require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @sample = words_deck_sample
  end

  def score
    @deck = params[:deck].split
    @word = params[:word].chars
    @validation = validate(@deck, @word)
    @valid_word = if @validation == false
                    if validate_english_word(params[:word]) == true
                      "Congratulations #{params[:word]} is an English word"
                    else
                      "#{params[:word]} is not and english word"
                    end
                  else
                    'Sorry you are using letters that are not included in your deck'
                  end
  end

  def validate(deck, word)
    count = 0
    word.each { |letter| count += 1 unless deck.include?(letter) }
    count.positive?
  end

  def validate_english_word(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    user_serialized = open(url).read
    @result = JSON.parse(user_serialized)
    @result['found']
  end

  def words_deck_sample
    @deck = ('a'..'z').to_a.sample(10)
  end
end

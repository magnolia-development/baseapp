# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @example_constant = Constants.example.value
  end
end


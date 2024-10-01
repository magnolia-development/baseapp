# frozen_string_literal: true

require_relative "load"
require_relative "model"

module Constant
  class Initialize
    def initialize(path:, constant_name:)
      @path = path
      @constant_name = constant_name
    end

    def call
      Kernel.const_set(constant_name, Model.new(load_hash_from_yml).deep_transform)
    end

    private

    attr_reader :path, :constant_name

    def load_hash_from_yml
      Constant::Load.new(path).call
    end
  end
end


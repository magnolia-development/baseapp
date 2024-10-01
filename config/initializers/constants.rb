# frozen_string_literal: true

require "constant/initialize"

Rails.application.config.before_initialize do
  Constant::Initialize.new(path: "config/constants", constant_name: "Constants").call
end


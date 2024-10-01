# frozen_string_literal: true

namespace :db do
  namespace :seed do
    Dir[Rails.root.join("db/seeds/*.rb").to_s].each do |filename|
      task_name = File.basename(filename, ".rb").intern
      desc "Load the seed data from db/seeds/#{task_name}.rb"
      task task_name => :environment do
        load(filename) if File.exist?(filename)
      end
    end
  end
end


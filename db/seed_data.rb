class SeedData
  # This file should contain all the record creation needed to seed the database with its default values.
  # The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

  require 'colorize'

  def initialize(model_name)
    @model = model_name.constantize
    @beer_mug = "\360\237\215\272"
    @checkmark = " \u2713"
  end

  def self.random_color
    colour = "%06x" % (rand * 0xffffff)
    "/#{colour}/ffffff/"
  end

  def self.get_random(object)
    object.offset(rand(object.count)).first
  end

  def self.random_true_or_false
    [true, false].sample
  end

  def load(data)
    if @model.count == 0
      start_msg(data.count)
      @model.create(data)
      end_msg(data)
    else
      puts "  Skipping #{@model.table_name.white}.  Table contains data." if Rails.env != "test"
    end
  end

  def start_msg(rows = 0)
    return if Rails.env == "test"

    if rows == 0
      msg = @beer_mug + "  Seeding #{@model.table_name.white} table..."
    else
      msg = @beer_mug + "  Seeding #{@model.table_name.white} table with #{rows} rows..."
    end
    print msg
  end

  def end_msg(data)
    return if Rails.env == "test"
    rows_written = @model.count.to_s
    if data.count != @model.count
      puts " #{rows_written.red} #{@checkmark.yellow}"
    else
      puts " #{@checkmark.green}"
    end
  end
end

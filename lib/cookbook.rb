require "csv"
require_relative "recipe"

class Cookbook
  def initialize(csv_file_path)
    @csv_file_path = csv_file_path
    @recipes = []
    CSV.foreach(csv_file_path) do |row|
      @recipes << Recipe.new(row[0], row[1], row[2], true?(row[3]), row[4])
    end
  end

  # all which returns all the recipes
  def all
    return @recipes
  end

  # add_recipe(recipe) which adds a new recipe to the cookbook
  def add_recipe(recipe)
    @recipes << recipe
    store_in_csv
  end

  def find(index)
    @recipes[index]
  end

  # remove_recipe(recipe_index) which removes a recipe from the cookbook.
  def remove_recipe(recipe_index)
    @recipes.delete_at(recipe_index)
    store_in_csv
  end

  def recipe_done(recipe)
    recipe.mark_as_done
    store_in_csv
  end

  private

  def store_in_csv
    CSV.open(@csv_file_path, 'wb') do |csv|
      @recipes.each do |recipe|
        csv << [recipe.name, recipe.description, recipe.preptime, recipe.done.to_s, recipe.difficulty]
      end
    end
  end

  def true?(obj)
    obj.to_s.downcase == "true"
  end
end

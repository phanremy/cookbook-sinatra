require_relative "cookbook"
require_relative "controller"

cookbook = Cookbook.new("lib/recipes.csv")
recipe1 = Recipe.new("carbonara", "pate lardon creme")
recipe2 = Recipe.new("pho", "soupe vietnamienne bouillon boeuf")
controller = Controller.new(cookbook)

controller.list
controller.create(recipe1)
controller.list
controller.create(recipe2)
controller.list
controller.destroy(recipe)
controller.list

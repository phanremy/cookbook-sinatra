require_relative "recipe"

class View
  def display(recipes)
    puts "-- Here are all the recipes you looked for --"
    puts ""
    recipes.each_with_index do |recipe, index|
      puts "#{index + 1}. #{recipe.name} (#{recipe.preptime}) niveau #{recipe.difficulty}: #{recipe.description}"
    end
  end

  def display_all(recipes)
    puts "-- Here are all your recipes --"
    puts ""
    recipes.each_with_index do |recipe, index|
      done = recipe.done? ? "[X]" : "[ ]"
      puts "#{index + 1}. #{done} #{recipe.name} (#{recipe.preptime}) niveau #{recipe.difficulty}"
    end
  end

  def ask_user_for_name
    puts "Name?"
    print "> "
    return gets.chomp
  end

  def ask_user_for_description
    puts "Description?"
    print "> "
    return gets.chomp
  end

  def ask_user_for_preptime
    puts "Preparation time?"
    print "> "
    return gets.chomp
  end

  def ask_user_for_index
    puts "Index?"
    return gets.chomp.to_i - 1
  end

  def ask_user_for_ingredient
    puts "Which ingredient to look for in Marmiton?"
    print "> "
    return gets.chomp
  end

  def ask_user_for_difficulty
    puts "Difficulty? [1, 2, 3, 4]"
    print "> "
    return gets.chomp
  end
end

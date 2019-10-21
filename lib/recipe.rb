class Recipe
  attr_reader :name, :description, :preptime, :done, :difficulty
  def initialize(name, description, preptime, done = false, difficulty = "moyen")
    @name = name
    @description = description
    @preptime = preptime
    @done = done
    @difficulty = difficulty
  end

  difficulty = ["Tres facile", "facile", "moyen", "difficile"]

  def done?
    @done
  end

  def mark_as_done
    @done = true
  end
end

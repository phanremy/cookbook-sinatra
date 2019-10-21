require_relative "view"
require 'nokogiri'
# require_relative "parsing"
require "pry-byebug"
require 'open-uri'

class Controller
  def initialize(cookbook)
    @cookbook = cookbook
    @view = View.new
  end

  def list
    # 1. recuperer les recipes (cookbook)
    # 2. Afficher les recipe (view)
    display_recipes
  end

  def create
    # 1. demander au user une description (view)
    name = @view.ask_user_for_name
    description = @view.ask_user_for_description
    preptime = @view.ask_user_for_preptime
    difficulty = @view.ask_user_for_difficulty
    # 2. Creer tache (recipe)
    recipe = Recipe.new(name, description, preptime, false, difficulty)
    # 3. Stocker (cookbook)
    @cookbook.add_recipe(recipe)
    # 4. Afficher les recipes
    display_recipes
  end

  def destroy
    # 1. Display list with indices
    display_recipes
    # 2. Ask user for index
    index = @view.ask_user_for_index
    # 3. Remove from repository
    @cookbook.remove_recipe(index)
    # 4. Afficher les recipes
    display_recipes
  end

  def import
    ingredient = @view.ask_user_for_ingredient
    difficulty = @view.ask_user_for_difficulty
    recipes = fetch_recipe(ingredient, difficulty)
    @view.display(recipes)
    index = @view.ask_user_for_index
    @cookbook.add_recipe(recipes[index])
    display_recipes
  end

  def mark_as_done
    # 1. Display list with indices
    display_recipes
    # 2. Ask user for index
    index = @view.ask_user_for_index
    # 3. Fetch task from repo
    # 4. Mark task as done
    recipe = @cookbook.find(index)
    @cookbook.recipe_done(recipe)
    # 5. Save CSV
    display_recipes
  end

  # private

  def display_recipes
    # 1. Fetch recipes from cookbook
    recipes = @cookbook.all
    # 2. Send them to view for display
    @view.display_all(recipes)
  end

  def fetch_recipe(keyword, difficulty)
    binding.pry
    file = "https://www.marmiton.org/recettes/recherche.aspx?aqt=#{keyword}&dif=#{difficulty}"
    doc = Nokogiri::HTML(open(file), nil, 'utf-8')
    a_recipe = doc.search('.recipe-card__title').take(5).map { |recipe| recipe.text.strip }
    a_description = doc.search('.recipe-card__description').take(5).map { |recipe| recipe.text.strip }
    a_preptime = doc.search('.recipe-card__duration').take(5).map { |recipe| recipe.text.strip.gsub(" ","") }
    a_link = doc.search('.recipe-card-link').take(5).map { |recipe| "https://www.marmiton.org" + recipe.attributes["href"].value }
    a_difficulty = []

    a_link.each do |link|
      # a_link_doc = "https://www.marmiton.org/recettes/recherche.aspx?aqt=#{fraise}&dif="
      # "https://www.marmiton.org/recettes/recherche.aspx?aqt=#{fraise}&dif=#{difficulty}"
      html_doc = Nokogiri::HTML(open(link), nil, 'utf-8')
      difficulty = html_doc.search(".recipe-infos__level .recipe-infos__item-title").text.strip
      a_difficulty << difficulty
    end

    puts a_difficulty

    a_recipes = []
    a_recipe.each_with_index do |_recipe, index|
      a_recipes << Recipe.new(a_recipe[index], a_description[index], a_preptime[index], false, a_difficulty[index])
    end

    return a_recipes
  end

  # def fetch_difficulty
  #   a_preptime = doc.search('span.recipe-infos__item-title').take(5).map { |recipe| recipe.text.strip }
  # end

  # not required as the view display can be done alone in program
  # def display_choices(choices)
  #   # 2. Send them to view for display
  #   @view.display(choices)
  # end

  # not required for url as of now
  def fetch_url(keyword)
    # fetch results of marmiton html
    file = "#{keyword}.html"
    doc = Nokogiri::HTML(File.open(file), nil, 'utf-8')
    # full_links = { title: "" }
    full_links = []
    doc.search('a.recipe-card-link').first(5).each do |recipe|
      link = recipe.attributes["href"].value
      puts link
      puts doc.search('.recipe-card__title').text.strip
      # full_links[doc.search('h4.recipe-card__title').text.strip] << "https://www.marmiton.org" + link
      full_links << "https://www.marmiton.org" + link
    end
    return full_links
  end

  # not required as name alone is useless
  # def fetch_name(keyword)
  #   # fetch results of marmiton html
  #   file = "#{keyword}.html"
  #   doc = Nokogiri::HTML(File.open(file), nil, 'utf-8')
  #   # full_links = { title: "" }
  #   full_names = []
  #   doc.search(".recipe-card__title").first(5).each do |recipe|
  #     # full_links[doc.search('h4.recipe-card__title').text.strip] << "https://www.marmiton.org" + link
  #     full_names << recipe.text
  #   end
  #   return full_names
  # end

  # improved in fetch_recipes (below is copy of imdb)
  # def scrape_recipe
  #   doc = Nokogiri::HTML(open(url, "Accept-Language" => "en").read)
  #   m = doc.search("h1").text.match /(?<title>.*)[[:space:]]\((?<year>\d{4})\)/
  #   title = m[:title]
  #   year = m[:year].to_i

  #   storyline = doc.search(".summary_text").text.strip
  #   director = doc.search("h4:contains('Director:') + a").text
  #   cast = doc.search(".primary_photo + td a").take(3).map do |element|
  #     element.text.strip
  #     {
  #       name: name,
  #       description: description,
  #       preptime: preptime
  #     }
  #   end
  # end
end

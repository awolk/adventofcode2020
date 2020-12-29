require_relative 'aoc/aoc'

Food = Struct.new(:ingredients, :allergens)

def map_allergens_to_ingredients(foods)
  allergens = foods.map(&:allergens).flatten.uniq
  allergens.map do |allergen|
    [allergen, foods.filter {_1.allergens.include?(allergen)}.map(&:ingredients).reduce(:&)]
  end.to_h
end

s = AOC::Solution.new

s.preprocess do |input|
  input.split("\n").map do |line|
    /(?<ingredients>[a-z ]+) \(contains (?<allergens>[a-z ,]+)\)/ =~ line
    Food.new(ingredients.split, allergens.split(', '))
  end
end

s.part1 do |foods|
  allergen_possible_ingredients = map_allergens_to_ingredients(foods)

  total_ingredients = foods.map(&:ingredients).flatten
  total_ingredient_counts = total_ingredients.tally
  all_ingredients = total_ingredients.uniq
  ingredients_with_allergens = allergen_possible_ingredients.values.flatten.uniq
  inert_ingredients = all_ingredients - ingredients_with_allergens
  inert_ingredients.map(&total_ingredient_counts).sum
end

s.part2 do |foods|
  allergen_possible_ingredients = map_allergens_to_ingredients(foods)

  ingredient_count = allergen_possible_ingredients.values.flatten.uniq.length
  ingredient_to_allergen = {}
  while ingredient_to_allergen.length < ingredient_count
    allergen, ingredients = allergen_possible_ingredients.find {|_allergen, ingredients| ingredients.length == 1}
    ingredient = ingredients[0]
    allergen_possible_ingredients.delete(allergen)
    allergen_possible_ingredients.values.each {|ingredients| ingredients.delete(ingredient)}
    ingredient_to_allergen[ingredient] = allergen
  end

  ingredient_to_allergen.sort_by {_1[1]}.map(&:first).join(',')
end

s.exec(21)
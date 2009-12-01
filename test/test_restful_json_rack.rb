require 'test_helper'

class JsonPersistTest < ActionController::IntegrationTest

  def test_fallback
    get "/foo"
    # assert didn't asplode
  end
  
  def test_create
    assert_difference("Recipe.count", 1) do
      post "/recipes.json", Recipe.new(:name =>"food", :description => "yummy").to_json
    end
    assert Recipe.find(JSON.parse(response.body)["id"])
  end

  def test_create_with_error
    post "/recipes.json", Recipe.new().to_json
    assert_response :error
    errors = JSON.parse(response.body)
    assert_equal "name", errors[0][0]
  end

  def test_update
    recipe = Recipe.create!(:name => "good", :description => "food")
    put "/recipes/#{recipe.id}.json", Recipe.new(:name => "bad", :description => "food").to_json
    assert_response :success
    assert_equal "bad", recipe.reload.name
  end

  def test_delete
    recipe = Recipe.create!(:name => "good", :description => "food")
    delete "/recipes/#{recipe.id}.json", ""
    assert_response :success
    assert_nil Recipe.find_by_id(recipe.id)
  end

  def test_index
    2.times do
      Recipe.create!(:name => "good", :description => "food")
    end
    get "/recipes.json", ""
    assert_response :success
    results = JSON.parse(response.body)
    assert_equal 2, results.size
    results.each {|recipe| assert_equal "good", recipe["name"]}
  end

  def test_get
    recipe = Recipe.create!(:name => "good", :description => "food")
    get "/recipes/#{recipe.id}.json", ""
    assert_response :success
    recipe_attrs = JSON.parse(response.body)
    assert_equal "good", recipe_attrs["name"]
  end
end

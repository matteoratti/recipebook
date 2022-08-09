# spec/integration/blogs_spec.rb
require 'swagger_helper'

describe 'Recipes API' do

  path '/recipes' do

    path '/recipes.json' do

      get 'Get all recipes' do
        tags 'Recipes', 'index'
        produces 'application/json'

        response '200', 'Recipes found' do
          schema type: :array,
                 properties: [
                   { id: { type: :integer }, name: { type: :string }, body: { type: :string } }
                 ]

          let(:id) { Recipe.create(name: 'foo', description: 'bar').id }
          run_test!
        end

        response '404', 'recipe not found' do
          let(:id) { 'invalid' }
          run_test!
        end

        response '406', 'unsupported accept header' do
          let(:'Accept') { 'application/foo' }
          run_test!
        end
      end
    end

    post 'Create a recipe' do
      tags 'Recipes'
      consumes 'application/json'
      parameter name: :recipe, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          body: { type: :string }
        },
        required: [ 'name' ]
      }

      response '201', 'recipe created' do
        let(:recipe) { { title: 'foo', content: 'bar' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:recipe) { { title: 'foo' } }
        run_test!
      end
    end
  end

  path '/recipes/{id}' do

    get 'Retrieves a recipe' do
      tags 'Recipes', 'show'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string

      response '200', 'blog found' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 name: { type: :string },
                 description: { type: :string }
               }



        let(:id) { Recipe.create(name: 'foo', description: 'bar').id }
        run_test!
      end

      response '404', 'recipe not found' do
        let(:id) { 'invalid' }
        run_test!
      end

      response '406', 'unsupported accept header' do
        let(:'Accept') { 'application/foo' }
        run_test!
      end
    end
  end
end
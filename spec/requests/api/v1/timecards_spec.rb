# spec/requests/api/v1/timecards_spec.rb
require 'spec_helper'

describe API::V1::Timecards do
  include Rack::Test::Methods

  def app
    OUTER_APP
  end

  # Define a few let variables to use in our tests
  let(:url) { 'http://example.org:80/api/v1' }
  # We need to create a timecard because it needs to be in the database
  # to allow the controller to access it
  let(:timecard_object) { create(:timecard) }

  before do
    header 'Content-Type', 'application/vnd.api+json'
  end

  # Tests for the endpoint /api/v1/timecards
  describe 'get /' do

    it 'returns HTTP status 200' do
      get '/api/v1/timecards'
      expect(last_response.status).to eq 200
    end

    # In this describe, we split the testing of each part
    # of the JSON document. Like this, if one fails we'll know which part
    # is not working properly
    describe 'top level' do

      before do
        timecard_object
        get '/api/v1/timecards'
      end

      it 'contains the meta object' do
        expect(json['meta']).to eq({
                                       'username' => 'sample user',
                                       'occurrence' => '2016-12-19'
                                   })
      end

      it 'contains the self link' do
        expect(json['links']).to eq({
                                        'self' => "#{url}/timecards"
                                    })
      end

      # I got lazy and didn't put the whole JSON document I'm expected,
      # instead I used the presenter to generate it.
      # It's not the best way to do this obviously.
      it 'contains the data object' do
        expect(json['data']).to eq(
                                    [to_json(Presenters::Timecard.new(url, timecard_object).as_json_api[:data])]
                                )
      end

      it 'contains the included object' do
        expect(json['included']).to eq([])
      end

    end

    # I want to test the relationships separately
    # because they require more setup and deserve their own tests
    describe 'relationships' do

      # We need to create some related models first
      let(:timeentry) { create(:timeentry, timecard: timecard_object) }

      # To avoid duplicated hash, I just use a method
      # that takes a few parameters and build the hash we want
      # Could probably use shared examples instead of this but I find
      # it easier to understand
      def relationship(url, type, timecard_id, id)
        {
            "data" => [{"type"=> type , "id"=> id }],
            "links"=> {
                "self" => "#{url}/timecards/#{timecard_id}/relationships/#{type}",
                "related" => "#{url}/timecards/#{timecard_id}/#{type}"
            }
        }
      end

      # We need to call our let variables to define them
      # before the controller uses the presenter to generate
      # the JSON document
      before do
        timeentry
        get '/api/v1/timecards'
      end

      # The following tests check that the relationships are correct
      # and that the included array is equal to the number of related
      # objects we created

      it 'contains the timeentry relationship' do
        id = timeentry.id.to_s
        expect(json['data'][0]['relationships']['timeentries']).to eq(
                                                                    relationship(url, 'timeentries', timecard_object.id, id)
                                                                )
      end

      it 'includes the timeentry in the included array' do
        expect(json['included'].count).to eq(2)
      end

    end

  end

  # Tests for the endpoint /api/v1/timecards/10
  describe 'get /:id' do

    # The timecard object is created before the request
    # since we use it to build the url
    before do
      get "/api/v1/timecards/#{timecard_object.id}"
    end

    it 'returns HTTP status 200' do
      expect(last_response.status).to eq 200
    end

    # Repeat the same kind of tests than we defined for
    # the index route. Could totally be in shared examples
    # but that will be for another jutsu
    describe 'top level' do

      it 'contains the meta object' do
        expect(json['meta']).to eq({
                                       'username' => 'Sample User',
                                       'occurrence' => '2016-12-19'
                                   })
      end

      it 'contains the self link' do
        expect(json['links']).to eq({
                                        'self' => "#{url}/timecards/#{timecard_object.id}"
                                    })
      end

      it 'contains the data object' do
        expect(json['data']).to eq(to_json(Presenters::Timecard.new(url, timecard_object).as_json_api[:data]))
      end

      it 'contains the included object' do
        expect(json['included']).to eq([])
      end

    end

    describe 'relationships' do

      let(:timeentry) { create(:timeentry, timecard: timecard_object) }

      def relationship(url, type, timecard_id, id)
        {
            "data" => [{"type"=> type , "id"=> id }],
            "links"=> {
                "self" => "#{url}/timecards/#{timecard_id}/relationships/#{type}",
                "related" => "#{url}/timecards/#{timecard_id}/#{type}"
            }
        }
      end

      before do
        timeentry
        get '/api/v1/timecards'
      end

      it 'contains the timeentry relationship' do
        id = comment.id.to_s
        expect(json['data'][0]['relationships']['timeentries']).to eq(
                                                                    relationship(url, 'timeentries', timecard_object.id, id)
                                                                )
      end

      it 'includes timeentry in the included array' do
        expect(json['included'].count).to eq(2)
      end

    end

  end

end
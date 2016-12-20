# # spec/requests/api/v1/timeentries_spec.rb
# require 'spec_helper'
#
# describe API::V1::Timeentries do
#   include Rack::Test::Methods
#
#   def app
#     OUTER_APP
#   end
#
#   let(:url) { BASE_URL }
#   let(:timecard_object) { create(:timecard) }
#
#   # We need to define a set of correct attributes to create timeentries
#   let(:attributes) do
#     {
#         time: '2016-12-19T10:10:10:010',
#         timecard_id: '11'
#     }
#   end
#
#   # And valid_params that use the previous attributes and
#   # add the JSON API spec enveloppe
#   let(:valid_params) do
#     {
#         data: {
#             type: 'timeentries',
#             attributes: attributes
#         }
#     }
#   end
#
#   # We also need an invalid set of params to test
#   # that Grape validates correctly
#   let(:invalid_params) do
#     {
#         data: {}
#     }
#   end
#
#   before do
#     header 'Content-Type', 'application/vnd.api+json'
#   end
#
#   describe 'POST /timeentries' do
#
#     # We use contexts here to separate our requests that
#     # have valid parameters vs the ones that have invalid parameters
#     context 'with valid attributes' do
#
#       # Now we're using post and not get to make our requests.
#       # We also pass the parameters we want
#       it 'returns HTTP status 201 - Created' do
#         post "/api/v1/timeentries", valid_params.to_json
#         expect(last_response.status).to eq 201
#       end
#
#       # After the request, we check in the database that our timeentry
#       # was persisted
#       it 'creates the resource' do
#         post "/api/v1/timeentries", valid_params.to_json
#         timeentry = timecard_object.reload.timeentries.find(json['data']['id'])
#         expect(timeentry).to_not eq nil
#       end
#
#       # Here we check that all the attributes were correctly assigned during
#       # the creation. We could split this into different tests but I got lazy.
#       it 'creates the resource with the specified attributes' do
#         post "/api/v1/timeentries", valid_params.to_json
#         timeentry = timecard_object.reload.timeentries.find(json['data']['id'])
#         expect(timeentry.time).to eq attributes[:time]
#         expect(timeentry.timecard_id).to eq attributes[:timecard_id]
#       end
#
#       # Here we check that the endpoint returns what we want, in a format
#       # that follows the JSON API specification
#       it 'returns the appropriate JSON document' do
#         post "/api/v1/timeentries", valid_params.to_json
#         id = timecard_object.reload.timeentries.first.id
#         expect(json['data']).to eq({
#                                        'type' => 'timeentries',
#                                        'id' => id.to_s,
#                                        'attributes' => {
#                                            'time' => 'Sample User',
#                                            'timecard_id' => '11'
#                                        },
#                                        'links' => { 'self' => "#{BASE_URL}/timeentries/#{id}" },
#                                        'relationships' => {}
#                                    })
#       end
#
#     end
#
#     # What happens when we send invalid attributes?
#     context 'with invalid attributes' do
#
#       # Grape should catch it and return 400!
#       it 'returns HTTP status 400 - Bad Request' do
#         post "/api/v1/timeentries", invalid_params.to_json
#         expect(last_response.status).to eq 400
#       end
#
#     end
#
#   end
#
#   # Let's try to update stuff now!
#   describe 'PATCH /timeentries/:id' do
#
#     # We make a timeentry, that's the one we will be updating
#     let(:timeentry) { create(:timeentry, timecard: timecard_object) }
#
#     # What we want to change in our timeentry
#     let(:attributes) do
#       {
#           time: '2016-12-19T10:10:10:010',
#           timecard_id: '11'
#       }
#     end
#
#     # Once again, separate valid parameters and invalid parameters
#     # with contexts. The tests don't have anything new compared to
#     # what we wrote for the creation tests.
#     context 'with valid attributes' do
#
#       it 'returns HTTP status 200 - OK' do
#         patch "/api/v1/timeentries/#{timecard.id}", valid_params.to_json
#         expect(last_response.status).to eq 200
#       end
#
#       it 'updates the resource time and timecard_id' do
#         patch "/api/v1/timeentries/#{timeentry.id}", valid_params.to_json
#         expect(timeentry.reload.time).to eq '2016-12-19T10:10:10:010'
#         expect(timeentry.reload.timecard_id).to eq '11'
#       end
#
#       it 'returns the appropriate JSON document' do
#         patch "/api/v1/timeentries/#{timeentry.id}", valid_params.to_json
#         id = timeentry.id
#         expect(json['data']).to eq({
#                                        'type' => 'timeentries',
#                                        'id' => id.to_s,
#                                        'attributes' => {
#                                            'time' => '2016-12-19T10:10:10:010',
#                                            'timecard_id' => '11'
#                                        },
#                                        'links' => { 'self' => "#{BASE_URL}/timeentries/#{id}" },
#                                        'relationships' => {}
#                                    })
#       end
#
#     end
#
#     context 'with invalid attributes' do
#
#       it 'returns HTTP status 400 - Bad Request' do
#         patch "/api/v1/timeentries/#{timeentry.id}", invalid_params.to_json
#         expect(last_response.status).to eq 400
#       end
#
#     end
#
#   end
#
#   # Let's delete stuff, yay \o/
#   describe 'DELETE /timeentries/:id' do
#
#     let(:timeentry) { create(:timeentry, timecard: timecard_object) }
#
#     # The request works...
#     it 'returns HTTP status 200 - Ok' do
#       delete "/api/v1/timeentries/#{timeentry.id}"
#       expect(last_response.status).to eq 200
#     end
#
#     # ... but did it really remove the timeentry from the DB?
#     it 'removes the timeentry' do
#       id = timeentry.id
#       delete "/api/v1/timeentries/#{id}"
#       timeentry = timecard_object.reload.timeentries.where(id: id).first
#       expect(timeentry).to eq nil
#     end
#
#   end
#
# end
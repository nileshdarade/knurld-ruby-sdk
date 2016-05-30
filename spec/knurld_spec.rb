require 'spec_helper'

describe Knurld do
  # it 'raises exception if missing developer_id, client_d, or client_secret' do
  #   Knurld.developer_id, Knurld.client_id, Knurld.client_secret = nil
  #   expect {Knurld.make_headers}.to raise_error(RuntimeError)
  # end

  it 'retrieves status of knurld API' do
    expect(Knurld.api_status).to eq(true || false)
  end

  it 'returns headers' do
    headers = Knurld.make_headers.to_s
    expect(headers).to include("Authorization")
    expect(headers).to include("Developer-Id")
  end

  it 'returns a list of all app models' do
    appmodels = Knurld.retrieve_app_models
    expect(appmodels).to be_a(Array)
    expect(appmodels[0]).to be_instance_of(Knurld::AppModel)
  end

  it 'returns a specific app model' do
    expect(Knurld.retrieve_app_model("5571c3a5c203f17826740e9019b30215")).to be_instance_of(Knurld::AppModel)
  end

  it 'retrieves a single consumer' do
    expect(Knurld.retrieve_consumer("ed101c867904071e9e2f98d91f0385dc")).to be_instance_of(Knurld::Consumer)
  end

  it 'retrieves all consumers' do
    consumers = Knurld.retrieve_consumers
    expect(consumers).to be_a(Array)
    expect(consumers[0]).to be_instance_of(Knurld::Consumer)
  end


end

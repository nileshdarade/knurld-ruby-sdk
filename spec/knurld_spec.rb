require 'spec_helper'

describe Knurld do
  it 'has a version number' do
    expect(Knurld::VERSION).not_to be nil
  end

  it 'does something useful' do
    expect(false).to eq(true)
  end

  Knurld.developer_id =
  Knurld.client_id =
  Knurld.client_secret =

  it 'creates token before sending request' do
    Knurld::
  end

  it 'returns nil if attempting request while client_id or client_secret is nil' do
  end

  it 'retrieves status of knurld API' do
    expect(Knurld.api_status).to eq(true || false)
  end

  it 'generates & sets token when called' do
  end

  it 'signs request with headers' do
  end
end

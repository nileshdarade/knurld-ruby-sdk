require 'spec_helper'

describe Knurld do
  before(:each) do
    Knurld.developer_id = "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1MDQ4MTY5MDUsInJvbGUiOiJhZG1pbiIsImlkIjoiYTY3YTNmMzM3ODIzZTJkNTZlYzI2NGY4YzMxNWM3NmUiLCJ0ZW5hbnQiOiJ0ZW5hbnRfbXJwdGF4M29tenl4b25kbW9yMmcyNXJ1bzV2dGk0M2JudTJ4bzUzZGdqd2cyenQyb2ozdG1tM2oiLCJuYW1lIjoiYWRtaW4ifQ.ZBrqbMNHRXScvzBz6IGSW3H05yLZruZ1CSI-lremAMsT5dOYUBzyU9WnkYnK7JgZbwyCDxPESh_bpQe5LSKsQg"
    Knurld.client_id = "f5fAgcpfYhdA2f2Tku0QEcganb4WJMjA"
    Knurld.client_secret = "yCrZxlnTY7VvbQMb"
  end

  it 'raises exception if missing developer_id, client_d, or client_secret' do
    Knurld.developer_id, Knurld.client_id, Knurld.client_secret = nil
    expect {Knurld.make_headers}.to raise_error(RuntimeError)
  end

  it 'retrieves status of knurld API' do
    expect(Knurld.api_status).to eq(true || false)
  end

  it 'returns headers' do
    headers = Knurld.make_headers.to_s
    expect(headers).to include("Authorization")
    expect(headers).to include("Developer-Id")
  end
end

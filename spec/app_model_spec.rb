require 'spec_helper'

describe Knurld::AppModel do
  before(:all) do
    Knurld.developer_id = "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1MDQ4MTY5MDUsInJvbGUiOiJhZG1pbiIsImlkIjoiYTY3YTNmMzM3ODIzZTJkNTZlYzI2NGY4YzMxNWM3NmUiLCJ0ZW5hbnQiOiJ0ZW5hbnRfbXJwdGF4M29tenl4b25kbW9yMmcyNXJ1bzV2dGk0M2JudTJ4bzUzZGdqd2cyenQyb2ozdG1tM2oiLCJuYW1lIjoiYWRtaW4ifQ.ZBrqbMNHRXScvzBz6IGSW3H05yLZruZ1CSI-lremAMsT5dOYUBzyU9WnkYnK7JgZbwyCDxPESh_bpQe5LSKsQg"
    Knurld.client_id = "f5fAgcpfYhdA2f2Tku0QEcganb4WJMjA"
    Knurld.client_secret = "yCrZxlnTY7VvbQMb"
  end

  describe "initialize" do
    it 'fills defaults if some values left blank' do
      expect(Knurld::AppModel.new({:enrollmentRepeats => 5}).vocabulary).to_not be_nil
      expect(Knurld::AppModel.new({:enrollmentRepeats => 5}).verificationLength).to_not be_nil
    end

    it 'rejects incorrect typing, raises' do
      expect { Knurld::AppModel.new({:vocabulary => 1}) }.to raise_error(RuntimeError)
      expect { Knurld::AppModel.new({:enrollmentRepeats => "a string"}) }.to raise_error(RuntimeError)
      expect { Knurld::AppModel.new({:verificationLength => "a string"}) }.to raise_error(RuntimeError)
    end
  end
end

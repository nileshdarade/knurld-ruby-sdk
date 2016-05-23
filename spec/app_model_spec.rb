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

  describe "save" do
    before(:all) do
      @appmodel = Knurld.retrieve_app_models().last
    end
    it 'returns an appmodel when called on a valid object' do
      @appmodel.verificationLength = 3
      expect(@appmodel.save).to be_instance_of(Knurld::AppModel)
    end

    it 'raises when called with invalid values' do
      @appmodel.verificationLength = "one"
      expect { @appmodel.save }.to raise_error
    end
  end

  describe "delete" do
    before(:each) do
      @appmodel = Knurld.retrieve_app_models().last
    end

    it 'return nil when called upon a valid object' do
      expect(@appmodel.destroy).to be_nil
    end

    it "raises an error if the appmodel doesn't exist" do
      expect {Knurld.execute_request(:delete, "app-model/not_an_id") }.to raise_error(RuntimeError)
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExceptionHandler do
  describe '.run' do
    it 'runs the scheduled job' do
      expect { |job| described_class.run(&job) }.to yield_control
    end

    it 'reports the error of a failing job to Sentry instead of raising it' do
      allow(Sentry).to receive(:capture_exception)
      error = RuntimeError.new('obcan.justice.sk is down')

      expect { described_class.run { raise error } }.not_to raise_error
      expect(Sentry).to have_received(:capture_exception).with(error)
    end
  end
end

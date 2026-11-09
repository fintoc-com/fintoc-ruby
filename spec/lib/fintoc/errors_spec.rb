require 'fintoc/errors'

RSpec.describe Fintoc::Errors do
  let(:error) do
    {
      message: 'Missing required param: link_token',
      doc_url: 'https://fintoc.com/docs#invalid-request-error'
    }
  end

  it 'raises a Invalid Request Error' do
    expect { raise Fintoc::Errors::InvalidRequestError.new(error[:message], error[:doc_url]) }
      .to(raise_error(an_instance_of(Fintoc::Errors::InvalidRequestError))
      .with_message(/Missing required param: link_token/))
  end

  it 'raises a Invalid Request Error with default url doc' do
    expect { raise Fintoc::Errors::InvalidRequestError.new(error[:message]) }
      .to(raise_error(an_instance_of(Fintoc::Errors::InvalidRequestError))
      .with_message(%r{https://docs.fintoc.com/reference/errors}))
  end

  it 'leaves status and code nil when built with positional arguments only' do
    errors = [
      Fintoc::Errors::InvalidRequestError.new(error[:message]),
      Fintoc::Errors::InvalidRequestError.new(error[:message], error[:doc_url])
    ]

    expect(errors.map { |e| [e.status, e.code] }).to all(eq([nil, nil]))
  end

  it 'exposes status and code passed as keywords' do
    error_instance = Fintoc::Errors::InvalidRequestError.new(
      error[:message], error[:doc_url], status: 400, code: 'invalid_request_error'
    )

    expect([error_instance.status, error_instance.code]).to eq([400, 'invalid_request_error'])
    expect(error_instance.message).to include('Missing required param: link_token', error[:doc_url])
  end
end

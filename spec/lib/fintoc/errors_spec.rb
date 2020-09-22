require 'fintoc/errors'

RSpec.describe Fintoc::Errors do
  let(:error) { { 
    message: 'Missing required param: link_token',
    doc_url: 'https://fintoc.com/docs#invalid-request-error'
    } }
  it 'raises a Invalid Request Error' do
    expect { raise Fintoc::Errors::InvalidRequestError.new(error[:message], error[:doc_url]) }
      .to(raise_error(an_instance_of(Fintoc::Errors::InvalidRequestError))
      .with_message(/Missing required param: link_token/))
  end

  it 'raises a Invalid Request Error with default url doc' do
    expect { raise Fintoc::Errors::InvalidRequestError.new(error[:message]) }
      .to(raise_error(an_instance_of(Fintoc::Errors::InvalidRequestError))
      .with_message(%r{https://fintoc.com/docs}))
  end
end

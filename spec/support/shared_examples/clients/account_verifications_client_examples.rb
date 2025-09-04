require 'openssl'

RSpec.shared_examples 'a client with account verifications methods' do
  let(:account_verification_id) { 'accv_32F2NLQOOwbeOvfuw8Y1zZCfGdw' }
  let(:account_number) { '735969000000203226' }
  let(:jws_private_key) do
    key_string = "-----BEGIN PRIVATE KEY-----
MIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDNLwwQr/uFToDH
8x1GHlW5gRsngNp8J+sg8vZc5jX+dISZh42CNM2eMSyPOMLSZL08xIA9ISoxjCJb
rpJ7MY9OKOZdrFheclz8e3z/hVcXpmgT0JARYIyKUb2sgoh1JsH3aSQILTc4KuDM
dm0+WIWl9tOqKXm23j9RcYL+WOUCcLYNj3xga39CnXdqT3dy2fMIOJ+vZxfSxPhG
EBTyV6v9jrMbRukhxllTqDc64WkVdt0MOvzFzcSNkGcvHRdrK1w+x5IhfsYGtv+9
mz+fvmI88qGsb0x8peGVDgWfQjykxrB/8umpQKANn9bqjyay+ogRRwv05dmaB/gm
IycvGXE7AgMBAAECggEAI4gTKcyf3MzkZjvGhP75z175KdUZgMiU4ibQ3POMxBy/
XaroqXSlatCPK9ojerWxQ5Wvs2ZL3TqsNH49pZHGhD127x/KSci6K4ri8YjQtSq+
+Tdzy16R194h337XTJpCmqqdb8EMv/BE74NOla5UrpHYw63dAvrnsh3bFlqkhdBZ
E5OBfdLyxGy5FYdewV803a8XGfnDfT7RrsdWhPib8E3i+wix+/dv10AX/+Y6VPpG
2EPXRV63UtmO2EVXyIGT5kSAnzZBJPIB3EYTlm1A86PxQGVD4X8LAUXIj6VRVC8h
B1KXb5YZ9W1vYmKyWUZPyMQHMpUTNGEuU/EtN0aOCQKBgQD+zMd1+3BhoSwBusXb
EK2SBJwn9TfqdUghsFHNz0xjvpAFKpO55qA7XyilZwZeJsOzPQZ33ERCRk18crCd
Q6oWI15xKjPl+Dfxf4UYjokx/iQCCHu8lJ6TXcEwXniIs6CVsUq9QV+s6JBlb3C4
qD/wwp7VrmbcMLfIUs3nb3tqHQKBgQDOJnGylmqC/l4BCZj9BhLiVg7nioY24lG1
9DY0/nnnbuMtDQ+8VUKtt93Or8giejOVqj3BZ8/TflkwCQAt9cIvFG50aTVZBo2E
4uPJLGSBLrQqpuUNPR2O239o4RqGgDICkh9TRH9D9GsekLRCgefLRubUyuZZ4pI9
j1ty2kMpNwKBgGtYJmgEKBJZbkrEPvrNifJMUuVan9X81wiqWaxVOx+CdvZWO6pE
CRk6O8uDHeGofyYR/ZmdiHxLVfWp89ItYYi2GeGfIAIwkpEBYjc4RYB0SwM4Q7js
++mlw+/2vN0KoAqwiIY29nHIAJ1bV6fT6iwqMfRf5yG4vJR+nhR0mQ/ZAoGAfgLJ
5RxEpyXNWF0Bg0i/KlLocWgfelUFFW/d4q7a3TjO7K7bO4fyZjXKA5k3gLup5IZX
kW1fgCvvYIlf7rgWpqiai9XzoiN7RgtaqZHVLZHa12eFA36kHrrVOsq+aBDcgO3I
8CEimetBv0E8rpqxkXQZjWEpRTBVrAOBJsd73ikCgYAwf4fnpTcEa4g6ejmbjkXw
yacTlKFuxyLZHZ5R7D0+Fj19gwm9EzvrRIEcX84ebiJ8P1bL3kycQmLV19zE5B3M
pcsQmZ28/Oa3xCPiy8CDyDuiDbbNfnR1Ot3IbgfFL7xPYySljJbMyl7vhKJIacWs
draAAQ5iJEb5BR8AmL6tAQ==
-----END PRIVATE KEY-----"
    OpenSSL::PKey::RSA.new(key_string)
  end

  it 'responds to account verification-specific methods' do
    expect(client)
      .to respond_to(:create_account_verification)
      .and respond_to(:get_account_verification)
      .and respond_to(:list_account_verifications)
  end

  describe '#create_account_verification' do
    it 'returns an AccountVerification instance', :vcr do
      account_verification = client.create_account_verification(account_number:)

      expect(account_verification)
        .to be_an_instance_of(Fintoc::Transfers::AccountVerification)
        .and have_attributes(
          object: 'account_verification',
          status: 'pending'
        )
    end
  end

  describe '#get_account_verification' do
    it 'returns an AccountVerification instance', :vcr do
      account_verification = client.get_account_verification(account_verification_id)

      expect(account_verification)
        .to be_an_instance_of(Fintoc::Transfers::AccountVerification)
        .and have_attributes(
          id: account_verification_id,
          object: 'account_verification'
        )
    end
  end

  describe '#list_account_verifications' do
    it 'returns an array of AccountVerification instances', :vcr do
      account_verifications = client.list_account_verifications

      expect(account_verifications).to all(be_a(Fintoc::Transfers::AccountVerification))
      expect(account_verifications.size).to be >= 1
    end

    it 'accepts filtering parameters', :vcr do
      account_verifications = client.list_account_verifications(
        since: '2020-01-01T00:00:00.000Z',
        limit: 10
      )

      expect(account_verifications).to all(be_a(Fintoc::Transfers::AccountVerification))
    end
  end
end

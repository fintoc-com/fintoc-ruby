require 'openssl'

RSpec.shared_examples 'a client with transfers manager' do
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
  let(:transfer_id) { 'tr_329NGN1M4If6VvcMRALv4gjAQJx' }
  let(:account_id) { 'acc_31yYL7h9LVPg121AgFtCyJPDsgM' }

  let(:counterparty) do
    {
      holder_id: 'LFHU290523OG0',
      holder_name: 'Jon Snow',
      account_number: '735969000000203297',
      account_type: 'clabe',
      institution_id: '40012'
    }
  end

  let(:transfer_data) do
    {
      amount: 50000,
      currency: 'MXN',
      account_id:,
      counterparty:,
      comment: 'Test payment',
      reference_id: '123456'
    }
  end

  it 'responds to transfer-specific methods' do
    expect(client).to respond_to(:transfers)
    expect(client.transfers).to be_a(Fintoc::V2::Managers::TransfersManager)
    expect(client.transfers)
      .to respond_to(:create)
      .and respond_to(:get)
      .and respond_to(:list)
      .and respond_to(:return)
  end

  describe '#transfers' do
    describe '#create' do
      it 'returns a Transfer instance', :vcr do
        transfer = client.transfers.create(**transfer_data)

        expect(transfer)
          .to be_an_instance_of(Fintoc::V2::Transfer)
          .and have_attributes(
            amount: 50000,
            currency: 'MXN',
            comment: 'Test payment',
            reference_id: '123456',
            status: 'pending'
          )
      end
    end

    describe '#get' do
      it 'returns a Transfer instance', :vcr do
        transfer = client.transfers.get(transfer_id)

        expect(transfer)
          .to be_an_instance_of(Fintoc::V2::Transfer)
          .and have_attributes(
            id: transfer_id,
            object: 'transfer'
          )
      end
    end

    describe '#list' do
      it 'returns an array of Transfer instances', :vcr do
        transfers = client.transfers.list

        expect(transfers).to all(be_a(Fintoc::V2::Transfer))
        expect(transfers.size).to be >= 1
      end

      it 'accepts filtering parameters', :vcr do
        transfers = client.transfers.list(status: 'succeeded', direction: 'outbound')

        expect(transfers).to all(be_a(Fintoc::V2::Transfer))
        expect(transfers).to all(have_attributes(status: 'succeeded', direction: 'outbound'))
      end
    end

    describe '#return' do
      let(:transfer_id) { 'tr_329R3l5JksDkoevCGTOBsugCsnb' }

      it 'returns a Transfer instance with return_pending status', :vcr do
        transfer = client.transfers.return(transfer_id)

        expect(transfer)
          .to be_an_instance_of(Fintoc::V2::Transfer)
          .and have_attributes(
            id: transfer_id,
            status: 'return_pending'
          )
      end
    end
  end
end

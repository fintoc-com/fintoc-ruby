require 'fintoc/v2/resources/payment_method'

module Fintoc
  module V2
    module Managers
      class PaymentMethodsManager
        def initialize(client)
          @client = client
        end

        def create(type:, customer:, mx_direct_debit:, idempotency_key: nil)
          form = flatten_form({ type:, customer:, mx_direct_debit: })
                 .to_h { |name, value| [name, form_part(name, value)] }
          data = @client.post(version: :v2, idempotency_key:).call('payment_methods', form:)
          build_payment_method(data)
        end

        def list(**params)
          @client.get(version: :v2).call('payment_methods', **flatten_form(params)).map do |data|
            build_payment_method(data)
          end
        end

        def get(payment_method_id)
          data = @client.get(version: :v2).call("payment_methods/#{payment_method_id}")
          build_payment_method(data)
        end

        def cancel(payment_method_id, idempotency_key: nil)
          data = @client.post(version: :v2, idempotency_key:)
                        .call("payment_methods/#{payment_method_id}/cancel")
          build_payment_method(data)
        end

        def mandate_document(payment_method_id)
          @client.get(version: :v2).call("payment_methods/#{payment_method_id}/mandate_document")
        end

        private

        def flatten_form(fields, prefix = nil)
          fields.each_with_object({}) do |(key, value), form|
            name = prefix ? "#{prefix}[#{key}]" : key.to_s
            if value.is_a?(Hash)
              form.merge!(flatten_form(value, name))
            else
              form[name] = value
            end
          end
        end

        def form_part(name, value)
          return value if value.is_a?(HTTP::FormData::Part)

          if name.include?('[consent_documents]')
            HTTP::FormData::File.new(value)
          else
            HTTP::FormData::Part.new(value)
          end
        end

        def build_payment_method(data)
          Fintoc::V2::PaymentMethod.new(**data)
        end
      end
    end
  end
end

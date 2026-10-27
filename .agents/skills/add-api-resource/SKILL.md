---
name: add-api-resource
description: Use when adding or updating public v1/v2 API resources, actions, or fields in fintoc-ruby.
---

# Add or update an API resource

## SDK model

Managers expose API operations and build request paths. Resources represent responses and provide instance behavior. `BaseClient` handles HTTP, authentication, signing, and idempotency. Its pagination helper is opt-in; v2 `list` methods return one page.

Follow the closest existing resource in the same API version. Delegate transport to the shared client and expose only operations supported by the API contract. Follow existing signatures: required create inputs are usually explicit keywords, while optional inputs and updates commonly use `**params`; lists use `list(**params)`. Preserve existing public signatures.

Use the relevant contract from [main-api.json](https://github.com/fintoc-com/fintoc-docs/blob/main/reference/main-api.json) or [core-api.json](https://github.com/fintoc-com/fintoc-docs/blob/main/reference/core-api.json) in `fintoc-docs`.

## Choose the scope

| Change | Implementation |
| --- | --- |
| New standalone resource | Add its manager and resource, require them, and register a memoized manager accessor on the client for the appropriate API version. |
| New operation or action | Add a manager method for its path, HTTP method, and response type. |
| Nested resource | Follow the existing parent access and construction pattern rather than adding a root client accessor. |
| New field | Add an `attr_reader` and initializer mapping; use a keyword argument or `**attributes` for reserved names such as `alias`. Update `refresh` or custom mappings when present. |
| New error code | Add the corresponding `FintocError` subclass in `lib/fintoc/errors.rb`; missing classes cause `NameError` during error resolution. |

Most resources discard unknown keywords through trailing `**`; accepting a field does not expose it. Preserve existing type conversions and behavior when fields are absent or null.

`BaseClient` serializes explicit `nil` arguments. For new operations, preserve omission versus intentional nulls as required by the contract, as recipients does. Existing wrappers such as `AccountNumber#update` filter nulls; do not change their behavior incidentally. Pass signing and idempotency options to the client operation, not the request body, where required by the contract.

## Tests

For new resources, prefer the recipients pattern in `spec/lib/fintoc/v2/managers/recipients_manager_spec.rb`: a real versioned client, WebMock requests, and JSON fixtures under `spec/fixtures/`. Check routing, parameter forwarding, relevant headers, and response conversion. When extending existing coverage, retain its shared client examples, VCR cassettes, or client doubles rather than migrating unrelated tests.

Add focused tests for declared fields, custom behavior, relevant failures, and refresh when affected. Reuse shared transport coverage rather than repeating authentication, signing, or idempotency internals for every resource.

For this workflow, create synthetic fixtures and cassettes from the contract's examples or schemas, using fake credentials; never record against the API. VCR cassette paths derive from full RSpec descriptions and match method, URI, and body, not headers. WebMock can assert headers directly; with VCR, use manager expectations for new signing or idempotency options.

Install missing dependencies with `bundle install`. Run affected specs first, then the full suite and RuboCop. `spec_helper.rb` defaults to VCR `record: :once`, which allows real traffic for missing cassettes; force `record: :none` when validating:

```sh
bundle exec ruby -Ilib -Ispec -r rspec/core -r spec_helper -e 'VCR.configure { |c| c.default_cassette_options = c.default_cassette_options.merge(record: :none) }; exit RSpec::Core::Runner.run(ARGV)' -- spec
bundle exec rubocop
```

Replace `spec` with the affected spec paths for a focused run. Fix missing or mismatched cassettes without enabling recording.

## Documentation and PR

Update relevant README examples in English when public usage changes. Follow the repository's PR template and identify synthetic cassettes when added or changed. Keep version bumps, release changelog updates, and releases separate from resource changes; leave the template's version/CHANGELOG checkbox unchecked when not applicable.

# frozen_string_literal: true

module Fintoc
  # A handful of run-of-the-mill utilities
  module Utils
    extend self

    # Get a flat Array out of a list of lists of Iterables(Enumerators)
    #
    def flatten(sequences)
      Enumerator::Chain.new(*sequences).to_a
    end

    # If the key exists, you will get that key-value pair.
    #
    # @param dict_ [Hash] the hash to pick from
    # @param key [String] the key to look at
    # @return [Hash] the key-value pair or an empty hash
    def pick(dict_, key)
      key = key.to_sym
      if dict_.key?(key)
        { "#{key}": dict_[key] }
      else
        {}
      end
    end

    # Get a pluralized noun with its appropiate quantifier
    #
    # @param amount [Integer]
    # @param noun [String] the noun to pluralize
    # @param suffix [String]
    # @return [String]
    def pluralize(amount, noun, suffix = 's')
      quantifier = amount or 'no'
      "#{quantifier} #{amount == 1 ? noun : noun + suffix}"
    end

    # Transform a snake-cased name to its pascal-cased version.
    #
    # @param name [String]
    # @return [String]
    def snake_to_pascal(name)
      name.split('_').map(&:capitalize).join('')
    end
  end
end

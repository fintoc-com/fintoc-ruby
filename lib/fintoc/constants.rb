module Fintoc
  module Constants
    API_BASE_URL = 'https://api.fintoc.com'
    API_VERSION = 'v1'

    LINK_HEADER_PATTERN = /<(?<url>.*)>;\s*rel="(?<rel>.*)"/
  end
end

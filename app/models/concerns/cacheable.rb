module Cacheable
  def fetch_cached(key, opts = {}, &block)
    opts[:expires_in] ||= 10.minutes
    Rails.cache.fetch(key, opts, &block)
  end
end
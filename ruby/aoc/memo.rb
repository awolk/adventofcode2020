module Memo
  def memoize(name)
    cache = {}
    unmemoized = :"#{name}_unmemoized"
    self.class.alias_method unmemoized, name
    define_method(name) do |*args|
      cache[args] ||= send(unmemoized, *args)
    end
  end
end
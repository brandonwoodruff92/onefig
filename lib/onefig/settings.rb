module Onefig
  class Settings
    include Enumerable
    extend Forwardable

    def_delegators :store, :keys, :empty?, :key?, :has_key?, :each

    def initialize(hash = {})
      @store = {}
      hash.each_pair do |key, value|
        set(key, value)
      end
    end

    def store
      @store
    end

    def []=(key, value)
      key = key.to_sym
      build_accessor!(key)
      @store[key] = value
    end
    alias :set, :[]=

    def [](key)
      @store[key.to_sym]
    end
    alias :get, :[]

    def each_pair
      return to_enum(__method__) { @store.size } unless block_given?
      @store.each_pair{ |pair| yield pair }
      self
    end

    def delete(key, &block)
      key = key.to_sym
      begin 
        singleton_class.remove_method(key, "#{key}=")
      rescue NameError
      end
      @store.delete(key) do
        return yield if block
        raise NameError, "Key not found: #{key.inspect}"
      end
    end

    def dig(name, *names)
      begin
        name = name.to_sym
      rescue NoMethodError
        raise TypeError, "#{name} is not a symbol nor a string"
      end
      value = @store[name]
      return nil if value.nil?
      if names.empty?
        value
      elsif value.respond_to?(:dig)
        value.dig(*names)
      else
        nil
      end
    end

    def to_hash
      result = {}
      @store.each do |key, value|
        if value.instance_of?(Array)
          result[key] = elements_to_hash(value)
        elsif element.respond_to?(:to_h)
          element.to_h
        elsif element.respond_to?(:to_hash)
          element.to_hash
        else
          result[key] = value
        end
      end
    end
    alias :to_h, :to_hash

    def to_json(*args)
      to_hash.to_json(*args)
    end

    def freeze
      @store.freeze
      super
    end

    def ==(other)
      return false unless other.kind_of?(Onefig::Settings)
      @store == other.store
    end

    def hash
      @store.hash
    end

    private

    def method_missing(method_name, *args, &block)
      if key = method_name[/.*(?==\z)/m]
        if args.length != 1
          raise ArgumentError, "wrong number of arguments (given #{args.length}, expected 1)", caller(1)
        end
        set(key, args.first)
      elsif args.length == 0
        @store[method_name.to_sym]
      else
        begin
          super
        rescue NoMethodError => error
          error.backtrace.shift
          raise
        end
      end
    end

    def elements_to_hash(array)
      array.map do |element|
        if element.instance_of?(Array)
          elements_to_hash(element)
        elsif element.respond_to?(:to_h)
          element.to_h
        elsif element.respond_to?(:to_hash)
          element.to_hash
        else
          element
        end
      end
    end

    def build_accessor!(name)
      unless has_key?(name) || is_method_protected!(name)
        define_singleton_method(name) { @table[name] }
        define_singleton_method("#{name}=") { |value| @table[name] = value }
      end
    end

    def is_method_protected!(name)
      if !respond_to?(name, true)
        false
      elsif name.match?(/!$/)
        true
      else
        owner = method!(name).owner
        if owner.class == ::Class
          owner < ::Onefig::Settings
        else
          self.class!.ancestors.any? do |mod|
            return false if mod == ::Onefig::Settings
            mod == owner
          end
        end
      end
    end
  end
end
module ParseModel
  module FieldAttributes

    # Requires an instance method #pfdelegate that defines PFobject
    #
    module ClassMethods
      def field_reader(*keys)
        keys.each do |key|
          # def foo
          #   @PFObject.objectForKey(:foo)
          # end
          self.class_eval <<-RUBY,__FILE__,__LINE__ +1
            def #{key}
              self.pfdelegate.objectForKey(#{key.to_sym.inspect})
            end
          RUBY
        end
      end

      def field_writer(*keys)
        keys.each do |key|
          # def foo=(value)
          #   @PFObject.setObject(value, forKey: :foo)
          # end
          self.class_eval <<-RUBY,__FILE__,__LINE__ +1
            def #{key}=(value)
              self.pfdelegate.setObject(value, forKey: #{key.to_sym.inspect})
            end
          RUBY
        end
      end

      def field_accessor(*keys)
        @fields = keys
        field_reader(*keys)
        field_writer(*keys)
      end

      alias_method :fields, :field_accessor

      def get_fields
        @fields
      end
    end
  end
end
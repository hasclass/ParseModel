module ParseModel

  module Model
    attr_accessor :PFObject

    def initialize(arg=nil)
      if arg.is_a?(PFObject)
        @PFObject = arg
      else
        @PFObject = PFObject.objectWithClassName(self.class.to_s)
        if arg.is_a?(Hash)
          arg.each do |k,v|
            @PFObject.setObject(v, forKey:k) if fields.include?(k)
          end
        end
      end
    end

    # required by ParseModel::FieldAttributes::ClassMethods
    def pfdelegate
      @PFObject
    end

    def method_missing(method, *args, &block)
      if @PFObject.respond_to?(method)
        @PFObject.send(method, *args, &block)
      else
        super
      end
    end

    def fields
      self.class.send(:get_fields)
    end

    module ClassMethods
      include ParseModel::FieldAttributes::ClassMethods

      def query
        ParseModel::Query.alloc.initWithClassNameAndClassObject(self.name, classObject:self)
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end

  end
end
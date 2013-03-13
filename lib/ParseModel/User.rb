module ParseModel
  module User
    attr_accessor :PFUser

    RESERVED_KEYS = ['username', 'password', 'email']

    fields *RESERVED_KEYS

    def initialize
      @PFUser = PFUser.user
    end

    # required by ParseModel::FieldAttributes::ClassMethods
    def pfdelegate
      @PFUser
    end

    def method_missing(method, *args, &block)
      if @PFUser.respond_to?(method)
        @PFUser.send(method, *args, &block)
      else
        super
      end
    end

    def fields
      self.class.send(:get_fields)
    end

    module ClassMethods
      include ParseModel::FieldAttributes::ClassMethods

      def current_user
        if PFUser.currentUser
          u = new
          u.PFUser = PFUser.currentUser
          u
        else
          nil
        end
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end

  end
end

module Rolify
  module Resource
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods 
      def find_roles(role_name = nil, user = nil)
        roles = user && (user != :any) ? user.roles : self.role_class
        roles = roles.where(:resource_type => Rolify.resource_type(self))
        roles = roles.where(:name => role_name.to_s) if role_name && (role_name != :any)
        roles
      end

      def with_role(role_name, user = nil)
        if role_name.is_a? Array
          role_name.map!(&:to_s)
        else
          role_name = role_name.to_s
        end
        resources = self.adapter.resources_find(self.role_table_name, self, role_name)
        user ? self.adapter.in(resources, user, role_name) : resources
      end
      alias :with_roles :with_role
    end
    
    def applied_roles
      puts "applied roles has #{Rolify.resource_type(self.class)}"
      self.roles + self.class.role_class.where(:resource_type => Rolify.resource_type(self.class), :resource_id => nil)
    end
  end
end
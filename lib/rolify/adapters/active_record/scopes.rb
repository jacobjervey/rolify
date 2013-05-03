module Rolify
  module Adapter
    module Scopes
      def global
        where(:resource_type => nil, :resource_id => nil)
      end
      
      def class_scoped(resource_type = nil)
        where_conditions = "resource_type IS NOT NULL AND resource_id IS NULL"
        where_conditions = [ "resource_type = ? AND resource_id IS NULL", Rolify.resource_type(resource_type) ] if resource_type
        where(where_conditions)
      end
      
      def instance_scoped(resource_type = nil)
        where_conditions = "resource_type IS NOT NULL AND resource_id IS NOT NULL"
        if resource_type
          if resource_type.is_a? Class
            where_conditions = [ "resource_type = ? AND resource_id IS NOT NULL", Rolify.resource_type(resource_type) ]
          else
            where_conditions = [ "resource_type = ? AND resource_id = ?", Rolify.resource_type(resource_type.class), resource_type.id ]
          end
        end
        where(where_conditions)
      end
    end
  end
end
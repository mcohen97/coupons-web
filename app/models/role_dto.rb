class RoleDto 
    attr_accessor :name, :permissions

    def initialize(args)
        @name = args['name']
        @permissions = args['permissions']
    end
end

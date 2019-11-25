class UserDto 
    attr_accessor :email, :password, :name, :surname, :org_id, :role

    def initialize(args)
        @email = args['username']
        @password = args['password']
        @name = args['name']
        @surname = args['surname']
        @org_id = args['org_id']
        @role = RoleDto.new(args['role'])
    end

    def is_admin
        puts @role.name
        @role.name == 'ADMIN'
    end
end
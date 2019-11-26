class OrganizationDto
    attr_accessor :org_id, :name

    def initialize(args)
        @org_id = args['org_id']
        @name = args['name']
    end
end
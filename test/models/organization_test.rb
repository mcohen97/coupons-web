# frozen_string_literal: true

require 'test_helper'

class OrganizationTest < ActiveSupport::TestCase
  test 'should save organization with specified data' do
    org = Organization.new(organization_name: 'organization')
    assert org.save
    assert_equal('organization', org.organization_name)
  end

  test 'should not save organization with empty name' do
    org = Organization.new
    assert_not org.save
    assert org.errors[:organization_name].any?
  end

  test 'should not save organizations with same name' do
    org = Organization.new(organization_name: 'organization')
    assert org.save
    org = Organization.new(organization_name: 'organization')
    assert_not org.save
  end
end

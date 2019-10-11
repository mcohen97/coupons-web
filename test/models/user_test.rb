# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'should create user with specified data' do
    user = User.new(email: 'mail@hotmail.com', password: 'password', name: 'name', surname: 'surname', role: 'org_user', organization_id: 1)

    assert user.save

    assert_equal('mail@hotmail.com', user.email)
    assert_equal('password', user.password)
    assert_equal('name', user.name)
    assert_equal('surname', user.surname)
    assert_equal('org_user', user.role)
    assert_equal(1, user.organization_id)
  end

  test 'should not save user with empty email' do
    user = User.new(password: 'password', name: 'name', surname: 'surname', role: :administrator, organization_id: 1)

    assert_not user.save
    assert user.errors[:email].any?
  end

  test 'should not save user with empty password' do
    user = User.new(email: 'mail@hotmail.com', name: 'name', surname: 'surname', role: :administrator, organization_id: 1)

    assert_not user.save
    assert user.errors[:password].any?
  end

  test 'should not save user with password shorter than 6 characters' do
    user = User.new(email: 'mail@hotmail.com', password: 'pass', name: 'name', surname: 'surname', role: :administrator, organization_id: 1)

    assert_not user.save
    assert user.errors[:password].any?
  end

  test 'should not save user with empty name' do
    user = User.new(email: 'mail@hotmail.com', password: 'password', surname: 'surname', role: :administrator, organization_id: 1)
    assert_not user.save
    assert user.errors[:name].any?
  end

  test 'should not save user with empty surname' do
    user = User.new(email: 'mail@hotmail.com', password: 'password', name: 'name', role: :administrator, organization_id: 1)
    assert_not user.save
    assert user.errors[:surname].any?
  end

  test 'should not save user with empty role' do
    user = User.new(email: 'mail@hotmail.com', password: 'password', name: 'name', surname: 'surname', organization_id: 1)
    assert_not user.save
    assert user.errors[:role].any?
  end

  test 'should not save user if role is in roles collection' do
    user = User.new(email: 'mail@hotmail.com', password: 'password', name: 'name', surname: 'surname', role: :potus, organization_id: 1)
    assert_not user.save
    assert user.errors[:role].any?
  end

  test 'should not save user without organization' do
    user = User.new(email: 'mail@hotmail.com', password: 'password', name: 'name', surname: 'surname', role: :administrator)
    assert_not user.save
    assert user.errors[:organization_id].any?
  end

  test 'should not save users with repeated emails' do
    user = User.new(email: 'mail@hotmail.com', password: 'password', name: 'name', surname: 'surname', role: 'org_user', organization_id: 1)
    assert user.save
    user = User.new(email: 'mail@hotmail.com', password: 'password', name: 'name', surname: 'surname', role: 'org_user', organization_id: 1)
    assert_not user.save
    assert user.errors[:email].any?
  end
end

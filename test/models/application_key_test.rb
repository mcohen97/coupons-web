# frozen_string_literal: true

require 'test_helper'

class ApplicationKeyTest < ActiveSupport::TestCase
  test 'should create application key with the specified data' do
    # ids taken from promotions fixture
    appkey = ApplicationKey.new(name: 'pedidosYaKey', organization_id: 1, promotion_ids: [1, 4])

    assert appkey.save
    assert_equal('pedidosYaKey', appkey.name)
    assert_equal(1, appkey.organization_id)
    assert_equal(2, appkey.promotion_ids.count)
  end

  test 'should not create appkey with nil app key' do
    appkey = ApplicationKey.new(organization_id: 1, promotion_ids: [1, 4])
    assert_not appkey.save
    assert appkey.errors[:name].any?
  end

  test 'should not create appkey with blank app key' do
    appkey = ApplicationKey.new(name: '', organization_id: 1, promotion_ids: [1, 4])
    assert_not appkey.save
    assert appkey.errors[:name].any?
  end

  test 'should not create appkey with access to promotions from another org' do
    appkey = ApplicationKey.new(name: 'pedidosYaKey', organization_id: 1, promotion_ids: [1, 2])
    assert_not appkey.save
    assert appkey.errors[:promotions].any?
  end

  test 'should not save appkeys with same name' do
    appkey = ApplicationKey.new(name: 'pedidosYaKey', organization_id: 1, promotion_ids: [1, 4])
    assert appkey.save
    appkey = ApplicationKey.new(name: 'pedidosYaKey', organization_id: 1, promotion_ids: [1, 4])
    assert_not appkey.save
  end
end

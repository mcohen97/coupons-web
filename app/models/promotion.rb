# frozen_string_literal: true

require 'parser.rb'
require 'securerandom'
require_relative '../../lib/error/promotion_arguments_error.rb'
require_relative '../../lib/error/not_authorized_error.rb'
require_relative '../../lib/error/not_authenticated_error.rb'

class Promotion
  include ActiveModel::Model

  attr_accessor :id, :name, :code, :type, :return_type, :return_value, :condition, :active, :promotion_type, :expiration, :checked

  def initialize(args = {})
    args.transform_keys!(&:to_sym) # keys from string to simbol
    @id = args[:id]
    @name = args[:name]
    @code = args[:code]
    @type = args[:type]
    @return_type = args[:return_type]
    @return_value = args[:return_value]
    @condition = args[:condition]
    @active = args[:active]
    @promotion_type = args[:promotion_type]
    @expiration = args[:expiration]
    @new = args[:new].nil? || args[:new]
    @checked = false
  end

  def percentage?
    @return_type == 'percentage'
  end

  def persisted?
    return !@new
  end

  def ==(o)
    o.class == self.class && o.id == id
  end

  def eql?(o)
    o.class == self.class && o.id == id
    end

  def hash
    id
  end

end

#require_relative '../../app/parser'
require 'test_helper'

 
class PromotionTest < ActiveSupport::TestCase
 
  def test_format_correct_expression
    parser = Parser.new(['total', 'quantity'])
    result = parser.format_expression('total <= 100 AND ( quantity >= 5 OR total > 10 )')
    expected = '( total <= 100 ) AND ( ( quantity >= 5 ) OR ( total > 10 ) )'
    assert_equal expected, result
  end

  def test_empty_expression_error
    parser = Parser.new
    assert_raise ParsingError do
      parser.format_expression('')
    end
  end

  def test_nil_expression_error
    parser = Parser.new
    assert_raise ParsingError do
      parser.format_expression(nil)
    end
  end

  def test_wrong_operator
    parser = Parser.new
    assert_raise ParsingError do
      parser.format_expression('2 + 3')
    end
  end

  def test_boolean_operator_with_literals_error
    parser = Parser.new(['total', 'quantity'])
    
    assert_raise ParsingError do
      parser.format_expression('total AND quantity')
    end
  end

  def test_consecutive_literals_error
    parser = Parser.new(['total', 'quantity'])
    
    assert_raise ParsingError do
      parser.format_expression('total quantity')
    end
  end

  def test_comparator_with_conditionals_error
    parser = Parser.new(['total', 'quantity'])
    
    assert_raise ParsingError do
      result = parser.format_expression('(total <= 100 AND quantity <= 10) >= ( quantity >= 5 OR total > 10 )')
    end
  end

  def test_evaluate_correct_true
    parser = Parser.new(['total', 'quantity'])
    condition = 'total <= 100 AND ( quantity >= 5 OR total > 10 )'
    assert parser.evaluate_condition(condition, {total: 15, quantity: 3})
  end

  def test_evaluate_correct_precedence
    parser = Parser.new(['total', 'quantity'])
    condition = 'total <= 100 AND ( quantity >= 5 OR total > 10 )'
    assert parser.evaluate_condition(condition, {total: 3, quantity: 6})
  end

  def test_evaluate_correct_false
    parser = Parser.new(['total', 'quantity'])
    condition = 'total <= 100 AND ( quantity >= 5 OR total > 10 )'
    assert_not parser.evaluate_condition(condition, {total: 102, quantity: 6})
  end

  def test_evaluate_with_missing_var
    parser = Parser.new(['total', 'quantity'])
    condition = 'total <= 100 AND ( quantity >= 5 OR total > 10 )'
    assert_raise ParsingError do
      parser.evaluate_condition(condition, {total: 5})
    end
  end
 
end
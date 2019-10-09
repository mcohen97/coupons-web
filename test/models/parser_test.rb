# frozen_string_literal: true

require 'test_helper'

class ParserTest < ActiveSupport::TestCase
  def test_format_correct_expression
    parser = Parser.new
    expression = parser.parse('total <= 100 AND ( quantity >= 5 OR total > 10 )')
    expected = '( total <= 100 ) AND ( ( quantity >= 5 ) OR ( total > 10 ) )'
    assert_equal expected, expression.to_string
  end

  def test_empty_expression_error
    parser = Parser.new
    assert_raise ParsingError do
      parser.parse('')
    end
  end

  def test_nil_expression_error
    parser = Parser.new
    assert_raise ParsingError do
      parser.parse(nil)
    end
  end

  def test_wrong_operator
    parser = Parser.new
    assert_raise ParsingError do
      parser.parse('2 + 3')
    end
  end

  # def test_boolean_operator_with_literals_error
  #  parser = Parser.new()

  #  assert_raise ParsingError do
  #    parser.parse('total AND quantity')
  #  end
  # end

  def test_consecutive_literals_error
    parser = Parser.new

    assert_raise ParsingError do
      parser.parse('total quantity')
    end
  end

  def test_comparator_with_conditionals_error
    parser = Parser.new

    assert_raise ParsingError do
      result = parser.parse('(total <= 100 AND quantity <= 10) >= ( quantity >= 5 OR total > 10 )')
    end
  end

  def test_wrong_order
    parser = Parser.new

    assert_raise ParsingError do
      parser.parse('= quantity 10')
    end
  end

  def test_conditionals_with_variable
    parser = Parser.new
    expr = parser.parse('boolean1 AND quantity <= 10')
    assert_equal 'boolean1 AND ( quantity <= 10 )', expr.to_string
  end

  def test_evaluate_correct_true
    parser = Parser.new
    condition = 'total <= 100 AND ( quantity >= 5 OR total > 10 )'
    expression = parser.parse(condition)
    assert expression.evaluate_condition(total: 15, quantity: 3)
  end

  def test_evaluate_correct_precedence
    parser = Parser.new
    condition = 'total <= 100 AND ( quantity >= 5 OR total > 10 )'
    expression = parser.parse(condition)
    assert expression.evaluate_condition(total: 3, quantity: 6)
  end

  def test_evaluate_correct_false
    parser = Parser.new
    condition = 'total <= 100 AND ( quantity >= 5 OR total > 10 )'
    expression = parser.parse(condition)
    assert_not expression.evaluate_condition(total: 102, quantity: 6)
  end

  def test_evaluate_with_missing_var
    parser = Parser.new
    condition = 'total <= 100 AND ( quantity >= 5 OR total > 10 )'
    expression = parser.parse(condition)
    assert_raise ParsingError do
      expression.evaluate_condition(total: 5)
    end
  end

  def test_evaluate_with_wrong_types
    parser = Parser.new
    condition = 'segunda_compra AND total > 10'
    expression = parser.parse(condition)
    assert_raise ParsingError do
      expression.evaluate_condition(segunda_compra: 3, total: 5)
    end
  end

  def test_evaluate_with_string_values
    parser = Parser.new
    condition = 'total > 10'
    expression = parser.parse(condition)
    assert_raise ParsingError do
      expression.evaluate_condition(total: "a string")
    end
  end
end

class LogicCondition
  
  def initialize(parsed_expression)
    @syntactic_tree = parsed_expression
  end

  def evaluate_condition(variable_values)
    return evaluate_tree(@syntactic_tree, variable_values)
  end

  def to_string
    return tree_to_string(@syntactic_tree)
  end

  private

  # a valid tree must be inserted
  def evaluate_tree(tree, variable_values)
    if tree[:type] == :literal
      literal = tree[:symbol]
      return to_number(literal, variable_values)
    else 
      left = evaluate_tree(tree[:left], variable_values)
      right = evaluate_tree(tree[:right], variable_values)
      return operate(tree[:symbol], left, right)
    end
  end

  def to_number(literal, variable_values)
    if is_number?(literal)
      return Float(literal)
    else
      value = variable_values[literal.to_sym]
      if value == nil
        raise ParsingError, "Variable: #{literal} has not defined value"
      end
      if is_boolean?(value)
        return value
      end
      return Float(value)
    end
  end

  def operate(operator, left_value, right_value)
    if ['>','>=', '=', '<=', '<' ].include?(operator)
      return left_value.send(operator, right_value)
    end
    
    if !(is_boolean?(left_value) && is_boolean?(right_value))
      raise ParsingError, "Logical operator: #{operator} with non-boolean values"
    end

    if operator.upcase == 'AND'
      return left_value && right_value
    else
      return left_value || right_value
    end
  end

  def tree_to_string(tree, first_call = true)
    if tree[:type] == :literal
      return tree[:symbol]
    else
      if !first_call
        return "( #{tree_to_string(tree[:left], false)} #{tree[:symbol]} #{tree_to_string(tree[:right], false)} )"
      else
        return "#{tree_to_string(tree[:left], false)} #{tree[:symbol]} #{tree_to_string(tree[:right], false)}"
      end
    end
  end

  def is_number? (string)
    true if Float(string) rescue false
  end

  def is_boolean?(value)
    return (!!value == value)
  end

end
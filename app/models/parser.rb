require_relative '../../lib/error/parsing_error.rb'

class Parser

  def initialize(variables = [])
    @permited_variables = variables
    @delimiter = ' '
  end

  def format_expression(exp_string)
    if exp_string.nil? || exp_string.empty?
      raise ParsingError, "empty string"
    end
    tree = build_tree(exp_string)
    linearized_tree = tree_to_string(tree)
    return linearized_tree
  end

  def evaluate_condition(exp_string, variable_values)
    tree = build_tree(exp_string)
    return evaluate_tree(tree, variable_values)
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
        return Float(value)
      end
    end

    def operate(operator, left_value, right_value)
      if ['>','>=', '=', '<=', '<' ].include?(operator)
        return left_value.send(operator, right_value)
      elsif operator.upcase == 'AND'
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

    def build_tree(exp_string)
      terms = Array.new
      operators = Array.new

      exp_string.split(@delimiter).each{ |t|
        if(t == '(')
          operators.push(t)
        elsif (t == ')')
          # when end of subexpresion reached
          reduce_end(terms, operators)
        elsif(is_operator(t))
          reduce_operator(terms, operators,t)
        else
          reduce_literal(terms,t)
        end
      }
      reduce_end(terms, operators)

      if !operators.empty? || terms.size != 1
        raise ParsingError, "The expression lacks operators"
      end

      terms.pop
    end

    def is_operator(op)
      priority(op) > 0
    end

    def reduce_operator(accum, operators, current_operator)
      if accum.empty?
        #excepcion
      end
      
      while !operators.empty? && operators.last != '(' && priority(operators.last) >= priority(current_operator)
        process_op(accum, operators.last)
        operators.pop
      end
      operators.push(current_operator)
    end

    def reduce_end(accum, operators)
      while !operators.empty? && operators.last != '('
        process_op(accum, operators.last)
        operators.pop
      end
      if operators.last == '('
        operators.pop
      end
    end

    def reduce_literal(accum, lit)
      if !is_literal(lit)
        raise ParsingError, "Invalid literal: #{lit}"
      end
      partial_result = {type: :literal, symbol: lit}
      accum.push(partial_result)
    end

    def priority(op)
      if op == 'AND' || op == 'OR'
        return 1
      end
      if op == '<' || op =='>' || op == '<=' || op == '>='||op =='='
        return 2
      end
      return -1 # exception
    end

    def process_op(result, op)
      if result.size < 2
        raise ParsingError ,"operator #{op} lacks operands"
      end
      r = result.last
      result.pop
      l = result.last
      result.pop
      case (op.upcase) 
        when '<','>','<=','>=','='
          add_term(result,l,r,op) 
        when 'AND','OR'
          add_condition(result, l, r, op)
      end
      
    end

    def add_term(accum_result, left, right, op)
    
      if left[:type] != :literal || right[:type] != :literal
        raise ParsingError, 'Comparator with non-literal operands'
      end

      partial_result = { type: :comparator, symbol: op,
                         left: left, right: right }
      accum_result.push(partial_result)
    end

    def add_condition(accum_result, left, right, op)
      if left[:type] == :literal || right[:type] == :literal
        raise ParsingError, "Conditional with non-logical operands"
      end
      partial_result = {type: :comparator, symbol: op, left: left, right: right}

      accum_result.push(partial_result)
    end

    def is_literal(literal)
      is_number?(literal) || (@permited_variables.include? literal)
    end

    def is_number? (string)
      true if Float(string) rescue false
    end
end
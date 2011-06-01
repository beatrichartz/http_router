class HttpRouter
  class Node
    class GlobRegex < SpanningRegex
      def to_code(pos)
        indented_code pos, "
          whole_path = r#{pos}.joined_path
          if match = #{@matcher.inspect}.match(whole_path) and match.begin(0).zero?
            r#{pos.next} = r#{pos}.dup\n" << 
          @capturing_indicies.map { |c| "r#{pos.next}.params << URI.unescape(match[#{c}].split(/\\//))\n" }.join << "
          remaining_path = whole_path[match[0].size + (whole_path[match[0].size] == ?/ ? 1 : 0), whole_path.size]
          r#{pos.next}.path = remaining_path.split('/')
          #{super(pos.next)}
        end
          "
      end
    end
  end
end
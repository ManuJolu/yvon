module CoreExtensions
  module Array
    module Containing
      def contains_all?(other)
        other = other.dup
        each{ |e| if i = other.index(e) then other.delete_at(i) end }
        other.empty?
      end
    end
  end
end

Array.include CoreExtensions::Array::Containing

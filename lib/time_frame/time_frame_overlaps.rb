# Encoding: utf-8
class TimeFrame
  # Traverses all intersections of in the cross product of two arrays of
  # time_frames and yields the block for each pair (linear runtime)
  #
  # NOTE:
  # * requires each of the arrays to consist of pairwise disjoint elements
  # * requires each of the arrays to be sorted
  class Overlaps
    def initialize(array1, array2)
      @array1 = array1.reject(&:empty?)
      @array2 = array2.reject(&:empty?)
    end

    def each(&block)
      return [] if @array1.empty? || @array2.empty?
      yield_current_items(&block) if current_items_overlapping?
      while arrays_have_many_items?
        shift
        yield_current_items(&block) if current_items_overlapping?
      end
    end

    private

    def shift
      if @array2.one? ||
          @array1.many? && @array1.second.min < @array2.second.min
        @array1.shift
      else
        @array2.shift
      end
    end

    def arrays_have_many_items?
      @array1.many? || @array2.many?
    end

    def yield_current_items
      yield @array1.first, @array2.first
    end

    def current_items_overlapping?
      time_frame = @array1.first & @array2.first
      time_frame && time_frame.duration > 0
    end
  end
end

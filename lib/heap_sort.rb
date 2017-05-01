require_relative "heap"

class Array
  def heap_sort!
    heap = BinaryMinHeap.new
    self.length.times do
      heap.push(self.pop)
    end

    until heap.count == 0
      self << heap.extract
    end
  end
end

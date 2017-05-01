require 'byebug'

class BinaryMinHeap
  def initialize(&prc)
    @store = []
    @prc = prc
  end

  def count
    @store.length
  end

  def extract
    @store = self.class.swap(@store, 0, -1)
    extracted = @store.pop
    if count > 1
      self.class.heapify_down(@store, 0, count, &@prc)
    end
    extracted
  end

  def peek
    @store.first
  end

  def push(val)
    @store << val
    self.class.heapify_up(@store, @store.last, count, &@prc)
  end

  protected
  attr_accessor :prc, :store

  public
  def self.child_indices(len, parent_index)
      child1 = parent_index * 2 + 1
      child2 = parent_index * 2 + 2
      arr = []

      arr << child1 if child1 < len
      arr << child2 if child2 < len
      arr
  end

  def self.parent_index(child_index)
    if child_index == 0
      raise "root has no parent"
    else
      (child_index - 1) / 2
    end
  end

  def self.heapify_down(array, parent_idx, len = array.length, &prc)
    i = parent_idx
    prc ||= Proc.new{ |x, y| x <=> y }
    while i <= parent_index(len - 1)
      smallest_child = child_indices(len, i).min_by { |idx| array[idx]}
      largest_child = child_indices(len, i).max_by { |idx| array[idx]}

      case prc.call(array[i],array[smallest_child])
      when 1
        case prc.call(array[smallest_child],array[largest_child])
        when 1
          swap(array, i, largest_child)
          i = largest_child
        else
          swap(array, i, smallest_child)
          i = smallest_child
        end
      else
        break
      end
    end
    array
  end

  def self.heapify_up(array, child_idx, len = array.length, &prc)
    i = len - 1
    prc ||= Proc.new{ |x, y| x <=> y }
    while i > 0
      parent = parent_index(i)
      child = i
      case prc.call(array[child], array[parent])
      when -1
        array = swap(array, child, parent)
        i = parent
      else
        break
      end
    end
    array
  end

  def self.swap(arr, idx1, idx2)
    arr[idx1], arr[idx2] = arr[idx2], arr[idx1]
    arr
  end
end

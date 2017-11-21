
class Salsa20
  def initialize key, rounds
    if key.length != 4 && key.length != 8 then
      throw "wrong key"
    end
    @key = key
    @rounds = rounds
    @cur_state = 0;
  end

  def cur_state
    Array.new(4) do |i|
      @cur_state << (16 - i*4)
    end
  end

  def make_state

    if @key.length == 4 then
      sigma[0...1] + @key + sigma[1...2] + cur_state + sigma[2...3] + @key + sigma[3...4]
    else
      sigma = [
        [101, 120, 112, 97],
        [110, 100, 32,  51],
        [50,  45,  98,  121],
        [116, 101, 32,  107]
      ].map do |i|
        littleendian i
      end
      sigma[0...1] + @key[0...4] + sigma[1...2] + cur_state + sigma[2...3] + @key[4...8] + sigma[3...4]
    end
  end

  def next
    state = make_state
    matrix = [state[0...4], state[4...8], state[8...12], state[12...16]]
    @cur_state += 1

    for i in (0...@rounds)
      matrix = doubleround matrix
    end
    matrix.flatten.map.with_index do |x, i|
      x ^ state[i]
    end
  end

  def rot32 x, n
    mask = 0xffffffff
    (x << n) & mask | (x >> (32 - n)) & mask
  end

  def quarterrouund y
    z = Array.new(4)
    z[1] = y[1] ^ (rot32 y[0] + y[3], 7)
    z[2] = y[2] ^ (rot32 z[1] + y[0], 9)
    z[3] = y[3] ^ (rot32 z[2] + z[1], 13)
    z[0] = y[0] ^ (rot32 z[3] + z[2], 18)
    return z
  end

  def rowround y
    Array.new(4) do |i|
      quarterrouund y[i]
    end
  end

  def colround y
    (Array.new(4) do |i|
      quarterrouund y.transpose[i]
    end).transpose
  end

  def doubleround y
    rowround colround y
  end

  def littleendian y
    y[0] + (1 << 8)*y[1] + (1 << 16)*y[2] + (1 << 24)*y[3]
  end

end

s = Salsa20.new [5, 5, 5, 5, 5, 5, 5, 5], 10
# s.quarterrouund [5, 5, 5, 5]
z = Array.new 4 do |i|
  Array.new(4) do |j|
    i*4 + j
  end
end
(s.doubleround z).each do |i|
  p i
end
x = s.next.map! do |i|
  i.to_s(2)
end.join("-")
p x
x = s.next.map! do |i|
  i.to_s(2)
end.join("-")
p x
# z = Array.new 35 do |i|
#   s.rot32 1, i
# end
# p z
# p z

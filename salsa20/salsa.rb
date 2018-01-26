
class Salsa20
  def initialize key, rounds
    if key.length != 4 && key.length != 8 then
      throw "wrong key"
    end
    @key = key
    @rounds = rounds
    @cur_state = 0;
    @buf = []
  end

  def cur_state
    Array.new(4) do |i|
      @cur_state & 0xffffffff << (16 - i*4)
    end
  end

  def make_state
    if @key.length == 4 then
      teta = [
        [101, 120, 112, 97],
        [110, 100, 32,  49],
        [50,  45,  98,  121],
        [116, 101, 32,  107]
      ].map do |i|
        littleendian i
      end
      teta[0...1] + @key + teta[1...2] + cur_state + teta[2...3] + @key + teta[3...4]
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
      matrix = round matrix
    end
    matrix.transpose.flatten.map.with_index do |x, i|
      # x ^ state[i]
      (x + state[i]) & 0xffffffff
    end.map! do |i|
      Array.new(4) do |j|
        (i >> (4 - j)) & 0xff
      end
    end.flatten
  end

  def next_byte
    if @buf.empty? then
      @buf = self.next
      next_byte
    else
      @buf.shift
    end
  end

  def rot32 x, n
    mask = 0xffffffff
    (x << n) & mask | (x >> (32 - n)) & mask
  end

  def quarterround y
    # p y
    y[1] ^= (rot32 y[0] + y[3], 7)
    y[2] ^= (rot32 y[1] + y[0], 9)
    y[3] ^= (rot32 y[2] + y[1], 13)
    y[0] ^= (rot32 y[3] + y[2], 18)
    return y
  end

  def round y
    y.map do |i|
      quarterround i
    end.transpose
  end

  def littleendian y
    y[0] + (1 << 8)*y[1] + (1 << 16)*y[2] + (1 << 24)*y[3]
  end

  def encript_str data
    data.each_byte.with_index do |x, i|
      data.setbyte i, x ^ next_byte
    end
  end

end

s = Salsa20.new [5, 12, 252, 11, 22, 122, 121, 110], 20
z = Array.new 4 do |i|
  Array.new(4) do |j|
    i*4 + j
  end
end
# for i in (0...12)
#   puts s.next_byte
# end
x = s.encript_str "mama rama"
puts x

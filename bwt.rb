class String
  def rotate(count=1)
    count+=self.length if count<0
    self.slice(count, self.length-count)+self.slice(0, count)
  end
end
class BWT

  def encode(string)
    l = string.length-1
    b = []
#rotate left input string
    for i in 0..l
      b.push(string.rotate(-i))
    end

#sort array
    b = b.sort

#find index of array with input string
    for i in 0..l
      if b[i] == string
        c = i+1
      end
    end

#output string of bwt
    d = ''
    for i in 0..l
      d << b[i][l]
    end
    return d, c
  end

  #bwt_decode
  def decode(string, c)
#put input in array
    decode_arr = []
    temp = string.split('')
    decode_arr += temp.sort
    l1 = temp.size
    j = 0
    while j < l1-1
      for i in 0..l1-1
        decode_arr[i] = temp[i] + decode_arr[i]
      end
      decode_arr = decode_arr.sort
      j+=1
    end
    return decode_arr[c-1]

  end
end

a = BWT.new
string = "banana"
p "Input sttring : #{string}"
p "Result of BWT : "
p c = a.encode(string)
p "Decode of BWT :"
p a.decode(c[0], c[1])
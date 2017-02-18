require 'prime'
require 'mathn'

class Integer
  def self.mod_pow(base, power, mod)
    res = 1
    while power > 0
      res = (res * base) % mod if power & 1 == 1
      base = base ** 2 % mod
      power >>= 1
    end
    res
  end
end

class RSA
  class <<self
    E = 65537


    def generate_keys(bits)
      n, e, d = 0
      p = random_prime(bits)
      q = random_prime(bits)
      n = p * q
      d = get_d(p, q, E)
      [n, E, d,p,q]
    end

    def random_number(bits)
      m = (1..bits-2).map { rand() > 0.5 ? '1' : '0' }.join
      s = "1" + m + "1"
      s.to_i(2)
    end

# Generate a random number and check if
# it's prime until a prime is found.

    def random_prime(bits)
      begin
        n = random_number(bits)
        return n if Prime.prime?(n)
      end while true
    end


    def phi(a, b)
      (a - 1) * (b - 1)
    end

#s,t => gcd(a,b) == s*a + t*b
    def extended_gcd(a, b)
      # trivial case first: gcd(a, 0) == 1*a + 0*0
      return 1, 0 if b == 0
      # recurse: a = q*b + r
      q, r = a.divmod b
      s, t = extended_gcd(b, r)
      # compute and return coefficients:
      # gcd(a, b) == gcd(b, r) == s*b + t*r == s*b + t*(a - q*b)
      return t, s - q * t
    end

# Calculate the multiplicative inverse d with d * e = 1 (mod φ(p,q)),
# using the extended euclidian algorithm.
    def get_d(p, q, e)
      t = phi(p, q)
      x, y = extended_gcd(e, t)
      x += t if x < 0
      x
    end

    def n_to_s(n)
      s = ""
      while (n > 0)
        s = (n & 0xFF).chr + s
        n >>= 8
      end
      s
    end

    def s_to_n(s)
      n = 0
      s.each_byte do |b|
        n = n * 256 + b
      end
      n
    end

    def encrypt(m, n)
      # m = m.bytes.join.to_i
      m = s_to_n(m)
      Integer.mod_pow(m, E, n)
    end

    def decrypt(c, n, d)
      m = Integer.mod_pow(c, d, n)
      n_to_s(m)
    end

  end
end

# (n,e) = public key
# (n,d) = private key
n, e, d,p,q = RSA.generate_keys(40)
puts "p              : #{p}"
puts "q              : #{q}"
m = "Hello"
puts "public exponent: #{e}"
puts "public modulus : #{n}"
puts "private exp    : #{d}"

puts ""
puts "Message        : #{m}"
puts ""
c = RSA.encrypt(m, n)
puts "Encrypted      : #{c}"
a = RSA.decrypt(c, n, d)
puts "Decrypted      : #{a}"
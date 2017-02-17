require 'prime'
# puts "Enter 2 not similiar prime numbers q and p: "
# p = gets.to_i
# q = gets.to_i
# e = 65537
#
#
# if(p != q && Prime.prime?(p) && Prime.prime?(q))
#   puts "p and q are not equal and prime"
# else
#   puts "p and q are equal and not prime"
#   exit
# end
#
# def gcd(a,b)
#   max = 1
#   for i in 2..a
#     max = i if ((a%i == 0) && (b%i==0))
#   end
#   if max == 1
#     return true
#   else return false
#   end
# end
#
# #s,t => gcd(a,b) == s*a + t*b
# def extended_gcd(a, b)
#
#   # trivial case first: gcd(a, 0) == 1*a + 0*0
#   return 1, 0 if b == 0
#
#   # recurse: a = q*b + r
#   q, r = a.divmod b
#   s, t = extended_gcd(b, r)
#
#   # compute and return coefficients:
#   # gcd(a, b) == gcd(b, r) == s*b + t*r == s*b + t*(a - q*b)
#   return t, s - q * t
# end
#
# puts "n = #{n = p*q}"
# puts "f(n) = #{f = (p-1)*(q-1)}"
#
# # puts "Enter e witch coprime with f(n):"
# # e = gets.to_i
# # while !gcd(e,f) && !Prime.prime?(e)
# #   puts "Wrong value of e. It should be coprime to #{f}"
# #   e = gets.to_i
# # end
# # puts "d = #{extended_gcd(e,f)}"
# puts  extended_gcd(e,f)

# Concatenate string (begins and ends with 1)
# to get desired length and an uneven value.

class RSA
  class <<self
    E = 65537
    def generate_keys( bits )
      n, e, d = 0
      p = random_prime( bits )
      q = random_prime( bits )
      n = p * q
      d = get_d( p, q, E )
      [n, E, d]
    end

def random_number( bits )
  m = (1..bits-2).map{ rand() > 0.5 ? '1' : '0' }.join
  s = "1" + m + "1"
  s.to_i( 2 )
end

# Generate a random number and check if
# it's prime until a prime is found.

def random_prime( bits )
  begin
    n = random_number( bits )
    return n if Prime.prime?(n)
  end while true
end


def phi( a, b )
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
  t = phi( p, q )
  x, y = extended_gcd( e, t )
  x += t if x < 0
  x
end

  end
end

# (n,e) = public key
# (n,d) = private key
n,e,d = RSA.generate_keys( 256 )

# Something we can't possibly say in public
m = "The Fast And The Furious is a great movie!"

puts "public exponent: %x" % e
puts "public modulus : %x" % n
puts "private exp    : %x" % d

puts ""
puts "Message        : %s" % m
puts ""
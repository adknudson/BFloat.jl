bitstring(x::BFloat16) = bitstring(reinterpret(uinttype(BFloat16), x))

show(io::IO, x::BFloat16) = print("BFloat16($(string(Float32(x))))")
print(io::IO, x::BFloat16) = print(string(Float32(x)))


Base.bitstring(x::BFloat16) = bitstring(x.val)
Base.show(io::IO, x::BFloat16) = print("BFloat16($(string(Float32(x))))")
Base.print(io::IO, x::BFloat16) = print(string(Float32(x)))

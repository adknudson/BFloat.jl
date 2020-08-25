struct BFloat16 <: AbstractFloat
    x::UInt16
end

function BFloat16(x::Float32)
    f = reinterpret(UInt32, x * 1.001957f0) # Magic number
    BFloat16((f >> 16) % UInt16)
end

BFloat16(x::BFloat16) = x
BFloat16(x::T) where {T<:Number} = BFloat16(Float32(x))

## Conversions to other types (BFloat16 -> T)
Float32(x::BFloat16) = reinterpret(Float32, (x.x % UInt32) << 16)
Float16(x::BFloat16) = Float16(Float32(x))
Float64(x::BFloat16) = Float64(Float32(x))

Base.bitstring(x::BFloat16) = bitstring(x.x)
Base.show(io::IO, x::BFloat16) = print("BFloat16($(string(Float32(x))))")
Base.print(io::IO, x::BFloat16) = print(string(Float32(x)))



x = BFloat16(0x4049)
bitstring(x)
Float32(x)
Float16(x)

BFloat16(3.140f0)

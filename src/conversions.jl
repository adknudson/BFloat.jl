"""
    BFloat16(x::Float32)

Magic number is used to round the result rather than truncating it 
https://stackoverflow.com/questions/55253233/convert-fp32-to-bfloat16-in-c
"""
function BFloat16(x::Float32)
    f = reinterpret(UInt32, x * 1.001957f0) # Magic number
    BFloat16((f >> 16) % UInt16)
end

BFloat16(x::BFloat16) = x
BFloat16(x::T) where {T<:Real} = BFloat16(Float32(x))
# BFloat16(x::Integer) = BFloat16(Float32(x))

BFloat16(x::UInt16) = reinterpret(BFloat16, x) # Specifically interpret UInt16 by its bit pattern

## BFloat16 Promotion rules
for t in (Int8, Int16, Int32, Int64, Int128, UInt8, UInt16, UInt32, UInt64, UInt128)
    @eval promote_rule(::Type{BFloat16}, ::Type{$t}) = BFloat16
end
promote_rule(::Type{BFloat16}, ::Type{Bool}) = BFloat16
promote_rule(::Type{BFloat16}, ::Type{Float16}) = Float32
promote_rule(::Type{BFloat16}, ::Type{Float32}) = Float32
promote_rule(::Type{BFloat16}, ::Type{Float64}) = Float64

widen(::Type{BFloat16}) = Float32

# Interpretations
reinterpret(::Type{Unsigned}, x::BFloat16) = reinterpret(UInt16, x)
reinterpret(::Type{Signed}, x::BFloat16) = reinterpret(Int16, x)

## Conversions to other types (BFloat16 -> T)
## Conversions to other types (BFloat16 -> T)
Float32(x::BFloat16) = reinterpret(Float32, (x.x % UInt32) << 16)
Float16(x::BFloat16) = Float16(Float32(x))
Float64(x::BFloat16) = Float64(Float32(x))

# BFloat16 -> Integer
(::Type{T})(x::BFloat16) where {T<:Integer} = T(Float32(x))

Bool(x::BFloat16) = x.x==0 ? false : x.x==1 ? true : throw(InexactError(:Bool, Bool, x))
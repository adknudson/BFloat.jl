# Convert Float32 to BFloat16 via truncating the last 16 bits
function BFloat16(val::Float32)
    f = reinterpret(UInt32, val)
    h = (f >> 16) % UInt16
    reinterpret(BFloat16, h)
end
BFloat16(val::Float16) = BFloat16(Float32(val))
BFloat16(val::Float64) = BFloat16(Float32(val))
BFloat16(val::Integer) = BFloat16(Float32(val))

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
BFloat16(x::BFloat16) = x
function Float32(val::BFloat16)
    local ival::UInt32 = reinterpret(uinttype(BFloat16), val)
    local sign::UInt32 = (ival & sign_mask(BFloat16)) >> 15
    local exp::UInt32  = (ival & exponent_mask(BFloat16)) >> 7
    local sig::UInt32  = (ival & significand_mask(BFloat16)) >> 0
    local ret::UInt32

    if exp == 0
        if sig == 0 # ±0
            sign = sign << 31
            ret = sign | exp | sig
        else # Subnormal numbers
            sig = sig << (23 - 7)
            while (!(sig & 0x0800))
                exp -= 0x0800
                sig <<= 1
            end
            sig &= ~0x0800
            exp += (127 << 23)
            ret = sign | exp | sig
        end
    elseif exp == 0xff
        if sig == 0  # ±Inf
            if sign == 0
                ret = 0x7f800000
            else
                ret = 0xff800000
            end
        else  # NaN
            ret = 0x7fc00000 | (sign<<31) | (sig<<(23-7))
        end
    else # normalized numbers (pad with zeros)
        ret = ival << 16
    end
    return reinterpret(Float32, ret)
end
Float16(val::BFloat16) = Float16(Float32(val))
Float64(val::BFloat16) = Float64(Float32(val))

# BFloat16 -> Integer
(::Type{T})(x::BFloat16) where {T<:Integer} = T(Float32(x))

Bool(x::BFloat16) = x==0 ? false : x==1 ? true : throw(InexactError(:Bool, Bool, x))
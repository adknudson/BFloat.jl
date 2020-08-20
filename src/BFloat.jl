module BFloat

import Base: sign_mask,
             exponent_mask, exponent_one, exponent_half, exponent_bits,
             exponent_bias, exponent_max, exponent_raw_max,
             significand_mask, significand_bits,
             uinttype,
             promote_rule, widen,
             Integer, Bool, Float16, Float32, Float64,
             unsafe_trunc,
             trunc, floor, ceil, round,
             -, +, *, /, ^, \, muladd,
             div, fld, cld, rem, mod,
             ==, <, <=, isless,
             abs, uabs,
             isnan, isfinite, precision,
             nextfloat, prevfloat,
             issubnormal,
             truncmask, truncbits,
             typemin, typemax, floatmin, floatmax, eps,
             bswap,
             iszero


import Core.Intrinsics: bitcast, bswap_int

export
    # Constructors
    BFloat16,
    # Constants
    InfB16,
    NaNB16,
    # BFloat16 properties
    sign_mask,
    exponent_mask,
    exponent_one,
    exponent_half,
    significand_mask,
    significand_bits,
    exponent_bits,
    exponent_bias,
    exponent_max,
    exponent_raw_max,
    uinttype,
    # Conversions
    Float16,
    Float32,
    Float64,
    Bool,
    Integer,
    # Promotions
    promote_rule,
    widen,
    # Functions
    unsafe_trunc,
    trunc, floor, ceil, round,
    -, +, *, /, ^, \, muladd,
    div, fld, cld, rem, mod,
    ==, <, <=, isless,
    abs,
    isnan, isfinite, precision,
    nextfloat, prevfloat,
    issubnormal,
    truncmask, truncbits,
    typemin, typemax, floatmin, floatmax, eps,
    bswap,
    iszero


primitive type BFloat16 <: AbstractFloat 16 end

const InfB16 = bitcast(BFloat16, 0x7f80)
const NaNB16 = bitcast(BFloat16, 0x7fc0)

## BFloat16 Properties
uinttype(::Type{BFloat16}) = UInt16

sign_mask(::Type{BFloat16}) =        0x8000
exponent_mask(::Type{BFloat16}) =    0x7f80
exponent_one(::Type{BFloat16}) =     0x3f80
exponent_half(::Type{BFloat16}) =    0x3f00
significand_mask(::Type{BFloat16}) = 0x007f

significand_bits(::Type{BFloat16}) = trailing_ones(significand_mask(BFloat16))
exponent_bits(::Type{BFloat16}) = sizeof(BFloat16)*8 - significand_bits(BFloat16) - 1
exponent_bias(::Type{BFloat16}) = Int(exponent_one(BFloat16) >> significand_bits(BFloat16))
exponent_max(::Type{BFloat16}) = Int(exponent_mask(BFloat16) >> significand_bits(BFloat16)) - exponent_bias(BFloat16)
exponent_raw_max(::Type{BFloat16}) = Int(exponent_mask(BFloat16) >> significand_bits(BFloat16))

include("conversions.jl")
include("functions.jl")

end # module

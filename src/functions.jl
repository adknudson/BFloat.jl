for t in (Int8, Int16, Int32, Int64, Int128, UInt8, UInt16, UInt32, UInt64, UInt128)
    @eval begin
        unsafe_trunc(::Type{$t}, x::BFloat16) = unsafe_trunc($t, Float32(x))
    end
end
trunc(::Type{T}, x::BFloat16) where {T<:Integer} = trunc(T, Float32(x))
floor(::Type{T}, x::BFloat16) where {T<:Integer} = floor(T, Float32(x))
ceil(::Type{T}, x::BFloat16) where {T<:Integer}  = ceil(T, Float32(x))
round(::Type{T}, x::BFloat16) where {T<:Integer} = round(T, Float32(x))

round(x::BFloat16, r::RoundingMode{:ToZero})  = BFloat16(round(Float32(x), r))
round(x::BFloat16, r::RoundingMode{:Down})    = BFloat16(round(Float32(x), r))
round(x::BFloat16, r::RoundingMode{:Up})      = BFloat16(round(Float32(x), r))
round(x::BFloat16, r::RoundingMode{:Nearest}) = BFloat16(round(Float32(x), r))

-(x::BFloat16) = reinterpret(BFloat16, reinterpret(uinttype(BFloat16), x) ⊻ sign_mask(BFloat16))

# TODO: Write native BF16 arithmetic functions
for op in (:+, :-, :*, :/, :\, :^)
    @eval ($op)(a::BFloat16, b::BFloat16) = BFloat16(($op)(Float32(a), Float32(b)))
end

function muladd(a::BFloat16, b::BFloat16, c::BFloat16)
    BFloat16(muladd(Float32(a), Float32(b), Float32(c)))
end

for func in (:div,:fld,:cld,:rem,:mod)
    @eval begin
        $func(a::BFloat16,b::BFloat16) = BFloat16($func(Float32(a),Float32(b)))
    end
end

function ==(x::BFloat16, y::BFloat16)
    ix = reinterpret(uinttype(BFloat16), x)
    iy = reinterpret(uinttype(BFloat16), y)
    if (ix|iy) & ~sign_mask(BFloat16) > NaNB16 # isnan(x) || isnan(y)
        return false
    end
    if (ix|iy) & ~sign_mask(BFloat16) == 0x0000
        return true
    end
    return ix == iy
end

for op in (:<, :<=, :isless)
    @eval ($op)(a::BFloat16, b::BFloat16) = ($op)(Float32(a), Float32(b))
end

for op in (:(==), :<, :<=)
    @eval begin
        ($op)(x::BFloat16, y::Union{Int128,UInt128,Int64,UInt64}) = ($op)(Float64(x), Float64(y))
        ($op)(x::Union{Int128,UInt128,Int64,UInt64}, y::BFloat16) = ($op)(Float64(x), Float64(y))

        ($op)(x::Union{BFloat16,Float32}, y::Union{Int32,UInt32}) = ($op)(Float64(x), Float64(y))
        ($op)(x::Union{Int32,UInt32}, y::Union{BFloat16,Float32}) = ($op)(Float64(x), Float64(y))

        ($op)(x::BFloat16, y::Union{Int16,UInt16}) = ($op)(Float32(x), Float32(y))
        ($op)(x::Union{Int16,UInt16}, y::BFloat16) = ($op)(Float32(x), Float32(y))
    end
end

abs(x::BFloat16) = reinterpret(BFloat16, reinterpret(uinttype(BFloat16), x) & ~sign_mask(BFloat16))

isnan(x::BFloat16) = reinterpret(uinttype(BFloat16), x) & ~sign_mask(BFloat16) > NaNB16
isfinite(x::BFloat16) = reinterpret(uinttype(BFloat16), x) & NaNB16 != NaNB16

precision(::Type{BFloat16}) = significand_bits(BFloat16) + 1

function nextfloat(f::BFloat16, d::Integer)
    F = typeof(f)
    fumax = reinterpret(UInt, F(Inf))
    U = typeof(fumax)

    isnan(f) && return f
    fi = reinterpret(Int, f)
    fneg = fi < 0
    fu = unsigned(fi & typemax(fi))

    dneg = d < 0
    da = Base.uabs(d)
    if da > typemax(U)
        fneg = dneg
        fu = fumax
    else
        du = da % U
        if fneg ⊻ dneg
            if du > fu
                fu = min(fumax, du - fu)
                fneg = !fneg
            else
                fu = fu - du
            end
        else
            if fumax - fu < du
                fu = fumax
            else
                fu = fu + du
            end
        end
    end
    if fneg
        fu |= sign_mask(F)
    end
    reinterpret(F, fu)
end
nextfloat(x::BFloat16) = nextfloat(x, 1)
prevfloat(x::BFloat16, d::Integer) = nextfloat(x, -d)
prevfloat(x::BFloat16) = nextfloat(x, -1)

function issubnormal(x::BFloat16)
    y = reinterpret(Unsigned, x)
    (y & exponent_mask(BFloat16) == 0) & (y & significand_mask(BFloat16) != 0)
end

typemin(::Type{BFloat16})  = bitcast(BFloat16, 0xff80)
typemax(::Type{BFloat16})  = InfB16
floatmin(::Type{BFloat16}) = bitcast(BFloat16, 0x0080)
floatmax(::Type{BFloat16}) = bitcast(BFloat16, 0x7f7f)
eps(::Type{BFloat16})      = bitcast(BFloat16, 0x3c00)

truncmask(x::BFloat16, mask) = reinterpret(BFloat16, mask & reinterpret(uinttype(BFloat16), x))
truncbits(x::BFloat16, nb) = truncmask(x, typemax(uinttype(BFloat16)) << nb)

bswap(x::BFloat16) = bswap_int(x)

iszero(x::BFloat16) = reinterpret(uinttype(BFloat16), x) & ~sign_mask(BFloat16) == 0x0000
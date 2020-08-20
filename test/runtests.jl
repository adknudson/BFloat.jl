using BFloat
using Test

b1 = BFloat16(3.14f0)
b2 = BFloat16(1.2f0)

@testset "BFloat.jl" begin
    # TODO: Figure out which tests define FP numbers
    @test b1 + b2 == BFloat16(Float32(b1) + Float32(b2))

    # Conversions

    # Promotions

    # Functions of
end

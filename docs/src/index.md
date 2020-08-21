# BFloat.jl

Doc's probably aren't necessary for this package, yet here we are. BFloat.jl is a so-far early implementation of Google's brain float 16 data type. Conversions are done via first converting to Float32 and then to any other type. This is because it is really easy to convert to and from Float32 from BFloat16 since the sign exponent bits are the same.

*Warning*

I wanted to have a way to directly set the bits for constructing a BFloat16 number, so it will interpret `UInt16` numbers as you wanting to set the bits explicitly. E.g. `BFloat16(0x4049)` sets the bits to `0100000001001001` which in turn is interpreted as `3.140625`. I may change this behavior later if I am convinced that this is bad practice.

```@docs
BFloat16(x::Float32)
```
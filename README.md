# BFloat

| **Documentation**                       | **Build Status**                    | **Package Details**                    |
|:---------------------------------------:|:-----------------------------------------:|:--------------------------------------:|
| [![][docs-stable-img]][docs-stable-url] | [![Build Status][travis-img]][travis-url] | [![Licence][license-img]][license-url] |
| [![][docs-latest-img]][docs-latest-url] |                                           | ![Release][release-img]                |

A Julia implementation of Google's Brain Float16 (BFloat16). A BFloat16, as the name suggests, uses 16 bits to represent a floating point number. It uses 8 bits for the exponenet like a single precision number, but only has 7 bits for the mantissa. In this way it is a truncated Float32, which makes it easy for back and forth conversion between the two. The tradeoff is that it has reduced precision (only about 2-3 decimal digits).

[docs-stable-img]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-stable-url]: https://adknudson.github.io/BFloat.jl/stable

[docs-latest-img]: https://img.shields.io/badge/docs-latest-blue.svg
[docs-latest-url]: https://adknudson.github.io/BFloat.jl/dev

[travis-img]: https://travis-ci.com/adknudson/BFloat.jl.svg?branch=master
[travis-url]: https://travis-ci.com/adknudson/BFloat.jl

[release-img]: https://img.shields.io/github/v/tag/adknudson/BFloat.jl?label=release&sort=semver

[license-img]: https://img.shields.io/github/license/adknudson/BFloat.jl
[license-url]: https://choosealicense.com/licenses/mit/

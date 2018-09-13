# SparseMatrixAssemblers

[![Build Status](https://travis-ci.org/ettersi/SparseMatrixAssemblers.jl.svg?branch=master)](https://travis-ci.org/ettersi/SparseMatrixAssemblers.jl)
[![Coverage Status](https://coveralls.io/repos/ettersi/SparseMatrixAssemblers.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/ettersi/SparseMatrixAssemblers.jl?branch=master)

`SparseMatrixAssembler` allows to create sparse matrices using the convenient block assignment syntax without the performance penalty incurred by using the same syntax on `SparseMatrixCSC` directly. Effectively, `SparseMatrixAssembler` is a wrapper around the `I,J,V` arguments of `sparse()`. 

## Example
```
julia> A = SparseMatrixAssembler();

julia> A[2,2] = π;

julia> SparseMatrixCSC(A,3,3)
3×3 SparseMatrixCSC{Float64,Int64} with 1 stored entry:
  [2, 2]  =  3.14159

julia> Matrix(A,3,3)
3×3 Array{Float64,2}:
 0.0  0.0      0.0
 0.0  3.14159  0.0
 0.0  0.0      0.0
```

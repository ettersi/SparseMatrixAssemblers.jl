module SparseMatrixAssemblers

using SparseArrays

export SparseMatrixAssembler


"""
    SparseMatrixAssembler{Tv,Ti<:Integer}

Convenience type for assembling sparse matrices.

# Examples
```
julia> A = SparseMatrixAssembler();

julia> A[2,2] = π;

julia> Matrix(A,3,3)
3×3 Array{Float64,2}:
 0.0  0.0      0.0
 0.0  3.14159  0.0
 0.0  0.0      0.0
```
"""
struct SparseMatrixAssembler{Tv,Ti<:Integer}
    i::Vector{Ti}
    j::Vector{Ti}
    v::Vector{Tv}
end

SparseMatrixAssembler() where {Tv} = SparseMatrixAssembler{Float64}()
SparseMatrixAssembler{Tv}() where {Tv} = SparseMatrixAssembler{Tv,Int}()
SparseMatrixAssembler{Tv,Ti}() where {Tv,Ti<:Integer} = SparseMatrixAssembler{Tv,Ti}(Vector{Ti}(),Vector{Ti}(),Vector{Tv}())

Base.convert(::Type{SparseMatrixAssembler{Tv,Ti}}, A::SparseMatrixAssembler) where {Tv,Ti<:Integer} =
    SparseMatrixAssembler(
        convert(Vector{Ti},A.i),
        convert(Vector{Ti},A.j),
        convert(Vector{Tv},A.v)
    )
Base.convert(::Type{SparseMatrixAssembler{Tv}}, A::SparseMatrixAssembler) where {Tv} = convert(SparseMatrixAssembler{Tv,Int},A)


# Overload repeat to handle scalars
repeat(v::AbstractArray; kwargs...) = Base.repeat(v; kwargs...)
repeat(v::Number; kwargs...) = Base.repeat([v]; kwargs...)

function Base.setindex!(A::SparseMatrixAssembler, v, i,j)
    @assert length(v) == length(i)*length(j)
    append!(A.i, repeat(i,outer=length(j)))
    append!(A.j, repeat(j,inner=length(i)))
    append!(A.v, v)
    return v
end

SparseArrays.sparse(A::SparseMatrixAssembler) = sparse(A.i,A.j,A.v)
SparseArrays.sparse(A::SparseMatrixAssembler, m::Integer,n::Integer, combine...) = sparse(A.i,A.j,A.v,m,n, combine...)
# The following can be ambiguous with `sparse(i,j,v,m,n)`, hence we need to explicitly write out both version as above.
#     SparseArrays.sparse(A::SparseMatrixAssembler, args...) = sparse(A.i,A.j,A.v, args...)


SparseArrays.SparseMatrixCSC(A::SparseMatrixAssembler, args...) = sparse(A, args...)
Base.Matrix(A::SparseMatrixAssembler, args...) = Matrix(SparseMatrixCSC(A, args...))

end # module

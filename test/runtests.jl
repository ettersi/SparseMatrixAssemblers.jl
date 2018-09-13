using SparseMatrixAssemblers
using SparseArrays
using Test

@testset "Constructors" begin
    # Mainly testing that expressions compile
    @test typeof(SparseMatrixAssembler()) == SparseMatrixAssembler{Float64,Int}
    @test typeof(SparseMatrixAssembler{Int32}()) == SparseMatrixAssembler{Int32,Int}
    @test typeof(SparseMatrixAssembler{Int32,Int32}()) == SparseMatrixAssembler{Int32,Int32}
end

@testset "Conversion" begin
    # Mainly testing that expressions compile
    @test typeof(convert(SparseMatrixAssembler, SparseMatrixAssembler())) == SparseMatrixAssembler{Float64,Int}
    @test typeof(convert(SparseMatrixAssembler{Int32}, SparseMatrixAssembler())) == SparseMatrixAssembler{Int32,Int}
    @test typeof(convert(SparseMatrixAssembler{Int32,Int32}, SparseMatrixAssembler())) == SparseMatrixAssembler{Int32,Int32}
end

@testset "Assignment" begin
    @testset "Scalar" begin
        A = SparseMatrixAssembler{Int}()
        A[1,2] = 1
        @test sparse(A) == [0 1]
    end

    @testset "Col vector" begin
        A = SparseMatrixAssembler{Int}()
        A[1:2,2] = [1,2]
        @test sparse(A) == [0 1; 0 2]
    end

    @testset "Row vector" begin
        A = SparseMatrixAssembler{Int}()
        A[2,1:2] = [1,2]
        @test sparse(A) == [0 0; 1 2]
    end

    @testset "Matrix" begin
        A = SparseMatrixAssembler{Int}()
        A[2:3,1:2] = [1 2; 3 4]
        @test sparse(A) == [0 0; 1 2; 3 4]
    end
end

@testset "Conversion to other types" begin
    # Mainly testing that expressions compile
    i = [1,1]
    j = [1,1]
    v = [1,2]
    @test sparse(SparseMatrixAssembler(i,j,v)) == sparse(i,j,v)
    @test sparse(SparseMatrixAssembler(i,j,v),2,2) == sparse(i,j,v,2,2)
    @test sparse(SparseMatrixAssembler(i,j,v),2,2,*) == sparse(i,j,v,2,2, *)

    @test SparseMatrixCSC(SparseMatrixAssembler(i,j,v)) == sparse(i,j,v)
    @test SparseMatrixCSC(SparseMatrixAssembler(i,j,v),2,2) == sparse(i,j,v,2,2)
    @test SparseMatrixCSC(SparseMatrixAssembler(i,j,v),2,2,*) == sparse(i,j,v,2,2, *)

    @test Matrix(SparseMatrixAssembler(i,j,v)) == sparse(i,j,v)
    @test Matrix(SparseMatrixAssembler(i,j,v),2,2) == sparse(i,j,v,2,2)
    @test Matrix(SparseMatrixAssembler(i,j,v),2,2,*) == sparse(i,j,v,2,2, *)
end

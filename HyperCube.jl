#using Parameters: @with_kw

# I use an n-dimensional HyperCube as a "template" for edge 
# & vertice enumeration of boxes.
# A suitable HyperCube is instantiated and referenced by creation 
# of the root object with `init_box_tree()`.

@with_kw struct HyperCube{N}
    vertices :: Vector{NTuple{N,Bool}} = [];
    edges :: Vector{ NTuple{2, Int} } = [];
    #faces :: Vector{ NTuple{ 3, Int} } = [];
end

function dist( v1 :: NTuple{N,Bool}, v2 :: NTuple{N, Bool} ) where N
    sum( v1 .!= v2 )
end

function lift( hc :: HyperCube{N} ) where N 

    num_old_vertices = 2^N;
    new_vertices_0 = [ (v..., false) for v in hc.vertices];
    new_vertices_1 = [ (v..., true) for v in hc.vertices];
    new_vertices = [new_vertices_0; new_vertices_1];
    
    @assert length( new_vertices_0 ) == num_old_vertices;
    
    lifted_edges = [
        hc.edges;
        [e .+ num_old_vertices for e in hc.edges]
    ]

    num_additional_edges = 2^(N)*(N+1) - length( lifted_edges );
    additional_edges = Vector{ NTuple{2, Int} }( 
        undef,
        num_additional_edges
    );

    e_index = 1;
    for (v1_index, v1) ∈ enumerate(new_vertices_0)
        for (v2_index, v2) ∈ enumerate(new_vertices_1)
            if dist(v1, v2) == 1
                additional_edges[e_index] = ( v1_index, v2_index + num_old_vertices );
                e_index += 1;
            end
        end
    end

    return HyperCube{N+1}(;
        vertices = new_vertices,
        edges = [ lifted_edges; additional_edges ]
    )
end

function HyperCube{N}() where N
    if N < 1
        error("HyperCube only implemented for N>=1.")
    end

    hc = HyperCube{1}(;
        vertices = [ (false,), (true,) ],
        edges = [ (1,2), ],
    )
    for n = 2 : N 
        hc = lift(hc)
    end

    #=
    for e₁ ∈ hc.edges 
        v₁, v₂ = e₁ 
        for e₂ ∈ hc.edges 
            if e₁ != e₂ && v₂ ∈ e₂ 
                v₃ = e₂[1] == v₂ ? e₂[2] : e₂[1]
                push!( hc.faces, (v₁, v₂, v₃) )
            end
        end
    end
    =#
    return hc 
end

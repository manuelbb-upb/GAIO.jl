using Pkg;
Pkg.activate(@__DIR__)
using CairoMakie, AbstractPlotting;
using GeometryBasics
using FromFile
#%%
Pkg.activate(joinpath(@__DIR__, "..") )
@from "../src/GAIO.jl" using GAIO 
#%%

lb = fill(-2.0,2)
ub = fill(2.0,2)

f( x :: Vector{ R } where R<:Real ) = [
    sum( ( x .- 1 ).^2 );
    sum( ( x .+ 1 ).^2 )
]

#%%
root = init_box_tree(fill(-2.0, 2), fill(2.0,2));

box_collection = [ root, ];
function progress!( box_collection, f :: F where F<:Function )    
    
    # Subdivision Step
    new_collection = BoxNode[];
    for box ∈ box_collection 
        subdivide!(box; method=:cycle)
        push!( new_collection, children(box)... )
    end

    # Selection Step 

    ## 1) generate test sites and evaluate 
    for box ∈ new_collection
        generate_sites!( box; method = :edges_center, num_edge_points = 3 )
        eval!( box, f )
    end

    ## 2) Discrete Hit Test
    
    ## 2a) Find all currently nondominated points 
    all_points = vcat([ results(box) for box ∈ new_collection ]...)
    nondom_points = Vector{Float64}[];
    for X ∈ all_points 
        X_nondominated = true 
        for Y ∈ all_points
            if Y ≺ X 
                X_nondominated = false
                break;
            end
        end
        if X_nondominated
            push!(nondom_points, X)
        end
    end

    ## 2b) Select Boxes containing a Nondom Point
    good_box_indices = Int[];
    for (i,boxᵢ) ∈ enumerate(new_collection)
        for Y in results(boxᵢ)
            if Y ∈ nondom_points
                push!(good_box_indices, i)
                break;
            end
        end
    end
    
    # TODO: Make more robust by reintroducing boxes
    
    empty!( box_collection );
    push!( box_collection, new_collection[good_box_indices]... );    
end

#%%
for i = 1 : 15
    progress!( box_collection, f )
end

#%%
# Plotting … 
# should work in 3D and 2D

function box2rect( box )
    rect = Rect( Vec( GAIO.lb( box )... ), Vec( GAIO.width(box)... ) );
    rect_v = decompose( Point{ GAIO.n_vars( box), Float64 }, rect )
    rect_f = decompose( TriangleFace{Int}, rect );
    return rect_v, rect_f
end

scene, layout = layoutscene();
ax = layout[1,1] = Axis(scene);
for box ∈ box_collection
    mesh!(ax, box2rect(box)...; color=:blue, strokecolor=:lightblue, strokewidth = 5.0, shading=false)
end
ax.aspect = AxisAspect(1)
scene

#
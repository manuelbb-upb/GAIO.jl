using Pkg; Pkg.activate(@__DIR__);
include("BoxTrees.jl")
using .BoxTrees 
bt = BoxTrees

AbstractPlotting.inline!(true)

f( x :: Vector{ R } where R<:Real ) = [
    1 - 1.2 * x[1]^2 + x[2]/5;
    5 * 0.2 * x[1]
]

#%%
root = bt.init_box_tree(fill(-2.0, 2), fill(2.0,2) );
box_collection = [ root, ];

function progress!( box_collection, f :: F where F<:Function )    
    
    # Subdivision Step
    new_collection = bt.Box[];
    for box ∈ box_collection 
        bt.subdivide!(box; method=:cycle)
        push!( new_collection, bt.children(box)... )
    end

    # Selection Step 

    ## 1) generate test sites and evaluate 
    for box ∈ new_collection
        bt.generate_sites!( box; method = :edges_center, num_edge_points = 3 )
        bt.eval!( box, f )
    end

    ## 2) Discrete Hit Test
    good_box_indices = Int[];
    for (i,boxᵢ) ∈ enumerate(new_collection)
        for boxⱼ ∈ new_collection
            intersection_empty = true 
            for fₓ ∈ bt.results( boxⱼ )
                if bt.contains( boxᵢ, fₓ )
                    intersection_empty = false;
                    break;
                end
            end
            # box was hit …
            if !intersection_empty
                push!(good_box_indices, i);
                break;
            end
        end
    end
    
    # TODO: Make more robust by reintroducing boxes

    empty!( box_collection );
    push!( box_collection, new_collection[good_box_indices]... );    
end

#%%
for i = 1 : 10
    progress!( box_collection, f )
end

#%%
# Plotting … 
# should work in 3D and 2D
using Makie;
using GeometryBasics;

function box2rect( box )
    rect = Rect( Vec(bt.lb( box )... ), Vec( bt.width(box)... ) );
    rect_v = decompose( Point{ bt.n_vars( box), Float64 }, rect )
    rect_f = decompose( TriangleFace{Int}, rect );
    return rect_v, rect_f
end

scene, layout = Makie.layoutscene();
ax = layout[1,1] = Axis(scene);
for box ∈ box_collection
    Makie.mesh!(ax, box2rect(box)...; color=:blue, strokecolor=:lightblue, strokewidth = 5.0, shading=false)
end
ax.aspect = AxisAspect(1)
scene

#%%

@doc """
    ≺( X, Y )
    
Return `true` if vector `X` dominates `Y`, i.e. if all components
of `X` not bigger than those of `Y` and if there is at least one
component of `X` that is strictly smaller than the corresponding 
`Y` component.
"""
function ≺( X :: Vector{R} where R<:Real, Y :: Vector{R} where R<:Real )
	any_smaller = false
    if length(X) != length(Y) 
        error("Cannot compare vectors of unequal lengths.")
    end
    for (i, xᵢ) ∈ enumerate(X)
        yᵢ = Y[i]
        if yᵢ < xᵢ
            return false
        end
        if !any_smaller
            any_smaller = xᵢ < yᵢ;
        end
    end
    return any_smaller
end
#=
@doc """ 
    ≺( box1, box2 )

Return `true` if all result vectors (indexed by the respective fields 
`db_indices`) of `box1` dominate all result vectors in `box2`, 
else return `false`.
"""
function ≺( box1 :: Box, box2 :: Box )
    for X ∈ results( box1; include_nothing = false )
        for Y ∈ results( box2; include_nothing = false )
            if !≺(X,Y)
                return false 
            end
        end
    end
    return true		
end


@doc """ 
    ≺( X, box2 )

Return `true` if `X` dominates all result vectors of `box2`.
"""
function ≺( X :: Vector{R} where R<:Real, box2 :: Box )
    for Y ∈ results( box2; include_nothing = false )
        if !≺(X,Y)
            return false 
        end
    end
    return true		
end

"Return `true` if there is no result vector of `box2` that dominates `X`."
function point_not_dominated_by_box(  X :: Vector{R} where R<:Real, box2 :: Box )
    for Y ∈ results( box2; include_nothing = false )
        if ≺(Y, X)
            return false 
        end
    end
    return true	
end
=#
struct Ray
    # Should be 3D but this is not checked.
    origin::Vector{Real}
    direction::Vector{Real}
end

function point_at_parameter(ray::Ray, t::Real)
    return ray.origin + t * ray.direction
end

function to_ppm(n)::Int
    return trunc(Int, 255.99 * n)
end

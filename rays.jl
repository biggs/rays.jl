using LinearAlgebra


struct Ray
    # Should be 3D but this is not checked.
    origin::Vector{Real}
    direction::Vector{Real}
end

function point_at_parameter(ray::Ray, t::Real)
    return ray.origin + t * ray.direction
end

function to_ppm(n)::Int
    return trunc(Int, 255.99 * .√(n))
end



struct Camera
    lower_left_corner::Vector{Real}
    horizontal::Vector{Real}
    vertical::Vector{Real}
    origin::Vector{Real}
end

function get_ray(cam::Camera, u::Real, v::Real)
    ray_direct = cam.lower_left_corner + u*cam.horizontal + v*cam.vertical
    return Ray(cam.origin, ray_direct)
end


" Get a random value drawn from the unit sphere."
function random_in_sphere()
    p = [1, 1, 1]
    while norm(p) >= 1
        p = 2*[rand(), rand(), rand()] - [1, 1, 1]
    end
    return p
end

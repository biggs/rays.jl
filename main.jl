using LinearAlgebra

struct Ray
    # Should be 3D but this is not checked for performance.
    origin::Vector{Real}
    direction::Vector{Real}
end

function color(ray::Ray)
    t = hit_sphere([0, 0, -1], 0.5, ray)
    if t > 0
        N = normalize(point_at_parameter(ray, t) - [0, 0, -1])
        return 0.5 * (N .+ 1)
    end

    unit_direction = normalize(ray.direction)
    t = 0.5 * (unit_direction[2] + 1)
    return (1-t)*[1, 1, 1] + t*[0.5, 0.7, 1]
end

function to_ppm(n)::Int
    return trunc(Int, 255.99 * n)
end

function point_at_parameter(ray::Ray, t::Real)
    return ray.origin + t * ray.direction
end

function hit_sphere(center::Vector, radius::Real, r::Ray)
    oc = r.origin - center
    direct = r.direction
    a = norm(direct) ^ 2
    b = 2 * dot(oc, direct)
    c = norm(oc)^2 - norm(radius)^2
    discrim = b^2 - 4a*c
    if discrim < 0
        return -1
    else
        return -(b + √(discrim)) / (2a)
    end
end


function run()
    nx = 200
    ny = 100
    print("P3\n$nx $ny\n255\n")

    lower_left = [-2, -1, -1]
    horizontal = [4, 0, 0]
    vertical   = [0, 2, 0]
    origin     = [0, 0, 0]

    for j = ny-1:-1:0
        for i = 0:nx-1
            u = i / nx
            v = j / ny

            r = Ray(origin, lower_left + u*horizontal + v*vertical)
            rgb = color(r)

            irgb = to_ppm.(rgb)
            print("$(irgb[1]) $(irgb[2]) $(irgb[3])\n")
        end
    end
end

run()

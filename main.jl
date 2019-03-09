using LinearAlgebra
include("utils.jl")
include("things.jl")
include("hit.jl")
include("scatter.jl")

const MAXFLOAT = 100000



function color(ray::Ray, world::Hittables)
    hit_record = hit(world, ray, 0.001, MAXFLOAT)
    if !isnothing(hit_record)
        # Hit something -> bounce off recursively.
        scattered, attenuation = scatter(ray, hit_record)
        return attenuation .* color(scattered, world)
    else
        # Reach the sky.
        unit_direction = normalize(ray.direction)
        t = 0.5 * (unit_direction[2] + 1)
        return (1-t)*[1, 1, 1] + t*[0.5, 0.7, 1]
    end
end


function run()
    nx = 200
    ny = 100
    ns = 100   # No. samples for anti-aliasing.
    print("P3\n$nx $ny\n255\n")

    cam = Camera([-2, -1, -1], [4, 0, 0], [0, 2, 0], [0, 0, 0])

    small = Sphere([0, 0, -1], 0.5, Lambertian([0.8, 0.3, 0.3]))
    large = Sphere([0, -100.5, -1], 100, Lambertian([0.8, 0.8, 0.0]))
    world = Hittables([small, large])

    for j = ny-1:-1:0
        for i = 0:nx-1
            rgb = [0, 0, 0]
            for _ in 1:ns
                u = (i + rand()) / nx
                v = (j + rand()) / ny

                r = get_ray(cam, u, v)
                rgb += color(r, world) / ns
            end

            irgb = to_ppm.(rgb)
            print("$(irgb[1]) $(irgb[2]) $(irgb[3])\n")
        end
    end
end



function point_at_parameter(ray::Ray, t::Real)
    return ray.origin + t * ray.direction
end


function get_ray(cam::Camera, u::Real, v::Real)
    ray_direct = cam.lower_left_corner + u*cam.horizontal + v*cam.vertical
    return Ray(cam.origin, ray_direct)
end

run()

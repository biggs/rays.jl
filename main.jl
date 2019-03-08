using LinearAlgebra
include("rays.jl")
include("hittable.jl")

const MAXFLOAT = 100000


function color(ray::Ray, world::Hittables)
    hit_record = hit(world, ray, 0, MAXFLOAT)
    if !isnothing(hit_record)
        # Hit something.
        N = hit_record.normal
        return 0.5(N .+ 1)
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
    print("P3\n$nx $ny\n255\n")

    lower_left = [-2, -1, -1]
    horizontal = [4, 0, 0]
    vertical   = [0, 2, 0]
    origin     = [0, 0, 0]

    small = Sphere([0, 0, -1], 0.5)
    large = Sphere([0, -100.5, -1], 100)
    world = Hittables([small, large])

    for j = ny-1:-1:0
        for i = 0:nx-1
            u = i / nx
            v = j / ny

            r = Ray(origin, lower_left + u*horizontal + v*vertical)
            rgb = color(r, world)

            irgb = to_ppm.(rgb)
            print("$(irgb[1]) $(irgb[2]) $(irgb[3])\n")
        end
    end
end

run()

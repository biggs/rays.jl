using LinearAlgebra
include("utils.jl")
include("things.jl")
include("hit.jl")
include("scatter.jl")
include("camera.jl")

const MAXDIST = 100000



function color(ray::Ray, world::Hittables, depth)
    hit_record = hit(world, ray, 0.001, MAXDIST)
    if !isnothing(hit_record)
        # Hit something -> scatter.
        s = scatter(ray, hit_record)
        if !isnothing(s) && depth < 50
            # If scattered and not absorbed.
            scattered, attenuation = s
            return attenuation .* color(scattered, world, depth + 1)
        else
            # If reach max recursion depth or scattering fails.
            return [0, 0, 0]
        end
    else
        # Reach the sky.
        d = normalize(ray.direction)
        t = 0.5(d[2] + 1)
        return (1-t)*[1, 1, 1] + t*[0.5, 0.7, 1]
    end
end


function run()
    nx = 500
    ny = 250
    ns = 100   # No. samples for anti-aliasing.
    print("P3\n$nx $ny\n255\n")

    cam = Camera([13., 2, 3], [0., 0, 0], [0., 1, 0], 20, nx/ny, 0.1, norm([13, 2, 3]))
    world = random_scene()

    for j = ny-1:-1:0
        for i = 0:nx-1
            rgb = [0, 0, 0]
            for _ in 1:ns
                u = (i + rand()) / nx
                v = (j + rand()) / ny

                r = get_ray(cam, u, v)
                rgb += color(r, world, 0) / ns
            end

            irgb = to_ppm.(rgb)
            print("$(irgb[1]) $(irgb[2]) $(irgb[3])\n")
        end
    end
end


function random_scene()
    large = Sphere([0, -1000, 0], 1000, Lambertian([0.5, 0.5, 0.5]))
    back = Sphere([-4, 1, 0], 1.0, Lambertian([0.4, 0.2, 0.1]))
    middle = Sphere([0, 1, 0], 1.0, Dielectric(1.5))
    front = Sphere([4, 1, 0], 1.0, Metal([0.7, 0.6, 0.5], 0.0))
    w1 = [large, back, middle, front]
    w2 = [random_sphere(i, j) for i in -11:11 for j in -11:11]
    w = filter(!isnothing, [w1; w2])
    return Hittables(w)
end

function random_sphere(i, j)
    center = [i + 0.9rand(), 0.2, j + 0.9rand()]
    if norm(center .- [4, 0.2, 0]) < 0.9
        return nothing
    end

    material_gen = rand()
    if material_gen < 0.8
        return random_lambertian(center)
    elseif material_gen < 0.96
        return random_metal(center)
    else
        return random_dielectric(center)
    end
end

function random_lambertian(center) Sphere(center, 0.2, Lambertian(rand_v3() .* rand_v3())) end
function random_metal(center) Sphere(center, 0.2, Metal(0.5(rand_v3() .+ 1), 0.5rand())) end
function random_dielectric(center) Sphere(center, 0.2, Dielectric(1.5)) end

function rand_v3() return [rand(), rand(), rand()] end

function point_at_parameter(ray::Ray, t::Real)
    return ray.origin + t * ray.direction
end


run()

using LinearAlgebra

struct HitRecord
    t::Real
    p::Vector{Real}
    normal::Vector{Real}
end


" Type of objects that can interact with ray."
abstract type Hittable end

struct Sphere <: Hittable
    center::Vector{Real}
    radius::Real
end

" List of hittable objects."
const Hittables = Vector{Hittable}


function hit(hittables::Hittables, ray::Ray, tmin::Real, tmax::Real)::Union{HitRecord, Nothing}
    hitrec = nothing
    closest_so_far = tmax
    for obj in hittables
        hitrec_obj = hit(obj, ray, tmin, closest_so_far)
        if !isnothing(hitrec_obj)
            closest_so_far = hitrec_obj.t
            hitrec = hitrec_obj
        end
    end

    return hitrec
end


"""
  Maybe return a HitRecord, otherwise Nothing.
  tmin and tmax are minimum and maximum distances.
"""
function hit(sphere::Sphere, ray::Ray, tmin::Real, tmax::Real)::Union{HitRecord, Nothing}
    oc = ray.origin - sphere.center
    direct = ray.direction
    a = norm(direct) ^ 2
    b = 2 * dot(oc, direct)
    c = norm(oc)^2 - norm(sphere.radius)^2
    discrim = b^2 - 4a*c

    if discrim < 0
        return nothing
    end

    t_minus = (-b - √(discrim)) / 2a
    t_plus = (-b + √(discrim)) / 2a

    if t_minus < tmax && t_minus > tmin
        t = t_minus
        p = point_at_parameter(ray, t)
        n = (p - sphere.center) / sphere.radius
        return HitRecord(t, p, n)

    elseif t_plus < tmax && t_plus > tmin
        t = t_plus
        p = point_at_parameter(ray, t)
        n = (p - sphere.center) / sphere.radius
        return HitRecord(t, p, n)

    else
        return nothing
    end
end

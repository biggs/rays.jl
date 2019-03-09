using LinearAlgebra

" Hit for a list of hittable objects."
function hit(hittables::Hittables, ray::Ray, tmin::Real, tmax::Real)::MaybeHitRec
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
function hit(sphere::Sphere, ray::Ray, tmin::Real, tmax::Real)::MaybeHitRec
    oc = ray.origin - sphere.center
    direct = ray.direction
    a = norm(direct) ^ 2
    b = 2 * dot(oc, direct)
    c = norm(oc)^2 - norm(sphere.radius)^2
    discrim = b^2 - 4a*c

    if discrim > 0
        t_minus = (-b - √(discrim)) / 2a
        t_plus = (-b + √(discrim)) / 2a

        if t_minus < tmax && t_minus > tmin
            t = t_minus
            p = point_at_parameter(ray, t)
            n = (p - sphere.center) / sphere.radius
            return HitRecord(t, p, n, sphere)

        elseif t_plus < tmax && t_plus > tmin
            t = t_plus
            p = point_at_parameter(ray, t)
            n = (p - sphere.center) / sphere.radius
            return HitRecord(t, p, n, sphere)
        end
    else
        return nothing
    end
end

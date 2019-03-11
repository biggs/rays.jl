using LinearAlgebra


function scatter(ray::Ray, rec::HitRecord{Lambertian})
    attenuation = rec.material.albedo
    direct = rec.normal + random_in_sphere()
    scattered = Ray(rec.p, direct)
    return (scattered, attenuation)
end

function scatter(ray::Ray, rec::HitRecord{Metal})
    attenuation = rec.material.albedo
    reflected = reflect(normalize(ray.direction), rec.normal)
    diffusion = rec.material.fuzz * random_in_sphere()
    scattered = Ray(rec.p, reflected + diffusion)
    if dot(scattered.direction, rec.normal) > 0
        return (scattered, attenuation)
    else
        return nothing
    end
end


function scatter(ray::Ray, rec::HitRecord{Dielectric})
    attenuation = [1, 1, 1]
    dt = dot(normalize(ray.direction), rec.normal)

    # Get outward-pointing versions.
    if dt > 0
        outward_norm = -rec.normal
        ratio = rec.material.idx
        cosine = √(abs(1 - ratio^2 * (1 - dt^2)))
    else
        outward_norm = rec.normal
        ratio = 1 / rec.material.idx
        cosine = -dt
    end

    refracted = refract(ray.direction, outward_norm, ratio)
    reflect_prob = schlick(cosine, rec.material.idx)

    # Reflect or refract.
    if isnothing(refracted) || rand() < reflect_prob
        reflected = reflect(ray.direction, rec.normal)
        scattered = Ray(rec.p, reflected)
    else
        scattered = Ray(rec.p, refracted)
    end

    return (scattered, attenuation)
end


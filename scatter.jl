function scatter(ray::Ray, rec::HitRecord{Lambertian})
    direct = rec.normal + random_in_sphere()
    scattered = Ray(rec.p, direct)
    attenuation = rec.material.albedo
    return (scattered, attenuation)
end

function scatter(ray::Ray, rec::HitRecord{Metal})
    reflected = reflect(normalize(ray.direction), rec.normal)
    diffusion = rec.material.fuzz * random_in_sphere()
    scattered = Ray(rec.p, reflected + diffusion)
    attenuation = rec.material.albedo
    if dot(scattered.direction, rec.normal) > 0
        return (scattered, attenuation)
    else
        return nothing
    end
end

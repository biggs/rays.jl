function scatter(ray::Ray, rec::HitRecord)
    direct = rec.normal + random_in_sphere()
    scattered = Ray(rec.p, direct)
    attenuation = rec.object.material.albedo
    return (scattered, attenuation)
end

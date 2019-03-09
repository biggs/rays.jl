" Material that objects can be made of."
abstract type Material end

" Type of things that can interact with rays."
abstract type Hittable end

" Sphere object type."
struct Sphere <: Hittable
    center::Vector{Real}
    radius::Real
    material::Material
end

" List of hittable objects."
const Hittables = Vector{Hittable}


" Basically just a coloured material."
struct Lambertian <: Material
    albedo::Vector{Real}
end



" Record of ray hitting an object."
struct HitRecord
    t::Real
    p::Vector{Real}
    normal::Vector{Real}
    object::Hittable
end

" Maybe a Hit Record."
const MaybeHitRec = Union{HitRecord, Nothing}


" Ray that goes through some point in a direction."
struct Ray
    # Should be 3D but this is not checked.
    origin::Vector{Real}
    direction::Vector{Real}
end

" Camera from which rays originate."
struct Camera
    lower_left_corner::Vector{Real}
    horizontal::Vector{Real}
    vertical::Vector{Real}
    origin::Vector{Real}
end

using LinearAlgebra

"""
Camera from which rays originate, with custom constructor.
"""
struct Camera
    llc::Vector{Real}   # Lower left corner.
    horizontal::Vector{Real}
    vertical::Vector{Real}
    origin::Vector{Real}
    u::Vector{Real}
    v::Vector{Real}
    w::Vector{Real}
    lens_radius::Real

    function Camera(origin::Vector{Float64},
                    lookat::Vector{Float64},
                    vup::Vector{Float64},
                    vfov::Real,
                    aspect::Real,
                    aperture::Real,
                    focus_dist::Real)

        radius = aperture / 2
        θ = vfov * π / 180
        half_height = tan(θ / 2)
        half_width = aspect * half_height

        w = normalize(origin - lookat)
        u = normalize(cross(vup, w))
        v = cross(w, u)
        x = v * half_height + u * half_width + w
        llc = origin - focus_dist * x

        horiz = 2 * focus_dist * half_width * u
        vert = 2 * focus_dist * half_height * v

        new(llc, horiz, vert, origin, u, v, w, radius)
    end
end


function get_ray(c::Camera, s::Real, t::Real)
    rd = c.lens_radius * random_in_disk()
    offset = c.u * rd[1] + c.v * rd[2]
    start = c.origin + offset
    d = c.llc + s * c.horizontal + t * c.vertical .- start
    return Ray(start, d)
end

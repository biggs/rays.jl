using LinearAlgebra


" Convert a value [0, 1) to a PPM value."
function to_ppm(n)::Int
    return trunc(Int, 255.99 * √(n))   # √ for gamma correction.
end

" Get a random value drawn from the unit sphere."
function random_in_sphere()
    p = [1, 1, 1]
    while norm(p) >= 1
        p = 2 * [rand(), rand(), rand()] - [1, 1, 1]
    end
    return p
end

" Get a random value drawn from unit disk."
function random_in_disk()
    p = [1, 1]
    while norm(p) >= 1
        p = 2 * [rand(), rand()] - [1, 1]
    end
    return p
end

" Reflect vector v using normal n."
function reflect(v, n)
    return v - 2n * dot(v, n)
end

"""
Takes in vector, v, and normal, n, and refracts (if possible)
with ratio = ``\\frac{n_i}{n_t}``
"""
function refract(v, n, ratio)
    uv = normalize(v)
    dt = dot(uv, n)
    Δ = 1 - (1 - dt^2) * ratio^2   # discriminant.
    if Δ > 0
        return ratio * (uv - n * dt) - n * √Δ
    else
        return nothing
    end
end

"""
Approximation to variable reflectivity of glass.
Takes cosine of angle and reflective index, r.
"""
function schlick(cosine, r)
    r0 = ((1 - r) / (1 + r))^2
    return r0 + (1 - r0) * (1 - cosine)^5
end

using LinearAlgebra


" Convert a value [0, 1) to a PPM value."
function to_ppm(n)::Int
    return trunc(Int, 255.99 * √(n))   # √ for gamma correction.
end

" Get a random value drawn from the unit sphere."
function random_in_sphere()
    p = [1, 1, 1]
    while norm(p) >= 1
        p = 2*[rand(), rand(), rand()] - [1, 1, 1]
    end
    return p
end

" Reflect vector v using normal n."
function reflect(v, n)
    return v - 2n * dot(v, n)
end

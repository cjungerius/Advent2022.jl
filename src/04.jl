module Day04

function sectionoverlaps(io)

    overlaps = 0
    fulloverlaps = 0

    for line in eachline(io)
        m = split(line, [',', '-'])
        a = parse(Int, m[1]):parse(Int, m[2])
        b = parse(Int, m[3]):parse(Int, m[4])

        i = a ∩ b

        overlaps += (length(i) > 0)
        fulloverlaps += (length(i) == length(a) || length(i) == length(b))
    end

    fulloverlaps, overlaps
end

function solutions(io::String=joinpath(@__DIR__, "..", "data", "04.txt"))
    ispath(io) || (io = IOBuffer(io))
    partone, parttwo = sectionoverlaps(io)
end

end

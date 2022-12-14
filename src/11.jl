module Day11

mutable struct Monkey
    items::Vector{Int}
    opkey::String
    oparg::Int
    modtest::Int
    truemonkey::Int
    falsemonkey::Int
    businesscount::Int
end

function Monkey(input)::Monkey
    nummatch = r"([0-9]+)"
    opmatch = r"(\*|\+)"

    items = [parse(Int, x[1]) for x in eachmatch(nummatch, input[2])]
    op = match(opmatch, input[3])[1]
    opargmatch = match(nummatch, input[3])
    isnothing(opargmatch) ? oparg = 0 : oparg = parse(Int, opargmatch[1])
    modtest = parse(Int, match(nummatch, input[4])[1])
    truemonkey = parse(Int, match(nummatch, input[5])[1]) + 1
    falsemonkey = parse(Int, match(nummatch, input[6])[1]) + 1

    Monkey(items, op, oparg, modtest, truemonkey, falsemonkey, 0)
end

function makemonkeys(io)
    monkeys = Monkey[]
    input = String[]
    for line in eachline(io)


        if length(line) > 0
            push!(input, line)
        else
            push!(monkeys, Monkey(input))
            input = String[]
        end
    end
    push!(monkeys, Monkey(input))

    monkeys
end

function monkeybusiness(io, n, worry=false)

    monkeys = makemonkeys(io)
    opdict = Dict{String,Function}(["*", "+"] .=> [*, +])

    # item % lowest common multiple behaves the same for all tests as the original number, so:
    worrymod = lcm([m.modtest for m in monkeys]...)

    for i in 1:n
        for m in monkeys
            while !isempty(m.items)
                item = popfirst!(m.items)
                item = m.oparg == 0 ? opdict[m.opkey](item, item) : opdict[m.opkey](item, m.oparg)
                worry ? item %= worrymod : item ÷= 3
                target = mod(item, m.modtest) == 0 ? m.truemonkey : m.falsemonkey
                push!(monkeys[target].items, item)
                m.businesscount += 1
            end
        end
    end

    business = [m.businesscount for m in monkeys]
    sort!(business, rev=true)
    business[1] * business[2]
end

function solutions(io::String=joinpath(@__DIR__, "..", "data", "11.txt"))

    partone = ispath(io) ? monkeybusiness(io, 20) : monkeybusiness(IOBuffer(io), 20)
    parttwo = ispath(io) ? monkeybusiness(io, 1000, true) : monkeybusiness(IOBuffer(io), 1000, true)
    
    partone, parttwo
end

end

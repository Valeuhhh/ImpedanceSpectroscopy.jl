
abstract type AbstractElem end

j = 1.0im

#=
	s(series::AbstractElem)

Adds elements in series

     =#

function s(series::AbstractElem)

	z = 0
    for elem in series
        z += elem[1]
	end
    return z
end



#= Defines an inductor

	Z = L × j2πf

     =#

mutable struct L <: AbstractElem
	p::Float64
	f::Float64
end

#= Defines a resistor

        Z = R

    =#

mutable struct R <: AbstractElem
	p::Float64
	f::Float64
end

#= Defines a capacitor

	Z = 1 / (C×j2πf)

     =#

mutable struct C <: AbstractElem
	p::Float64
	f::Float64
end

#= Defines a constant phase element

	Z = 1 / (Q×(j2πf)^α)

    =#

mutable struct CPE <: AbstractElem
	p::Vector{Float64}
	f::Float64
end

#=
	calcOmega(elem::AbstractElem)

Calculate the pulsation of a given element (::AbstractElem) at the frequency associated

 =#
begin
	calcOmega(elem::L) = elem.f*2*pi
	calcOmega(elem::R) = elem.f*2*pi
	calcOmega(elem::C) = elem.f*2*pi
	calcOmega(elem::CPE) = elem.f*2*pi
end


#=
	calcImp(elem::AbstractElem)

Calculate the impedance of a given element (::AbstractElem) at the frequency associated

 =#
begin
	calcImp(elem::L) = elem.p[1]*1j*calcOmega(elem)
	calcImp(elem::R) = elem.p[1]*length(elem.f)
	calcImp(elem::C) = 1/(elem.p[1]*1j*calcOmega(elem))
	calcImp(elem::CPE) = 1.0/(elem.p[1]*(j*calcOmega(elem))^elem.p[2])
end


#=
	p(parallel::AbstractElem)

Adds elements in parallel

 =#

	function p(parallel)

	    z = 0
		if typeof(parallel[1]) == L || typeof(parallel[1]) == R || typeof(parallel[1]) == C || typeof(parallel[1]) == CPE

		    for elem in parallel
		        z += 1/calcImp(elem)
			end
		else
			for elem in parallel
		        z += 1/elem
			end
		end
	    return 1/z
	end

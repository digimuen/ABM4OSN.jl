# ABM4OSN

*run large-scale agent-based simulations of online social networks*  

To install ABM4OSN, execute:  

`julia>Pkg.add("https://github.com/digimuen/ABM4OSN.jl")`

You can run a simple default simulation as follows:  

```
julia>using ABM4OSN

julia>run!(Simulation())
```

The `run!` function creates a temporary directory where the current state of the simulation is saved every 10 % of the simulation. If the simulation is interrupted at any point, the simulation can be resumed by executing:  

`julia>run_resume!("<path/to/tmp_file>")`

After the simulation is finished, `run!` will write the results into a newly created directory *results*.

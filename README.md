# ABM4OSN

*run large-scale agent-based simulations of online social networks*  


## Installation

To install ABM4OSN, execute:  

`(v1.3) pkg> add "https://github.com/digimuen/ABM4OSN.jl"`


## Basic functionality

You can run a simple default simulation as follows:  

```
using ABM4OSN
run!()
```

The `run!` function creates a temporary directory where the current state of the simulation is saved every 10 % of the simulation. If the simulation is interrupted at any point, it can be resumed by executing:  

```
run_resume!("<path/to/tmp_file>")
```

After the simulation is finished, `run!` will write the results into a newly created directory *results*.

![ABM4OSN workflow.](https://github.com/JohannesNakayama/ABM4OSN.jl/blob/workflow-guide/img/workflow.png)

## Manipulating parameters

Simulation parameter can be manipulated with the `Config` interface. `Config` is a type with six attributes:

  * network
  * simulation
  * opinion_threshs
  * agent_props
  * feed_props
  * mechanics

Each of these attributes is a `NamedTuple` which can be constructed with the following six functions respectively:

  * `cfg_net`
  * `cfg_sim`
  * `cfg_ot`
  * `cfg_ag`
  * `cfg_feed`
  * `cfg_mech`

Further information on these functions can be obtained via the documentation.

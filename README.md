# ABM4OSN

*run large-scale agent-based simulations of online social networks*  


## Installation

To install ABM4OSN, execute:  

`(v1.3) pkg> add "https://github.com/digimuen/ABM4OSN.jl"`


## Framework description

*ABM4OSN* is a framework to run large-scale agent-based simulations of opinion dynamics in online social networks. It represents the network as a simple directed graph of pre-configured agents which interact with each other. Based on these interactions, the agents change their internal opinion on each tick of the simulation. The quantification of opinions follows the bounded confidence approach of Deffuant et al. with slight modifications as opinions are represented through a floating number in the interval \[-1;1\]. The framework facilitates conducting batchruns of configurations for investigating the impact of the particular thresholds which are derived from Deffuant et al. and several more factors and mechanisms that are perceivable in social media environments. It is also intended to run several repetitions of a particular configuration to enable for determining confidence intervals for certain simulation cases. Results of the simulations are initially saved in .jld2 transfer format, an appropriate function for generating a dataframe for further evaluation in R is provided along with the ability to repeat a particular run with extensive tracking. In this way it is possible to perform visualizations of opinion and network dynamics for the most exemplaric run of several repetitions with the same configuration.


## First steps

All simulation parameters are set at a default value, so you can run a very simple default simulation without specifying simulation parameters by yourself. This can be executed in the Julia REPL as follows:

```
julia> using ABM4OSN

julia> run!()
..........
---
Finished simulation run with the following specifications:

        Config((agent_count = 100, growth_rate = 4, new_follows = 4), (n_iter = 100, max_inactive_ticks = 2, logging = false, repcount = 1), (like = 0.2, share = 0.3, backfire = 0.5, check_unease = 0.4, follow = 0.3, unfollow = 0.5), (own_opinion_weight = 0.95, check_decrease = 0.9, inclin_interact_lambda = 3.2188758248682006, unfollow_rate = 0.05, min_input_count = 0, mean_desired_input_count = 100), (feed_size = 15, post_decay = 0.5), (dynamic_net = false, like = true, dislike = false, share = true))
---
Simulation{Config, Any, Any, DataFrame, Any, Array{AbstractGraph}}

julia> convert_results()
```

The function `run!` will create a directory named *results* and write the default simulation results to a .jld file within this directory. `convert_results` creates a directory named *dataexchange*, unpacks the .jld2 file from the *results* folder and writes the data into the *dataexchange* directory in more generic formats (.csv and .gml). From there, the data can be analyzed with a framework of ones choice.

## Workflow

To create experiments with *ABM4OSN*, you can follow this workflow:

!["ABM4OSN workflow."](https://github.com/digimuen/ABM4OSN.jl/blob/workflow-guide/img/workflow.png)



### 1) Configuration

Simulation parameters can be manipulated with the `Config` interface. `Config` is a type with six attributes:

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

**Example**

This is the configuration for a simulation of a network with *like* and *share* functionalities.

```
cfg = Config(
    network=cfg_net(
        agent_count=100,
        new_follows=2
    ),
    simulation=cfg_sim(
        n_iter=1000
    ),
    opinion_threshs=cfg_ot(
        like=0.3,
        share=0.2,
        backfire=0.3
    ),
    agent_props=cfg_ag(
        own_opinion_weight=0.95,
        mean_desired_input_count=10
    ),
    feed_props=cfg_feed(
        feed_size=10,
        post_decay=0.5
    ),
    mechanics=cfg_mech(
        dynamic_net=false,
        like=true,
        dislike=false,
        share=true
    )
)
```

### 2) Simulation

The next step is to create an instance of type `Simulation` which requires a `Config` object (like the one created in the first step).

```
sim = Simulation(config=cfg)
```

### 3) Run the simulation

The `Simulation` object is then given to the `run!` function. The `run!` function updates the result attributes of the `Simulation` object and writes the resulting data to a folder named *results*. By default, the .jld filename will be `_.jld`; this can be altered with the `name` parameter.

```
run!(sim, name="example_simulation")
```

### 5) Analyze simulation outcomes (coming soon)

The results of a single simulation with one or many repetitions as well as entire batch runs using various configurations are preliminary stored in the .jld2 format. The function `evaluate_results` can be used for calculating manifold measures on network and opinion dynamics of the simulations and storing them in a .csv file for further examination purposes.

```
evaluate_results(path="/path/to/example_simulationrun.jld2")
```

### 6) Determine an exemplary run of a repeated simulation run for repeating an extensively tracked run of it (coming soon)

When several repetitions of one and the same configuration have been performed it is necessary to determine the most exemplaric run for perform extensive tracking on it. The function `repeat_exemplary_run` helps with identifying the most representative run and repeats it with extensive logging.

```
repeat_exemplary_run(path="/path/to/example_simulationrun.jld2")
```

### 4) Convert the results

As the results are stored in .jld2 format first, there is an additional convenience function called `convert_results` which converts the logging format and graph data to .csv and to .gml format respectively and write them into a directory called *data_exchange*.

```
convert_results(specific_run="example_simulation.jld2")
```

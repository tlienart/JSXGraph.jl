# JSXGraph

| [MacOS/Linux] | Coverage | Documentation |
| :-----------: | :------: | :-----------: |
| [![Build Status](https://travis-ci.org/tlienart/JSXGraph.jl.svg?branch=master)](https://travis-ci.org/tlienart/JSXGraph.jl) | [![codecov.io](http://codecov.io/github/tlienart/JSXGraph.jl/coverage.svg?branch=master)](http://codecov.io/github/tlienart/JSXGraph.jl?branch=master) | WIP

[jsxgraph](https://github.com/jsxgraph/jsxgraph) is a nice project to have interactive plots in the browser, it's a bit like Plotly except more geared towards maths and interactivity.

This package aims to help generate JSXGraph code that can then be plugged in a statically served website (for instance one you would generate via [Franklin.jl](https://github.com/tlienart/Franklin.jl)).

## Dependencies

The `src/libs` folder contains a copy of `jsxgraph.css` and `jsxgraphcore.js`. Both are provided "as is", but you could also download your own versions from [the original repo](https://github.com/jsxgraph/jsxgraph/tree/master/update_cdnjs).

## License

* the original JSXGraph package is released under a dual LGPL/MIT license.
* this package (which just wraps around JSXGraph) is released under the MIT license.

## FAQ

### Shouldn't you just write Javascript?

Probably.

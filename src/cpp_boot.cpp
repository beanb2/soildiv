#include <Rcpp.h>
#include <random>
#include <iostream>
using namespace Rcpp;

// This function is a low overhead pixel count simulator for use in the
// soil diversity bootstrap. More details are provided in the documentation
// for the resamp function.

// [[Rcpp::export]]
IntegerMatrix resamp_cpp(IntegerVector x, int boot, int seed) {

  // Determine the total number of pixels.
  int n = sum(x);

  // Determine the total number of unique pixel types.
  int l = x.length();

  // Create a matrix of counts where the rows represent the number
  // of desired bootstrap samples and the columns represent the
  // unique pixel types.
  IntegerMatrix v (boot, l);

  // Define a random number generator for a discrete distribution where the
  // probability of simulating different numbers is defined by pixel counts.
  // (Pixel count for each position divided by total number of pixels).
  std::mt19937 gen;
  std::discrete_distribution<int> dist(std::begin(x), std::end(x));

  // c++ requires a seed definition so we generate it R and pass it here.
  gen.seed(seed);

  // Loop through the total number of pixels and the total number
  // of simulations.
  int temp = 0;
  for( int j = 0; j < boot; j++){
    for( int i = 0; i < n; i++){
      // Take a weighted sample of the vector positions.
      temp = dist(gen);
      v(j, temp) += 1;
    }
  }

  return v;
}


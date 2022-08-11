#include <Rcpp.h>
#include <random>
#include <iostream>
using namespace Rcpp;

// This function is a low overhead pixel count simulator for use in the
// soil diversity bootstrap. More details are provided in the documentation
// for the resamp function.

// [[Rcpp::export]]
IntegerMatrix resamp_cpp(NumericVector x, int boot) {

  // Determine the total number of pixels.
  int n = sum(x);

  NumericVector probs = cumsum(x);

  probs = probs / n;

  // Determine the total number of unique pixel types.
  int l = x.length();

  // Create a matrix of counts where the rows represent the number
  // of desired bootstrap samples and the columns represent the
  // unique pixel types.
  IntegerMatrix v (boot, l);

  // Loop through the total number of pixels and the total number
  // of simulations.
  int temp = 0;
  LogicalVector hits = probs < 0;
  for( int j = 0; j < boot; j++){
    for( int i = 0; i < n; i++){

      // Determine number of probability threshold a random uniform number
      // exceeds.
      hits = probs < unif_rand();

      // The number of hits determines the vector position.
      temp = sum(hits);

      v(j, temp) += 1;
    }
  }

  return v;
}


#!/bin/bash
docker run  --rm  -v $(realpath data):/config/ iso_gen 

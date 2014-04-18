#!/bin/bash
for i in `seq 1 10`;
do
  echo $i
  rspec ./spec/requests/users_profile_spec.rb
done    


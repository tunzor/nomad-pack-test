Congratulations on deploying [[ .nomad_pack.pack.name ]]! 
Navigate to the HashiCups UI on port [[ .hashicups.nginx_port ]] of the Nomad client running the job.

You can find the allocation ID with:
nomad job status hashicups | grep -A 3 -i allocations

Then display the URL of each service with the allocation ID from above:
nomad alloc status <ALLOC_ID> | grep -A 8 -i allocation

View the HashiCups UI by navigating to the nginx service listed in the output of the alloc command above.
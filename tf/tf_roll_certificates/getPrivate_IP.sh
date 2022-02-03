#/bin/bash
# define variables inherited from this project.
ASG="redirect-all-domains"
REGION="eu-central-1"
# make sure that the input parameter exists, or else throw and error and a human-readable message
if [[ -z $1 ]];
then
  echo "Input file not found or empty" >&2 && exit 1
else
  IP=$1 && shift
  # Parse the input and assign it to a local variable
  eval "$(jq -r '@sh "IP=\(.ip)"')"
fi

# create local variable lists, to be populated by this script
id=""
ids=""

# begin loop to populate existing instance IDs found in the ASG
while [ "$ids" = "" ]; do
  ids=$(aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names $ASG \
                                                     --region $REGION \
                                                     --query AutoScalingGroups[].Instances[].InstanceId \
                                                     --output text)
  sleep 1
done

# loop through these instances to get their IP and ID in pairs, and retrieve the ID when the private IP matches
for ID in $ids;
do
    ec2_ip=$(aws ec2 describe-instances --instance-ids $ID \
                                        --region $REGION \
                                        --query Reservations[].Instances[].PrivateIpAddress \
                                        --output text)
    if [ "$IP" == "$ec2_ip" ]
      then id="$ID" && echo $ID > ./id_artifact.txt && break
    else
      continue
    fi
    # create a JSON object and pass it back to Terraform
    jq -n --arg ip_address "$IP" \
          --arg instance_id "$id" \
      '{"ip_address":$ip, "instance_id":$id}'
done

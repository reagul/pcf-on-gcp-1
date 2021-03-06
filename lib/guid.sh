# get the guid for a staged products/jobs in ops manager
#    output the guid

product_guid () {
  product=$1
  login_ops_manager > /dev/null
  curl -qs --insecure "${OPS_MANAGER_API_ENDPOINT}/staged/products" -H "Authorization: Bearer ${UAA_ACCESS_TOKEN}" -H "Accept: application/json" | jq --raw-output ".[] | select( .type == \"$product\" ) .guid"
}

job_guid () {
  product=$1
  job=$2
  login_ops_manager > /dev/null
  product_guid=`product_guid $product`
  curl -qs --insecure "${OPS_MANAGER_API_ENDPOINT}/staged/products/$product_guid/jobs" -H "Authorization: Bearer ${UAA_ACCESS_TOKEN}" -H "Accept: application/json" | jq --raw-output ".jobs [] | select( .name == \"$job\" ) .guid"
}

REGISTRY=$(oc get service docker-registry --template '{{.spec.clusterIP}}')
TOKEN=P4-uqVt27QfVeVgZmS0jx4w163Ry3GBz_MVcreTF274
for image in $(docker images | sed -e '1d'| awk '{printf "%s:%s\n", $1, $2 }'); do 
   NEW_IMAGE=$(echo ${image} | awk -F: '{print $1}' | sed -e 's/registry.access.redhat.com//g' | sed -e "s|^|${REGISTRY}:5000|"); 
   CURRENT_TAG=$(echo ${image} | awk -F: '{print $2}') 
   docker tag ${image} ${NEW_IMAGE}:${CURRENT_TAG};
   docker push ${NEW_IMAGE}:${CURRENT_TAG};  
done

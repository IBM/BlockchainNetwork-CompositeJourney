#!/bin/bash

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
# http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Exit on first error, print all commands.
set -e

# Grab the current directory.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

pullFabricImage() {
    local imageName="$1"
    local imageTag="$2"
    docker pull hyperledger/fabric-${imageName}:${imageTag}
    #docker tag hyperledger/fabric-${imageName}:${imageTag} hyperledger/fabric-${imageName}
}

# Pull Hyperledger Fabric base images.
for imageName in peer orderer ccenv; do
    pullFabricImage ${imageName} 1.2.1
done

# Pull Hyperledger Fabric CA images.
pullFabricImage ca 1.2.1

# Pull Hyperledger third-party images.
pullFabricImage couchdb 0.4.10
